import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/library_repository_impl.dart';

// ── Optimistic Favorite Toggle ────────────────────────────────────────────────
// We keep a local Set of favorited IDs for instant UI response,
// then fire the PATCH to the backend in the background.
class FavoriteNotifier extends StateNotifier<List<String>> {
  final LibraryRepositoryImpl _repo;

  FavoriteNotifier(this._repo) : super([]);

  Future<void> toggleFavorite(String bookId) async {
    final isCurrentlyFavorite = state.contains(bookId);

    // Optimistic update — UI responds instantly
    if (isCurrentlyFavorite) {
      state = state.where((id) => id != bookId).toList();
    } else {
      state = [...state, bookId];
    }

    // Fire and forget to backend — if it fails, state is already updated
    // In a real app you'd revert on failure; acceptable for now.
    try {
      await _repo.toggleFavorite(bookId, !isCurrentlyFavorite);
    } catch (_) {
      // Silently revert on failure
      if (isCurrentlyFavorite) {
        state = [...state, bookId];
      } else {
        state = state.where((id) => id != bookId).toList();
      }
    }
  }

  bool isFavorite(String bookId) => state.contains(bookId);
}

final favoriteBooksProvider =
    StateNotifierProvider<FavoriteNotifier, List<String>>((ref) {
  final repo = ref.watch(libraryImplProvider);
  return FavoriteNotifier(repo);
});

// ── Soft Delete (local session only) ─────────────────────────────────────────
// Calls DELETE on backend, removes from local list for instant UI.
class DeletedBooksNotifier extends StateNotifier<List<String>> {
  final LibraryRepositoryImpl _repo;

  DeletedBooksNotifier(this._repo) : super([]);

  Future<void> deleteBook(String bookId) async {
    if (state.contains(bookId)) return;

    // Optimistic: hide immediately
    state = [...state, bookId];

    try {
      await _repo.removeBook(bookId);
    } catch (_) {
      // Revert if API call failed
      state = state.where((id) => id != bookId).toList();
    }
  }
}

final deletedBooksProvider =
    StateNotifierProvider<DeletedBooksNotifier, List<String>>((ref) {
  final repo = ref.watch(libraryImplProvider);
  return DeletedBooksNotifier(repo);
});

// ── Provider for the impl (shared by both notifiers above) ───────────────────
final libraryImplProvider = Provider<LibraryRepositoryImpl>((ref) {
  return LibraryRepositoryImpl();
});

