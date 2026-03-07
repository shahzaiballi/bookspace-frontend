import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/chapter_entity.dart';
import '../../home/controllers/home_controller.dart'; 

// FutureProvider requiring book ID to fetch the respective chapters
final chapterListProvider = FutureProvider.family<List<ChapterEntity>, String>((ref, bookId) {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getChapters(bookId);
});
