import '../entities/book_entity.dart';
import '../entities/book_detail_entity.dart';
import '../entities/user_stats_entity.dart';
import '../entities/add_book_params.dart';
import '../entities/chapter_entity.dart';
import '../entities/summary_entity.dart';
import '../entities/chunk_entity.dart';
import '../entities/flashcard_entity.dart';

abstract class BookRepository {
  Future<List<ChapterEntity>> getChapters(String bookId);
  Future<List<SummaryEntity>> getChapterSummaries(String chapterId);
  Future<List<ChunkEntity>> getChunks(String bookId, String chapterId);
  Future<List<FlashcardEntity>> getFlashcards(String bookId);
  Future<void> addBook(AddBookParams params);
  Future<BookDetailEntity> getBookDetails(String id);
  Future<UserProgressEntity> getCurrentProgress();
  Future<InsightsEntity> getDailyInsights();
  Future<List<BookEntity>> getRecommendedBooks();
  Future<List<BookEntity>> getTrendingBooks();
  Future<List<BookEntity>> getLibraryBooks();
}
