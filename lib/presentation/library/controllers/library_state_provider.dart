import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteNotifier extends StateNotifier<List<String>> {
  FavoriteNotifier() : super([]); // In a real app, initialize from local storage or remote

  void toggleFavorite(String bookId) {
    if (state.contains(bookId)) {
      state = state.where((id) => id != bookId).toList();
    } else {
      state = [...state, bookId];
    }
  }

  bool isFavorite(String bookId) {
    return state.contains(bookId);
  }
}

final favoriteBooksProvider = StateNotifierProvider<FavoriteNotifier, List<String>>((ref) {
  return FavoriteNotifier();
});

// Using a simple provider for library books that can be 'deleted' for the session UI
class DeletedBooksNotifier extends StateNotifier<List<String>> {
  DeletedBooksNotifier() : super([]);

  void deleteBook(String bookId) {
    if (!state.contains(bookId)) {
      state = [...state, bookId];
    }
  }
}

final deletedBooksProvider = StateNotifierProvider<DeletedBooksNotifier, List<String>>((ref) {
  return DeletedBooksNotifier();
});
