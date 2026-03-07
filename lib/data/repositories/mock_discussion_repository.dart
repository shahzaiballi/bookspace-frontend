import '../../domain/entities/post_entity.dart';
import '../../domain/entities/reply_entity.dart';
import '../../domain/repositories/discussion_repository.dart';

class MockDiscussionRepository implements DiscussionRepository {
  @override
  Future<List<PostEntity>> getPosts({String filter = 'All'}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Base mock data
    final allPosts = [
       const PostEntity(
         id: 'p1',
         userName: 'Sarah Johnson',
         userAvatarUrl: 'https://i.pravatar.cc/150?u=sarah',
         timeAgo: '2 hours ago',
         chapterTag: 'Chapter 3',
         title: 'How do you implement the 2-minute rule in daily life?',
         contentSnippet: 'I\'ve been trying to apply the 2-minute rule to my morning routine, but I\'m struggling with...',
         commentsCount: 12,
         likesCount: 24,
         bookId: 'b_1',
       ),
       const PostEntity(
         id: 'p2',
         userName: 'Michael Chen',
         userAvatarUrl: 'https://i.pravatar.cc/150?u=michael',
         timeAgo: '5 hours ago',
         chapterTag: 'Chapter 5',
         title: 'Habit stacking success stories',
         contentSnippet: 'I successfully stacked my meditation habit with my morning coffee routine. After I pour...',
         commentsCount: 8,
         likesCount: 31,
         bookId: 'b_1',
       ),
       const PostEntity(
         id: 'p3',
         userName: 'Emily Rodriguez',
         userAvatarUrl: 'https://i.pravatar.cc/150?u=emily',
         timeAgo: '1 day ago',
         chapterTag: 'Chapter 1',
         title: 'The compound effect is real!',
         contentSnippet: 'After 3 months of applying atomic habits principles, I can finally see the results.',
         commentsCount: 15,
         likesCount: 42,
         bookId: 'b_1',
       ),
       const PostEntity(
         id: 'p4',
         userName: 'David Smith',
         userAvatarUrl: 'https://i.pravatar.cc/150?u=david',
         timeAgo: '2 days ago',
         chapterTag: 'Chapter 10',
         title: 'Fixing bad habits is harder than creating new ones',
         contentSnippet: 'I found it much more difficult to stop my smartphone addiction than to start reading daily.',
         commentsCount: 34,
         likesCount: 89,
         bookId: 'b_1',
       ),
       // A dynamic post that simulates "My Posts"
       const PostEntity(
         id: 'p5',
         userName: 'You',
         userAvatarUrl: 'https://i.pravatar.cc/150?u=current_user',
         timeAgo: '5 days ago',
         chapterTag: 'Chapter 2',
         title: 'Identity shift is the key',
         contentSnippet: 'Changing your identity before changing your habits seems to be the core principle here.',
         commentsCount: 5,
         likesCount: 12,
         bookId: 'b_1',
       ),
    ];

    switch (filter) {
      case 'Popular':
        final popular = List<PostEntity>.from(allPosts);
        popular.sort((a, b) => b.likesCount.compareTo(a.likesCount));
        return popular;
      case 'Recent':
        return allPosts; // Already sorted reasonably
      case 'My Posts':
        return allPosts.where((p) => p.userName == 'You').toList();
      case 'All':
      default:
        return allPosts;
    }
  }

  @override
  Future<PostEntity> getPostDetails(String postId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final allPosts = await getPosts(filter: 'All');
    return allPosts.firstWhere((p) => p.id == postId, orElse: () => allPosts.first);
  }

  @override
  Future<List<ReplyEntity>> getReplies(String postId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Simulated realistic replies identical to design image
    if (postId == 'p1') {
      return const [
        ReplyEntity(
          id: 'r1',
          userName: 'Alex Thompson',
          userAvatarUrl: 'https://i.pravatar.cc/150?u=alex',
          timeAgo: '1 hour ago',
          content: 'Great question! I found that starting with just 2 minutes of stretching after waking up helped me build the habit. Now it\'s automatic!',
          likesCount: 8,
        ),
        ReplyEntity(
          id: 'r2',
          userName: 'Lisa Wang',
          userAvatarUrl: 'https://i.pravatar.cc/150?u=lisa',
          timeAgo: '45 min ago',
          content: 'The key is to make it ridiculously easy. I put my workout clothes next to my bed so there\'s no excuse not to start.',
          likesCount: 5,
        ),
        ReplyEntity(
          id: 'r3',
          userName: 'James Miller',
          userAvatarUrl: 'https://i.pravatar.cc/150?u=james',
          timeAgo: '20 min ago',
          content: 'I use a habit tracker app to maintain consistency. Seeing the streak motivates me to keep going!',
          likesCount: 3,
        ),
      ];
    }
    
    // Dynamic generator for other posts
    return List.generate(4, (index) => ReplyEntity(
      id: 'r_dyn_$index',
      userName: 'Reader ${index + 5}',
      userAvatarUrl: 'https://i.pravatar.cc/150?u=dyn_$index',
      timeAgo: '${index + 2} hours ago',
      content: 'I completely agree with this! Very insightful point made here regarding habit formation.',
      likesCount: index * 2 + 1,
    ));
  }
}
