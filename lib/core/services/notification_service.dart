import 'dart:convert';
import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final deepLinkPayloadProvider = StateProvider<String?>((ref) => null);

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});

class NotificationService {
  final Ref _ref;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService(this._ref);

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationResponse,
    );

    // Check if app was launched via notification
    final NotificationAppLaunchDetails? launchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();
    
    if (launchDetails != null &&
        launchDetails.didNotificationLaunchApp &&
        launchDetails.notificationResponse != null) {
      final payload = launchDetails.notificationResponse!.payload;
      if (payload != null) {
        log('App launched from notification with payload: $payload');
        _ref.read(deepLinkPayloadProvider.notifier).state = payload;
      }
    }
  }

  void _onNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      log('Foreground notification tapped with payload: ${response.payload}');
      _ref.read(deepLinkPayloadProvider.notifier).state = response.payload;
    }
  }

  Future<void> requestPermissions() async {
    final bool? androidResult = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    log('Android notification permission requested: $androidResult');
    
    // Exact alarms for Android 12+ (Schedule reminders)
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  NotificationDetails _getNotificationDetails({String? channelId, String? channelName}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId ?? 'readify_reminders',
        channelName ?? 'Readify Reminders',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  // --- Scheduling Methods ---

  Future<void> scheduleDailyReminders({int hour1 = 9, int hour2 = 20}) async {
    // Cancel existing daily reminders to avoid duplicates if parameters change
    await _notificationsPlugin.cancel(id: 1);
    await _notificationsPlugin.cancel(id: 2);

    final String payload = jsonEncode({'route': '/home'}); // Default home payload

    await _scheduleDailyAtTime(
      id: 1,
      title: 'Time for your next 5-minute chunk! 📖',
      body: 'Jump back into your reading session.',
      hour: hour1,
      minute: 0,
      payload: payload,
    );

    await _scheduleDailyAtTime(
      id: 2,
      title: 'Time for your next 5-minute chunk! 📖',
      body: 'Keep up with your daily reading habit.',
      hour: hour2,
      minute: 0,
      payload: payload,
    );
  }

  Future<void> _scheduleDailyAtTime({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required String payload,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute);
        
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: _getNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  Future<void> scheduleFlashcardAlert(String bookId, int pendingCount) async {
    if (pendingCount <= 0) return;
    
    // We can schedule it a few hours later, or immediately. For now let's just show an alert immediately if app is going to background,
    // or schedule it a bit later. Let's schedule it 2 hours from now as a reminder.
    final scheduledDate = tz.TZDateTime.now(tz.local).add(const Duration(hours: 2));
    final String payload = jsonEncode({'route': '/flashcards/$bookId'});

    await _notificationsPlugin.zonedSchedule(
      id: 3, // Unique ID for flashcards
      title: 'Time to review! \uD83E\uDDE0',
      body: 'You have $pendingCount cards due for review. Quick flip?',
      scheduledDate: scheduledDate,
      notificationDetails: _getNotificationDetails(channelId: 'readify_flashcards', channelName: 'Flashcard Alerts'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  Future<void> scheduleReadingReminder(String bookId, String chapterId, int nextChunkIndex, String previewText) async {
    // Trim preview text safely
    final safePreview = previewText.length > 50 ? '${previewText.substring(0, 47)}...' : previewText;
    
    // Schedule for 1 hour from now or next morning
    final scheduledDate = tz.TZDateTime.now(tz.local).add(const Duration(hours: 4));
    
    final payloadMap = {
      'route': '/read/$bookId/$chapterId',
      'extra': {'initialChunkIndex': nextChunkIndex}
    };
    final String payload = jsonEncode(payloadMap);

    await _notificationsPlugin.zonedSchedule(
      id: 4, // Unique ID for reading preview
      title: 'Next up on your reading list \uD83D\uDCD6',
      body: safePreview,
      scheduledDate: scheduledDate,
      notificationDetails: _getNotificationDetails(channelId: 'readify_chunk_preview', channelName: 'Reading Previews'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  Future<void> showTestNotification() async {
    final payloadMap = {
      'route': '/home', // Fallback Route for test
    };
    await _notificationsPlugin.show(
      id: 99,
      title: 'Test Notification \uD83D\uDE80',
      body: 'Deep link Test Payload',
      notificationDetails: _getNotificationDetails(),
      payload: jsonEncode(payloadMap),
    );
  }
}

@pragma('vm:entry-point')
void _onBackgroundNotificationResponse(NotificationResponse response) {
  // Can handle background actions here, but generally launchDetails is enough
}

