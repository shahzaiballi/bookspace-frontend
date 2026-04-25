import '../entities/post_entity.dart';
import '../entities/reply_entity.dart';

abstract class DiscussionRepository {
  Future<List<PostEntity>> getPosts({String filter = 'All'});
  Future<PostEntity> getPostDetails(String postId);
  Future<List<ReplyEntity>> getReplies(String postId);
}

