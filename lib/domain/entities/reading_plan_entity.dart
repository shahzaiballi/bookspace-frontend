class ReadingPlanEntity {
  final int dailyMinutes;
  final int daysPerWeek;
  final String preferredTime;

  const ReadingPlanEntity({
    this.dailyMinutes = 45,
    this.daysPerWeek = 5,
    this.preferredTime = 'Evening',
  });

  ReadingPlanEntity copyWith({
    int? dailyMinutes,
    int? daysPerWeek,
    String? preferredTime,
  }) {
    return ReadingPlanEntity(
      dailyMinutes: dailyMinutes ?? this.dailyMinutes,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      preferredTime: preferredTime ?? this.preferredTime,
    );
  }
}

