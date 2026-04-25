import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readify_app/data/repositories/book_repository_impl.dart';
import 'package:readify_app/domain/entities/book_entity.dart';
import 'package:readify_app/domain/entities/user_stats_entity.dart';
import 'package:readify_app/domain/repositories/book_repository.dart';

// ── Repository Provider ──────────────────────────────────────────────────────
// Switched from MockBookRepository to real BookRepositoryImpl.
// Every provider below automatically uses the real API now.
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepositoryImpl();
});

// ── Home Screen Providers ─────────────────────────────────────────────────────
final currentProgressProvider = FutureProvider<UserProgressEntity>((ref) {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getCurrentProgress();
});

final insightsProvider = FutureProvider<InsightsEntity>((ref) {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getDailyInsights();
});

final recommendedBooksProvider = FutureProvider<List<BookEntity>>((ref) {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getRecommendedBooks();
});

final trendingBooksProvider = FutureProvider<List<BookEntity>>((ref) {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getTrendingBooks();
});

final libraryBooksProvider = FutureProvider<List<BookEntity>>((ref) {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getLibraryBooks();
});

