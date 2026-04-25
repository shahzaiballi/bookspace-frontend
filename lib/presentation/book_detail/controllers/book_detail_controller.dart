import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/book_detail_entity.dart';
import '../../home/controllers/home_controller.dart'; // To reuse bookRepositoryProvider

// FutureProvider requiring an ID to fetch details
final bookDetailProvider = FutureProvider.family<BookDetailEntity, String>((ref, id) {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getBookDetails(id);
});

