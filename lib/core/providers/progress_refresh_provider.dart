/// lib/core/providers/progress_refresh_provider.dart
///
/// A dedicated lightweight provider that acts as a "refresh signal".
/// When incremented, all providers that watch it will automatically
/// refetch their data — giving us real-time updates without circular imports.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A simple counter that acts as a refresh trigger.
/// Increment this to force all progress-dependent providers to refetch.
final progressRefreshProvider = StateProvider<int>((ref) => 0);
/// Helper extension to easily trigger a global progress refresh.
extension ProgressRefreshExtension on Ref {
  void triggerProgressRefresh() {
    try {
      read(progressRefreshProvider.notifier).state++;
    } catch (_) {
      // Safe to ignore if provider is not available
    }
  }
}

/// Helper extension on WidgetRef for use inside widgets.
extension ProgressRefreshWidgetExtension on WidgetRef {
  void triggerProgressRefresh() {
    read(progressRefreshProvider.notifier).state++;
  }
}
