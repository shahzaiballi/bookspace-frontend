import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/mock_library_repository.dart';
import '../../../domain/entities/library_book_entity.dart';
import '../../../domain/repositories/library_repository.dart';

// Provider for the Data layer Repository
final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  return MockLibraryRepository();
});

// State provider for the segmented control index (0: All, 1: Favorites, 2: In Progress, 3: Completed)
final libraryFilterProvider = StateProvider<int>((ref) => 0);

// Provides raw library list
final rawLibraryProvider = FutureProvider<List<LibraryBookEntity>>((ref) {
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.getUserLibrary();
});

// Provides the filtered library list based on the active segmented control index
final filteredLibraryProvider = FutureProvider<List<LibraryBookEntity>>((ref) async {
  final allBooks = await ref.watch(rawLibraryProvider.future);
  final filterIndex = ref.watch(libraryFilterProvider);

  switch (filterIndex) {
    case 1: // Favorites
      return allBooks.where((book) => book.isFavorite).toList();
    case 2: // In Progress
      return allBooks.where((book) => book.status == LibraryStatus.inProgress).toList();
    case 3: // Completed
      return allBooks.where((book) => book.status == LibraryStatus.completed).toList();
    case 0: // All Books
    default:
      return allBooks;
  }
});
