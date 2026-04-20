import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/book_repository.dart';
import '../../../data/repositories/book_repository_impl.dart';
import 'reading_session_state.dart';

// Provide the repository here since we can't easily access the home one from this path level
final bookRepositoryProvider = Provider<BookRepository>((ref) => BookRepositoryImpl());

class ReadingSessionParams {
  final String bookId;
  final String chapterId;
  final int initialChunkIndex;

  const ReadingSessionParams({
    required this.bookId,
    required this.chapterId,
    required this.initialChunkIndex,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadingSessionParams &&
          runtimeType == other.runtimeType &&
          bookId == other.bookId &&
          chapterId == other.chapterId &&
          initialChunkIndex == other.initialChunkIndex;

  @override
  int get hashCode => Object.hash(bookId, chapterId, initialChunkIndex);
}

class ReadingSessionController extends AutoDisposeFamilyAsyncNotifier<ReadingSessionState, ReadingSessionParams> {
  Timer? _timer;

  @override
  FutureOr<ReadingSessionState> build(ReadingSessionParams arg) async {
    ref.onDispose(() {
      _timer?.cancel();
    });

    final chunks = await ref.read(bookRepositoryProvider).getChunks(arg.bookId, arg.chapterId);
    
    // Calculate total timer based on initial chunk's estimated minutes
    final initialChunk = chunks.isNotEmpty ? chunks[_min(arg.initialChunkIndex, chunks.length - 1)] : null;
    final initialSeconds = (initialChunk?.estimatedMinutes ?? 2) * 60;

    final initialState = ReadingSessionState(
      chunks: chunks,
      currentChunkIndex: arg.initialChunkIndex,
      remainingSeconds: initialSeconds,
    );

    _startTimer();
    return initialState;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.hasValue && !state.value!.isLoading) {
        final currentState = state.value!;
        if (currentState.remainingSeconds > 0) {
          state = AsyncData(currentState.copyWith(remainingSeconds: currentState.remainingSeconds - 1));
        } else {
          // Timer finished for this chunk (visual only, don't auto forward)
          timer.cancel(); 
        }
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
  }

  void resumeTimer() {
    if (state.hasValue && state.value!.remainingSeconds > 0) {
      _startTimer();
    }
  }

  void goToChunk(int index) {
    if (!state.hasValue) return;
    final currentState = state.value!;
    if (index >= 0 && index < currentState.chunks.length) {
      final newChunk = currentState.chunks[index];
      // reset timer for new chunk
      state = AsyncData(currentState.copyWith(
        currentChunkIndex: index,
        remainingSeconds: newChunk.estimatedMinutes * 60,
      ));
      _startTimer();
    }
  }

  void nextChunk() {
    if (!state.hasValue) return;
    final currentState = state.value!;
    final nextIndex = currentState.currentChunkIndex + 1;
    
    // Increment global chunks completed counter
    ref.read(dailyChunkGoalProvider.notifier).state++;
    
    if (nextIndex < currentState.chunks.length) {
      goToChunk(nextIndex);
    } else {
      // Session Complete
      _timer?.cancel();
      state = AsyncData(currentState.copyWith(isSessionComplete: true));
    }
  }

  void backChunk() {
    if (!state.hasValue) return;
    final currentState = state.value!;
    final prevIndex = currentState.currentChunkIndex - 1;
    if (prevIndex >= 0) {
      goToChunk(prevIndex);
    }
  }

  void updateFontSize(double newSize) {
    if (state.hasValue) {
      state = AsyncData(state.value!.copyWith(fontSize: newSize));
    }
  }

  void updateChunkMode(ChunkSizeMode mode) {
    if (state.hasValue) {
      state = AsyncData(state.value!.copyWith(chunkMode: mode));
    }
  }

  void updateThemeMode(ThemeModeType mode) {
    if (state.hasValue) {
      state = AsyncData(state.value!.copyWith(themeMode: mode));
    }
  }
}

final readingSessionControllerProvider = AsyncNotifierProvider.autoDispose.family<
    ReadingSessionController,
    ReadingSessionState,
    ReadingSessionParams>(
  ReadingSessionController.new,
);

int _min(int a, int b) => a < b ? a : b;
