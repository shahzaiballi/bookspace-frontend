import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/mock_book_repository.dart';
import '../../../domain/entities/book_entity.dart';
import '../../../domain/entities/user_stats_entity.dart';
import '../../../domain/repositories/book_repository.dart';

// Provider for the Data layer Repository
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return MockBookRepository();
});

// Provides current reading progress
final currentProgressProvider = FutureProvider<UserProgressEntity>((ref) {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getCurrentProgress();
});

// Provides daily insights
final insightsProvider = FutureProvider<InsightsEntity>((ref) {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getDailyInsights();
});

// Provides recommended list
final recommendedBooksProvider = FutureProvider<List<BookEntity>>((ref) {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getRecommendedBooks();
});

// Provides trending list
final trendingBooksProvider = FutureProvider<List<BookEntity>>((ref) {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getTrendingBooks();
});

// Provides library list
final libraryBooksProvider = FutureProvider<List<BookEntity>>((ref) {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getLibraryBooks();
});
