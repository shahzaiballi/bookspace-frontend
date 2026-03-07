class ChapterEntity {
  final String id;
  final String title;
  final int chapterNumber;
  final int durationInMinutes;
  final String pageRange;
  final bool isCompleted;
  final bool isActive; // Identifies the currently reading chapter

  const ChapterEntity({
    required this.id,
    required this.title,
    required this.chapterNumber,
    required this.durationInMinutes,
    required this.pageRange,
    this.isCompleted = false,
    this.isActive = false,
  });
}
