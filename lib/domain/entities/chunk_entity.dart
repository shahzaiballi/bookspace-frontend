class ChunkEntity {
  final String id;
  final String text;
  final int estimatedMinutes;
  final int chunkIndex;

  const ChunkEntity({
    required this.id,
    required this.text,
    required this.estimatedMinutes,
    required this.chunkIndex,
  });

  ChunkEntity copyWith({
    String? id,
    String? text,
    int? estimatedMinutes,
    int? chunkIndex,
  }) {
    return ChunkEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      chunkIndex: chunkIndex ?? this.chunkIndex,
    );
  }
}

