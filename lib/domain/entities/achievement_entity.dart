class AchievementEntity {
  final String id;
  final String title;
  final String description;
  final String iconCode; // We'll map this to a Flutter icon or image
  final bool isUnlocked;
  
  const AchievementEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.iconCode,
    this.isUnlocked = false,
  });
}
