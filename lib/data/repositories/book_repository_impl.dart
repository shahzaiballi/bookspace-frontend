import '../../domain/entities/book_entity.dart';
import '../../domain/entities/book_detail_entity.dart';
import '../../domain/entities/user_stats_entity.dart';
import '../../domain/entities/add_book_params.dart';
import '../../domain/entities/chapter_entity.dart';
import '../../domain/entities/summary_entity.dart';
import '../../domain/entities/chunk_entity.dart';
import '../../domain/entities/flashcard_entity.dart';
import '../../domain/repositories/book_repository.dart';
import '../network/api_client.dart';

class BookRepositoryImpl implements BookRepository {
  final ApiClient _api = ApiClient.instance;

  // ── Helpers ───────────────────────────────────────────────────────────────
  BookEntity _bookFromJson(Map<String, dynamic> json) {
  return BookEntity(
    id: json['id'].toString(),
    title: json['title'] ?? '',
    author: json['author'] ?? '',
    imageUrl: json['imageUrl'] ?? '',
    // FIXED: Handle string ratings safely
    rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0.0,
    readersCount: json['readersCount']?.toString() ?? '0',
    category: json['category'] ?? '',
    hasAudio: json['hasAudio'] ?? false,
    badge: json['badge'] as String?,
  );
}

BookDetailEntity _bookDetailFromJson(Map<String, dynamic> json) {
  return BookDetailEntity(
    id: json['id'].toString(),
    title: json['title'] ?? '',
    author: json['author'] ?? '',
    imageUrl: json['imageUrl'] ?? '',
    // FIXED: Handle string ratings safely
    rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0.0,
    readersCount: json['readersCount']?.toString() ?? '0',
    category: json['category'] ?? '',
    hasAudio: json['hasAudio'] ?? false,
    badge: json['badge'] as String?,
    description: json['description'] ?? '',
    totalChapters: json['totalChapters'] ?? 0,
    progressPercent: json['progressPercent'] ?? 0,
    daysLeftToFinish: json['daysLeftToFinish'] ?? 0,
    pagesLeft: json['pagesLeft'] ?? 0,
    flashcardsCount: json['flashcardsCount'] ?? 0,
    readPerDayMinutes: json['readPerDayMinutes'] ?? 45,
  );
}

  ChapterEntity _chapterFromJson(Map<String, dynamic> json) {
    return ChapterEntity(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      chapterNumber: json['chapterNumber'] ?? 0,
      durationInMinutes: json['durationInMinutes'] ?? 15,
      pageRange: json['pageRange'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      isActive: json['isActive'] ?? false,
      isLocked: json['isLocked'] ?? false,
    );
  }

  ChunkEntity _chunkFromJson(Map<String, dynamic> json) {
    return ChunkEntity(
      id: json['id'].toString(),
      text: json['text'] ?? '',
      estimatedMinutes: json['estimatedMinutes'] ?? 2,
      chunkIndex: json['chunkIndex'] ?? 0,
    );
  }

  SummaryEntity _summaryFromJson(Map<String, dynamic> json) {
    return SummaryEntity(
      id: json['id'].toString(),
      chapterNumber: json['chapterNumber'] ?? 0,
      title: json['title'] ?? '',
      summaryContent: json['summaryContent'] ?? '',
      keyTakeaways: List<String>.from(json['keyTakeaways'] ?? []),
      isLocked: json['isLocked'] ?? false,
    );
  }

  FlashcardEntity _flashcardFromJson(Map<String, dynamic> json) {
    return FlashcardEntity(
      id: json['id'].toString(),
      bookId: json['bookId'].toString(),
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }

  // ── Books ─────────────────────────────────────────────────────────────────
  @override
  Future<List<BookEntity>> getRecommendedBooks() async {
    final data = await _api.get('api/v1/books/recommended/') as List<dynamic>;
    return data.cast<Map<String, dynamic>>().map(_bookFromJson).toList();
  }

  @override
  Future<List<BookEntity>> getTrendingBooks() async {
    final data = await _api.get('/api/v1/books/trending/') as List<dynamic>;
    return data.cast<Map<String, dynamic>>().map(_bookFromJson).toList();
  }

  @override
  Future<List<BookEntity>> getLibraryBooks() async {
    final data = await _api.get(
      '/api/v1/library/',
      queryParameters: {'status': 'in_progress'},
    ) as List<dynamic>;
    return data.cast<Map<String, dynamic>>().map(_bookFromJson).toList();
  }

  @override
  Future<BookDetailEntity> getBookDetails(String id) async {
    final data = await _api.get('/api/v1/books/$id/') as Map<String, dynamic>;
    return _bookDetailFromJson(data);
  }

  // ── Chapters ──────────────────────────────────────────────────────────────
  @override
  Future<List<ChapterEntity>> getChapters(String bookId) async {
    final data = await _api.get('/api/v1/books/$bookId/chapters/') as List<dynamic>;
    return data.cast<Map<String, dynamic>>().map(_chapterFromJson).toList();
  }

  // ── Chunks ────────────────────────────────────────────────────────────────
  @override
  Future<List<ChunkEntity>> getChunks(String bookId, String chapterId) async {
    final data = await _api.get('/api/v1/books/$bookId/chapters/$chapterId/chunks/') as List<dynamic>;
    return data.cast<Map<String, dynamic>>().map(_chunkFromJson).toList();
  }

  // ── Summaries ─────────────────────────────────────────────────────────────
  @override
  Future<List<SummaryEntity>> getChapterSummaries(String bookId) async {
    final data = await _api.get('/api/v1/books/$bookId/summaries/') as List<dynamic>;
    return data.cast<Map<String, dynamic>>().map(_summaryFromJson).toList();
  }

  // ── Flashcards ────────────────────────────────────────────────────────────
  @override
  Future<List<FlashcardEntity>> getFlashcards(String bookId) async {
    final data = await _api.get('/api/v1/books/$bookId/flashcards/') as List<dynamic>;
    return data.cast<Map<String, dynamic>>().map(_flashcardFromJson).toList();
  }

  // ── Progress ──────────────────────────────────────────────────────────────
  @override
  Future<UserProgressEntity> getCurrentProgress() async {
    final data = await _api.get('/api/v1/reading/progress/') as Map<String, dynamic>;
    return UserProgressEntity(
      bookId: data['bookId'].toString(),
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      progressPercent: data['progressPercent'] ?? 0,
    );
  }

  @override
  Future<InsightsEntity> getDailyInsights() async {
    final data = await _api.get('/api/v1/reading/insights/') as Map<String, dynamic>;
    return InsightsEntity(
      cardsDue: data['cardsDue'] ?? 0,
      readTodayMinutes: data['readTodayMinutes'] ?? 0,
      dayStreak: data['dayStreak'] ?? 0,
    );
  }

  // ── Add Book ───────────────────────────────────────────────────────────────
  // NOTE: The old "search by title and add" flow is replaced by the PDF upload
  // flow in AddBookController. This method is kept for compatibility but
  // now simply adds a book by ID directly to the user's library.
  @override
  Future<void> addBook(AddBookParams params) async {
    // Search for the book first
    final searchResults = await _api.get(
      '/api/v1/books/',
      queryParameters: {'search': params.title},
    ) as List<dynamic>;

    if (searchResults.isEmpty) {
      throw ApiException(
        'Book "${params.title}" not found in the catalog.',
        statusCode: 404,
      );
    }

    final bookId = searchResults.first['id'].toString();
    await _api.post('/api/v1/library/', body: {'book_id': bookId});
  }
}
