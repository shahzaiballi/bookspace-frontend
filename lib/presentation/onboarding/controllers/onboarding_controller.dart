import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/onboarding_mock_data.dart';
import '../../../domain/entities/onboarding_entity.dart';

/// Provider containing the mock data list
final onboardingItemsProvider = Provider<List<OnboardingEntity>>((ref) {
  return OnboardingMockData.items;
});

/// StateProvider tracking the current index of the PageView
final onboardingCurrentPageIndexProvider = StateProvider<int>((ref) => 0);

