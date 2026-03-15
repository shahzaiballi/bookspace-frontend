import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added import for Riverpod
import '../../presentation/onboarding/pages/onboarding_page.dart';
import '../../presentation/auth/pages/login_page.dart';
import '../../presentation/auth/pages/signup_page.dart';
import '../../presentation/auth/pages/forgot_password_page.dart';
import '../../presentation/auth/pages/otp_verification_page.dart';
import '../../presentation/home/pages/home_page.dart';
import '../../presentation/home/pages/all_books_page.dart';
import '../../presentation/book_detail/pages/book_detail_page.dart';
import '../../presentation/chapters/pages/chapter_list_page.dart';
import '../../presentation/discussions/pages/discussion_detail_page.dart'; 
import '../../presentation/discussions/pages/new_discussion_page.dart';
import '../../presentation/profile/pages/reading_plan_page.dart';
import '../../presentation/book_summary/pages/chapter_summary_page.dart';
import '../../presentation/chunked_reading/pages/chunked_reading_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  // The rootNavigatorKey is already defined globally, so we don't re-initialize it here.
  // If the intent was to make it local to the provider, the global declaration would be removed.
  // Sticking to the provided snippet, which seems to re-assign a global key,
  // but for a `final` key, this would be an error.
  // Assuming the instruction meant to use the existing global key.

  final GoRouter appRouter = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/forgot_password',
        name: 'forgot_password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/verify_otp',
        name: 'verify_otp',
        builder: (context, state) => const OtpVerificationPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/all_books/:category',
        name: 'all_books',
        builder: (context, state) {
          final category = state.pathParameters['category']!;
          return AllBooksPage(category: category);
        },
      ),
      GoRoute(
        path: '/chapters/:id',
        name: 'chapters',
        builder: (context, state) {
          final bookId = state.pathParameters['id']!;
          return ChapterListPage(bookId: bookId);
        },
      ),
      GoRoute(
        path: '/book_detail/:id',
        name: 'book_detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!; // Changed from bookId to id
          return BookDetailPage(bookId: id);
        },
      ),
      GoRoute(
        path: '/book_summary/:id',
        name: 'book_summary',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ChapterSummaryPage(bookId: id);
        },
      ),
      GoRoute(
        path: '/discussions/:id',
        name: 'discussions', // Added name for the route
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DiscussionDetailPage(postId: id);
        },
      ),
      GoRoute(
        path: '/new_discussion',
        name: 'new_discussion',
        builder: (context, state) => const NewDiscussionPage(),
      ),
      GoRoute(
         path: '/reading_plan',
         name: 'reading_plan',
         builder: (context, state) => const ReadingPlanPage(),
      ),
      GoRoute(
        path: '/read/:bookId/:chapterId',
        name: 'chunked_reading',
        builder: (context, state) {
          final bookId = state.pathParameters['bookId']!;
          final chapterId = state.pathParameters['chapterId']!;
          final extra = state.extra as Map<String, dynamic>?;
          final initialChunkIndex = extra?['initialChunkIndex'] as int? ?? 0;
          
          return ChunkedReadingScreen(
            bookId: bookId, 
            chapterId: chapterId,
            initialChunkIndex: initialChunkIndex,
          );
        },
      ),
    ],
  );
  return appRouter;
});
