import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/reading_plan_entity.dart';

class ReadingPlanController extends Notifier<ReadingPlanEntity> {
  @override
  ReadingPlanEntity build() {
    // Initial default state
    return const ReadingPlanEntity();
  }

  void updatePlan({int? dailyMinutes, int? daysPerWeek, String? preferredTime}) {
    state = state.copyWith(
      dailyMinutes: dailyMinutes,
      daysPerWeek: daysPerWeek,
      preferredTime: preferredTime,
    );
  }
}

final readingPlanProvider = NotifierProvider<ReadingPlanController, ReadingPlanEntity>(
  ReadingPlanController.new,
);

