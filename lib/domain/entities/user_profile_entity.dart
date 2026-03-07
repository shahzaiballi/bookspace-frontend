import 'achievement_entity.dart';

class UserProfileEntity {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final int booksRead;
  final int totalPages;
  final int currentStreak;
  final bool isAvidReader;
  final List<AchievementEntity> achievements;

  const UserProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.booksRead,
    required this.totalPages,
    required this.currentStreak,
    required this.isAvidReader,
    required this.achievements,
  });
}
