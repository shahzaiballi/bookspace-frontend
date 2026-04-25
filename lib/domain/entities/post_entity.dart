class PostEntity {
  final String id;
  final String userName;
  final String userAvatarUrl;
  final String timeAgo;
  final String? chapterTag;
  final String title;
  final String contentSnippet;
  final int likesCount;
  final int commentsCount;
  final String bookId;

  const PostEntity({
    required this.id,
    required this.userName,
    required this.userAvatarUrl,
    required this.timeAgo,
    this.chapterTag,
    required this.title,
    required this.contentSnippet,
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.bookId,
  });
}

