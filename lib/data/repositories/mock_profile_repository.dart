import '../../domain/entities/user_profile_entity.dart';
import '../../domain/entities/achievement_entity.dart';
import '../../domain/repositories/profile_repository.dart';

class MockProfileRepository implements ProfileRepository {
  @override
  Future<UserProfileEntity> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return const UserProfileEntity(
      id: 'u1',
      name: 'Ali Thompson',
      email: 'ali.thompson@email.com',
      avatarUrl: 'https://i.pravatar.cc/150?u=ali',
      booksRead: 12,
      totalPages: 3847,
      currentStreak: 7,
      isAvidReader: true,
      achievements: [
        AchievementEntity(
          id: 'a1',
          title: 'First Week Streak',
          description: 'Read for 7 consecutive days',
          iconCode: 'trophy',
          isUnlocked: true,
        ),
        AchievementEntity(
          id: 'a2',
          title: 'Bookworm',
          description: 'Completed 10 books',
          iconCode: 'books',
          isUnlocked: true,
        ),
        AchievementEntity(
          id: 'a3',
          title: 'Consistent Reader',
          description: 'Met daily goal 30 times',
          iconCode: 'target',
          isUnlocked: true,
        ),
      ],
    );
  }

  @override
  Future<void> updateNotificationPreference(bool enabled) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Simulated preference update
  }

  @override
  Future<void> updateDarkModePreference(bool enabled) async {
    await Future.delayed(const Duration(milliseconds: 200));
     // Simulated preference update
  }
}
