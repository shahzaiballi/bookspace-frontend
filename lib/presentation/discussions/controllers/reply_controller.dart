import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/post_entity.dart';
import '../../../../domain/entities/reply_entity.dart';
import 'discussion_controller.dart'; // To access repository provider

// Unique Provider for fetching the detailed post given an ID
final postDetailProvider = FutureProvider.family.autoDispose<PostEntity, String>((ref, postId) async {
  final repo = ref.watch(discussionRepositoryProvider);
  return repo.getPostDetails(postId);
});

// AsyncNotifier specifically to manage the replies feed for a single post
class ReplyController extends AutoDisposeFamilyAsyncNotifier<List<ReplyEntity>, String> {
  @override
  FutureOr<List<ReplyEntity>> build(String arg) async {
    final repo = ref.watch(discussionRepositoryProvider);
    return repo.getReplies(arg);
  }

  // Adding a mock method to insert a dynamic reply into the current list immediately
  Future<void> addReply(String content) async {
    if (content.trim().isEmpty) return;

    final currentReplies = state.value ?? [];
    
    // Create an instant fake reply mimicking the current user
    final newReply = ReplyEntity(
      id: 'r_mock_${DateTime.now().millisecondsSinceEpoch}',
      userName: 'You',
      userAvatarUrl: 'https://i.pravatar.cc/150?u=current_user',
      timeAgo: 'Just now',
      content: content,
      likesCount: 0,
    );
     
    // Update Riverpod State to instantly show it on the top
    state = AsyncData([newReply, ...currentReplies]);
  }
}

final replyControllerProvider = AsyncNotifierProvider.autoDispose.family<ReplyController, List<ReplyEntity>, String>(
  ReplyController.new,
);
