import '../../domain/entities/book_entity.dart';
import '../../domain/entities/book_detail_entity.dart';
import '../../domain/entities/user_stats_entity.dart';
import '../../domain/entities/add_book_params.dart';
import '../../domain/entities/chapter_entity.dart';
import '../../domain/entities/summary_entity.dart';
import '../../domain/entities/chunk_entity.dart';
import '../../domain/repositories/book_repository.dart';

class MockBookRepository implements BookRepository {
  @override
  Future<List<ChapterEntity>> getChapters(String bookId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (bookId == 'b_1' || bookId == 'b_trending_1') {
      return const [
        ChapterEntity(id: 'c1', title: 'The Surprising Power of Atomic Habits', chapterNumber: 1, durationInMinutes: 18, pageRange: 'Pages 15-25', isCompleted: true),
        ChapterEntity(id: 'c2', title: 'How Your Habits Shape Your Identity', chapterNumber: 2, durationInMinutes: 22, pageRange: 'Pages 26-42', isCompleted: true),
        ChapterEntity(id: 'c3', title: 'How to Build Better Habits in 4 Simple Steps', chapterNumber: 3, durationInMinutes: 25, pageRange: 'Pages 43-65', isCompleted: true),
        ChapterEntity(id: 'c4', title: 'The Man Who Didn\'t Look Right', chapterNumber: 4, durationInMinutes: 20, pageRange: 'Pages 66-82', isActive: true),
        ChapterEntity(id: 'c5', title: 'The Best Way to Start a New Habit', chapterNumber: 5, durationInMinutes: 24, pageRange: 'Pages 83-105'),
        ChapterEntity(id: 'c6', title: 'Motivation is Overrated; Environment Often Matters More', chapterNumber: 6, durationInMinutes: 28, pageRange: 'Pages 106-132'),
        ChapterEntity(id: 'c7', title: 'The Secret to Self-Control', chapterNumber: 7, durationInMinutes: 21, pageRange: 'Pages 133-150'),
        ChapterEntity(id: 'c8', title: 'How to Make a Habit Irresistible', chapterNumber: 8, durationInMinutes: 26, pageRange: 'Pages 151-175'),
        ChapterEntity(id: 'c9', title: 'The Role of Family and Friends in Shaping Your Habits', chapterNumber: 9, durationInMinutes: 22, pageRange: 'Pages 176-195'),
        ChapterEntity(id: 'c10', title: 'How to Find and Fix the Causes of Your Bad Habits', chapterNumber: 10, durationInMinutes: 25, pageRange: 'Pages 196-218'),
      ];
    } else {
      // Find the original book entity to verify existence
      // Note: getRecommendations() is not defined in this mock, assuming it's a placeholder or will be added.
      // For now, we'll simulate a generic list.
      // final allBooks = await getRecommendations();
      // final _ = allBooks.firstWhere((b) => b.id == bookId, orElse: () => allBooks.first);
      
      // Simulating chapters list based on bookId
      return List.generate(
        10, // Assuming 10 chapters
        (index) => ChapterEntity(
          id: 'chap_${bookId}_$index',
          title: 'Chapter ${index + 1}',
          chapterNumber: index + 1, // Added chapterNumber for consistency
          durationInMinutes: 15 + (index % 5),
          pageRange: '${(index * 20) + 1} - ${(index + 1) * 20}',
          isCompleted: index < 3, // First 3 completed
          isActive: index == 3,  // 4th is current (renamed from isCurrent to isActive)
          // isLocked: index > 3,    // Rest are locked (ChapterEntity doesn't have isLocked)
        ),
      );
    }
  }

  @override
  Future<List<SummaryEntity>> getChapterSummaries(String bookId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Specific mock data designed precisely around image_375238.png
    if (bookId == '1' || true) { // Fallback true to ensure template works perfectly everywhere initially
      return [
        const SummaryEntity(
          id: 's1',
          chapterNumber: 1,
          title: 'The Surprising Power of Atomic Habits',
          summaryContent: 'Small habits make a meaningful difference by broadening the scope to focus on systems rather than specific goals. Over time, these 1% improvements compound into remarkable results.',
          keyTakeaways: [
             'Focus on systems, not on goals',
             'Habits are the compound interest of self-improvement',
             'A 1% improvement every day yields huge results over a year'
          ],
          isLocked: false,
        ),
        const SummaryEntity(
          id: 's2',
          chapterNumber: 2,
          title: 'How Your Habits Shape Your Identity',
          summaryContent: 'There are three levels of change: outcome change, process change, and identity change. The most effective way to change your habits is to focus not on what you want to achieve, but on who you wish to become.',
          keyTakeaways: [
             'Focus on who you wish to become, not what you want to achieve',
             'Your identity emerges out of your habits',
             'Every action is a vote for the type of person you wish to become'
          ],
          isLocked: false,
        ),
        const SummaryEntity(
          id: 's3',
          chapterNumber: 3,
          title: 'How to Build Better Habits in 4 Simple Steps',
          summaryContent: 'The habit loop consists of Cue, Craving, Response, and Reward. Mastering these four steps is essential to forming robust, unbreakable habits.',
          keyTakeaways: [
             'Cue triggers your brain to initiate a behavior',
             'Craving is the motivational force',
             'Response is the actual habit you perform'
          ],
          isLocked: false,
        ),
        const SummaryEntity(
          id: 's4',
          chapterNumber: 4,
          title: 'The Man Who Didn\'t Look Right',
          summaryContent: 'Our brain is constantly predicting outcomes based on past experiences. Sometimes we internalize cues so deeply they become invisible to us.',
          keyTakeaways: [
             'Awareness is the first step to changing a habit',
             'Use a Habits Scorecard to map out your daily routines'
          ],
          isLocked: true, // Example locked
        ),
        const SummaryEntity(
          id: 's5',
          chapterNumber: 5,
          title: 'The Best Way to Start a New Habit',
          summaryContent: 'Implementation Intentions are critical. By explicitly stating When and Where you will perform a habit, you significantly increase your odds of success.',
          keyTakeaways: [
             'Use the formula: I will [BEHAVIOR] at [TIME] in [LOCATION]',
             'Habit stacking pairs a new habit with a current one'
          ],
          isLocked: true, // Example locked
        ),
      ];
    }
    return []; // Default empty list if bookId doesn't match
  }

  @override
  Future<List<ChunkEntity>> getChunks(String bookId, String chapterId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      ChunkEntity(
        id: 'chunk_${chapterId}_1',
        text: 'This is the first chunk of chapter $chapterId for book $bookId. It contains some introductory text that you can read in a couple of minutes. The idea is to make reading more digestible by breaking down the content into manageable pieces.',
        estimatedMinutes: 2,
        chunkIndex: 0,
      ),
      ChunkEntity(
        id: 'chunk_${chapterId}_2',
        text: 'Moving on to the second chunk. Notice how the text is focused and doesn\'t overwhelm the screen. This promotes better retention and a sense of progression as you swipe through the content.',
        estimatedMinutes: 3,
        chunkIndex: 1,
      ),
      ChunkEntity(
        id: 'chunk_${chapterId}_3',
        text: 'Here is the third chunk. By now you should be getting into the flow of reading in small bursts. This method is particularly effective for non-fiction books where you want to absorb key concepts without exhaustion.',
        estimatedMinutes: 2,
        chunkIndex: 2,
      ),
      ChunkEntity(
        id: 'chunk_${chapterId}_4',
        text: 'We are nearing the end of this chapter\'s session. The fourth chunk provides the concluding thoughts before the final wrap-up. Keep going, you are doing great.',
        estimatedMinutes: 4,
        chunkIndex: 3,
      ),
      ChunkEntity(
        id: 'chunk_${chapterId}_5',
        text: 'Final chunk! You have successfully read through the entire chapter chunk by chunk. Once you finish this, you will see a completion screen. Great job!',
        estimatedMinutes: 2,
        chunkIndex: 4,
      ),
    ];
  }

  @override
  Future<void> addBook(AddBookParams params) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    print('------- Mock Book Added -------');
    print('Title: ${params.title}');
    print('Author: ${params.author}');
    print('ISBN: ${params.isbn ?? "None provided"}');
    print('-------------------------------');
  }

  @override
  Future<BookDetailEntity> getBookDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return BookDetailEntity(
      id: id,
      title: 'Atomic Habits',
      author: 'James Clear',
      rating: 4.8,
      readersCount: '3M',
      category: 'Self-Improvement',
      imageUrl: 'https://covers.openlibrary.org/b/isbn/9780735211292-L.jpg',
      description: 'An easy & proven way to build good habits & break bad ones.',
      totalChapters: 10,
      progressPercent: 65,
      daysLeftToFinish: 3,
      pagesLeft: 185,
      flashcardsCount: 24,
      readPerDayMinutes: 45,
    );
  }

  @override
  Future<UserProgressEntity> getCurrentProgress() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const UserProgressEntity(
      bookId: 'b_1',
      title: 'Atomic Habits',
      author: 'James Clear',
      imageUrl: 'https://covers.openlibrary.org/b/isbn/9780735211292-L.jpg', // Placeholder cover
      progressPercent: 65,
    );
  }

  @override
  Future<InsightsEntity> getDailyInsights() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const InsightsEntity(
      cardsDue: 12,
      readTodayMinutes: 45,
      dayStreak: 3,
    );
  }

  @override
  Future<List<BookEntity>> getRecommendedBooks() async {
    await Future.delayed(const Duration(seconds: 1));
    return const [
      BookEntity(
        id: 'r_1',
        title: 'The 7 Habits of Highly Effective People',
        author: 'Stephen Covey',
        rating: 4.8,
        readersCount: '2.3M',
        category: 'Self-Improvement',
        hasAudio: true,
        imageUrl: 'https://covers.openlibrary.org/b/isbn/9780671708634-L.jpg',
      ),
      BookEntity(
        id: 'r_2',
        title: 'The Power of Now',
        author: 'Eckhart Tolle',
        rating: 4.6,
        readersCount: '1.8M',
        category: 'Mindfulness',
        imageUrl: 'https://covers.openlibrary.org/b/isbn/9781577311522-L.jpg',
      ),
      BookEntity(
        id: 'r_3',
        title: 'Eat That Frog!',
        author: 'Brian Tracy',
        rating: 4.5,
        readersCount: '890K',
        category: 'Productivity',
        hasAudio: true,
        imageUrl: 'https://covers.openlibrary.org/b/isbn/9781523000632-L.jpg',
      ),
    ];
  }

  @override
  Future<List<BookEntity>> getTrendingBooks() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return const [
      BookEntity(
        id: 't_1',
        title: 'Deep Work',
        author: 'Cal Newport', // Figma says Mark Manson but cover implies Deep Work. Using generic
        rating: 4.7,
        readersCount: '1.1M',
        category: 'Productivity',
        badge: '#1',
        imageUrl: 'https://covers.openlibrary.org/b/isbn/9781455586691-L.jpg', 
      ),
      BookEntity(
        id: 't_2',
        title: 'How to Win Friends and Influence People',
        author: 'Dale Carnegie',
        rating: 4.9,
        readersCount: '5M',
        category: 'Self-Improvement',
        badge: '#2',
        imageUrl: 'https://covers.openlibrary.org/b/isbn/9780671027032-L.jpg',
      ),
      BookEntity(
        id: 't_3',
        title: 'Start with Why',
        author: 'Simon Sinek',
        rating: 4.6,
        readersCount: '2.1M',
        category: 'Leadership',
        badge: '#3',
        imageUrl: 'https://covers.openlibrary.org/b/isbn/9781591846444-L.jpg',
      ),
    ];
  }

  @override
  Future<List<BookEntity>> getLibraryBooks() async {
    await Future.delayed(const Duration(milliseconds: 900));
    return const [
       BookEntity(
        id: 'l_1',
        title: 'Deep Work',
        author: 'Cal Newport', 
        rating: 4.7,
        readersCount: '1.1M',
        category: 'Productivity',
        imageUrl: 'https://covers.openlibrary.org/b/isbn/9781455586691-L.jpg', 
      ),
      BookEntity(
        id: 'l_2',
        title: 'Thinking, Fast and Slow',
        author: 'Daniel Kahneman',
        rating: 4.6,
        readersCount: '1.9M',
        category: 'Psychology',
        imageUrl: 'https://covers.openlibrary.org/b/isbn/9780374275631-L.jpg',
      ),
      BookEntity(
        id: 'l_3',
        title: 'Sapiens',
        author: 'Yuval Noah Harari',
        rating: 4.8,
        readersCount: '3.4M',
        category: 'History',
        imageUrl: 'https://covers.openlibrary.org/b/isbn/9780062316097-L.jpg',
      ),
    ];
  }
}
