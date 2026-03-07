class ReplyEntity {
  final String id;
  final String userName;
  final String userAvatarUrl;
  final String timeAgo;
  final String content;
  final int likesCount;

  const ReplyEntity({
    required this.id,
    required this.userName,
    required this.userAvatarUrl,
    required this.timeAgo,
    required this.content,
    this.likesCount = 0,
  });
}
