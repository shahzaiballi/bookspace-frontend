import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/user_profile_entity.dart';
import '../../../../domain/repositories/profile_repository.dart';
import '../../../../data/repositories/mock_profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return MockProfileRepository();
});

class ProfileController extends AsyncNotifier<UserProfileEntity> {
  @override
  FutureOr<UserProfileEntity> build() async {
    final repo = ref.watch(profileRepositoryProvider);
    return repo.getUserProfile();
  }
}

final profileControllerProvider = AsyncNotifierProvider<ProfileController, UserProfileEntity>(
  ProfileController.new,
);

// Toggle state providers for settings
final notificationsEnabledProvider = StateProvider<bool>((ref) => true);
final darkModeEnabledProvider = StateProvider<bool>((ref) => true);
