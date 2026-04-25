import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/flashcard_entity.dart';
import '../../home/controllers/home_controller.dart';

// Provides the list of flashcards for a specific book
final flashcardsProvider = FutureProvider.family<List<FlashcardEntity>, String>((ref, bookId) async {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getFlashcards(bookId);
});

// Provides the current active flashcard index for a specific book
class FlashcardIndexNotifier extends StateNotifier<int> {
  FlashcardIndexNotifier() : super(0);

  void nextCard(int totalCards) {
    if (state < totalCards) {
      state++;
    }
  }

  void reset() {
    state = 0;
  }
}

final flashcardIndexProvider = StateNotifierProvider.family<FlashcardIndexNotifier, int, String>((ref, bookId) {
  return FlashcardIndexNotifier();
});

// Provides the flip state of the current card (true if showing back, false if front)
class FlashcardFlipNotifier extends StateNotifier<bool> {
  FlashcardFlipNotifier() : super(false);

  void flip() {
    state = !state;
  }

  void reset() {
    state = false;
  }
}

final flashcardFlipProvider = StateNotifierProvider.family<FlashcardFlipNotifier, bool, String>((ref, bookId) {
  return FlashcardFlipNotifier();
});

