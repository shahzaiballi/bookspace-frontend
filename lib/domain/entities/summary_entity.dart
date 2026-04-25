class SummaryEntity {
  final String id;
  final int chapterNumber;
  final String title;
  final String summaryContent;
  final List<String> keyTakeaways;
  final bool isLocked;

  const SummaryEntity({
    required this.id,
    required this.chapterNumber,
    required this.title,
    required this.summaryContent,
    required this.keyTakeaways,
    this.isLocked = false,
  });
}

