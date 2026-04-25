import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/chunk_entity.dart';

enum ThemeModeType { midnight, sepia, pureDark }
enum ChunkSizeMode { quickRead, deepDive }

class ReadingSessionState {
  final List<ChunkEntity> chunks;
  final int currentChunkIndex;
  final bool isLoading;
  final String? error;
  final int remainingSeconds;
  
  // Customization State
  final double fontSize;
  final ChunkSizeMode chunkMode; 
  final ThemeModeType themeMode;
  
  final bool isSessionComplete;
  
  // Milestone counter for 5-chunk goal
  final int sessionChunksCompleted; 

  const ReadingSessionState({
    this.chunks = const [],
    this.currentChunkIndex = 0,
    this.isLoading = false,
    this.error,
    this.remainingSeconds = 120, // Default 2 minutes
    this.fontSize = 18.0, // Default medium
    this.chunkMode = ChunkSizeMode.deepDive,
    this.themeMode = ThemeModeType.midnight,
    this.isSessionComplete = false,
    this.sessionChunksCompleted = 0,
  });

  ReadingSessionState copyWith({
    List<ChunkEntity>? chunks,
    int? currentChunkIndex,
    bool? isLoading,
    String? error,
    int? remainingSeconds,
    double? fontSize,
    ChunkSizeMode? chunkMode,
    ThemeModeType? themeMode,
    bool? isSessionComplete,
    int? sessionChunksCompleted,
  }) {
    return ReadingSessionState(
      chunks: chunks ?? this.chunks,
      currentChunkIndex: currentChunkIndex ?? this.currentChunkIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      fontSize: fontSize ?? this.fontSize,
      chunkMode: chunkMode ?? this.chunkMode,
      themeMode: themeMode ?? this.themeMode,
      isSessionComplete: isSessionComplete ?? this.isSessionComplete,
      sessionChunksCompleted: sessionChunksCompleted ?? this.sessionChunksCompleted,
    );
  }
}

// StateProvider for the global 5-chunk counter
final dailyChunkGoalProvider = StateProvider<int>((ref) => 0);

