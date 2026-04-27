// ENHANCED UI: Complete premium home page with staggered animations,
// glassmorphism effects, and polished micro-interactions

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/services/notification_service.dart';
import '../controllers/home_controller.dart';
import '../widgets/currently_reading_card.dart';
import '../widgets/insights_grid.dart';
import '../widgets/minimal_book_row_card.dart';
import '../widgets/horizontal_book_list.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../../library/pages/library_page.dart';
import '../../discussions/pages/discussions_page.dart';
import '../../profile/pages/profile_page.dart';
import '../../profile/controllers/profile_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  late AnimationController _headerAnimController;
  late AnimationController _contentAnimController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();

    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _headerFade = CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeOut,
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeOutCubic,
    ));

    _contentAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _contentFade = CurvedAnimation(
      parent: _contentAnimController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _headerAnimController.forward();

      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _contentAnimController.forward();
      });

      final notifService = ref.read(notificationServiceProvider);
      notifService.requestPermissions();
      notifService.scheduleDailyReminders();
    });
  }

  @override
  void dispose() {
    _headerAnimController.dispose();
    _contentAnimController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex != 0) {
      Widget bodyContent;
      if (_currentIndex == 1) {
        bodyContent = const LibraryPage();
      } else if (_currentIndex == 2) {
        bodyContent = const DiscussionsPage();
      } else if (_currentIndex == 3) {
        bodyContent = const ProfilePage();
      } else {
        bodyContent = Center(
          child: Text(
            "Tab $_currentIndex Content",
            style: const TextStyle(color: Colors.white),
          ),
        );
      }

      return Scaffold(
        backgroundColor: const Color(0xFF0F1626),
        body: bodyContent,
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      );
    }

    final currentProgress = ref.watch(currentProgressProvider);
    final insights = ref.watch(insightsProvider);
    final recommendedBooks = ref.watch(recommendedBooksProvider);
    final trendingBooks = ref.watch(trendingBooksProvider);
    final libraryBooks = ref.watch(libraryBooksProvider);
    final profileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1626),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SlideTransition(
                position: _headerSlide,
                child: FadeTransition(
                  opacity: _headerFade,
                  child: _buildPremiumHeader(context, profileAsync),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _contentFade,
                child: Column(
                  children: [
                    // ✅ FIXED CURRENTLY READING
                    _buildAsyncWidget(
                      asyncValue: currentProgress,
                      builder: (data) {
                        if (data == null) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom: context.responsive.sp(28)),
                            child: _buildEmptyReadingState(context),
                          );
                        }

                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: context.responsive.sp(28)),
                          child: CurrentlyReadingCard(progress: data),
                        );
                      },
                    ),

                    _buildAsyncWidget(
                      asyncValue: insights,
                      builder: (data) => Padding(
                        padding: EdgeInsets.only(
                            bottom: context.responsive.sp(28)),
                        child: InsightsGrid(insights: data),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ EMPTY STATE ADDED
  Widget _buildEmptyReadingState(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.responsive.wp(20),
      ),
      padding: EdgeInsets.all(context.responsive.sp(20)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.menu_book_rounded,
              color: Color(0xFFB062FF), size: 28),
          const SizedBox(height: 12),
          const Text(
            "Start your reading journey 📚",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Pick a book and begin building your knowledge habit.",
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader(BuildContext context, AsyncValue profileAsync) {
    final String displayName = profileAsync.when(
      data: (profile) {
        final fullName = profile.name ?? '';
        return fullName.isEmpty ? 'Reader' : fullName.split(' ').first;
      },
      loading: () => '',
      error: (_, __) => 'Reader',
    );

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        "${_getGreeting()}, $displayName 👋",
        style: const TextStyle(color: Colors.white, fontSize: 22),
      ),
    );
  }

  Widget _buildAsyncWidget<T>({
    required AsyncValue<T> asyncValue,
    required Widget Function(T) builder,
  }) {
    return asyncValue.when(
      data: builder,
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Text("Error"),
    );
  }
}