import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/summary_entity.dart';
import '../../../../domain/entities/book_detail_entity.dart';
import '../../../../domain/repositories/book_repository.dart';
import '../../../../data/repositories/mock_book_repository.dart';

final bookRepositoryProvider = Provider<BookRepository>((ref) => MockBookRepository());

// Fetch basic Book Details for the Header
final summaryBookProvider = FutureProvider.family.autoDispose<BookDetailEntity, String>((ref, bookId) async {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getBookDetails(bookId);
});

// AsyncNotifier tracking the actual accordion content list
class SummaryController extends AutoDisposeFamilyAsyncNotifier<List<SummaryEntity>, String> {
  @override
  FutureOr<List<SummaryEntity>> build(String arg) async {
    final repo = ref.watch(bookRepositoryProvider);
    return repo.getChapterSummaries(arg);
  }
}

final summaryControllerProvider = AsyncNotifierProvider.autoDispose.family<SummaryController, List<SummaryEntity>, String>(
  SummaryController.new,
);

// Provider tracking which single chapter index is actively expanded
final activeExpansionProvider = StateProvider.autoDispose<int?>((ref) => null);
