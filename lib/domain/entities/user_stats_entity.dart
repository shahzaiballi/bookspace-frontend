class UserProgressEntity {
  final String bookId;
  final String title;
  final String author;
  final String imageUrl;
  final int progressPercent;

  const UserProgressEntity({
    required this.bookId,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.progressPercent,
  });
}

class InsightsEntity {
  final int cardsDue;
  final int readTodayMinutes;
  final int dayStreak;

  const InsightsEntity({
    required this.cardsDue,
    required this.readTodayMinutes,
    required this.dayStreak,
  });
}

