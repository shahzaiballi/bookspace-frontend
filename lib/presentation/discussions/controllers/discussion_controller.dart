import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/post_entity.dart';
import '../../../../domain/repositories/discussion_repository.dart';
import '../../../../data/repositories/mock_discussion_repository.dart';

// Provider for the repository
final discussionRepositoryProvider = Provider<DiscussionRepository>((ref) {
  return MockDiscussionRepository();
});

// Provider for the currently selected filter tab
final discussionFilterProvider = StateProvider<String>((ref) => 'All');

// AsyncNotifier to fetch posts based on the filter
class DiscussionController extends AutoDisposeAsyncNotifier<List<PostEntity>> {
  @override
  FutureOr<List<PostEntity>> build() async {
    // Watch the filter provider so this re-builds automatically when it changes
    final filter = ref.watch(discussionFilterProvider);
    final repo = ref.watch(discussionRepositoryProvider);
    return repo.getPosts(filter: filter);
  }
}

final discussionControllerProvider = AsyncNotifierProvider.autoDispose<DiscussionController, List<PostEntity>>(
  DiscussionController.new,
);
