import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/add_book_params.dart';
import '../../home/controllers/home_controller.dart'; 

class AddBookController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Initial state is data/null
  }

  Future<void> addBook(AddBookParams params) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(bookRepositoryProvider);
      await repo.addBook(params);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final addBookControllerProvider = AsyncNotifierProvider.autoDispose<AddBookController, void>(
  AddBookController.new,
);
