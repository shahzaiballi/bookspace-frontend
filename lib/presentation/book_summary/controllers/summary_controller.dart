import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/summary_entity.dart';
import '../../../../domain/entities/book_detail_entity.dart';
import '../../../../domain/repositories/book_repository.dart';
import '../../../../data/repositories/book_repository_impl.dart';

// ── Repository ────────────────────────────────────────────────────────────────
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepositoryImpl();
});

// ── Book Header (for the top card on ChapterSummaryPage) ─────────────────────
final summaryBookProvider = FutureProvider.family
    .autoDispose<BookDetailEntity, String>((ref, bookId) async {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getBookDetails(bookId);
});

// ── Chapter Summaries List ────────────────────────────────────────────────────
class SummaryController
    extends AutoDisposeFamilyAsyncNotifier<List<SummaryEntity>, String> {
  @override
  FutureOr<List<SummaryEntity>> build(String arg) async {
    final repo = ref.watch(bookRepositoryProvider);
    return repo.getChapterSummaries(arg);
  }
}

final summaryControllerProvider = AsyncNotifierProvider.autoDispose
    .family<SummaryController, List<SummaryEntity>, String>(
  SummaryController.new,
);

// ── Accordion Expansion State ─────────────────────────────────────────────────
final activeExpansionProvider = StateProvider.autoDispose<int?>((ref) => null);

