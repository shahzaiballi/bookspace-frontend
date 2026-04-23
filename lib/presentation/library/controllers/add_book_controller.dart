import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/network/api_client.dart';

/// Controller for the user PDF upload feature.
///
/// Uses multipart/form-data to send the PDF file to:
///   POST /api/v1/books/upload/
///
/// On success, polls:
///   GET /api/v1/books/upload/<uploadId>/status/
/// until processing is complete (status = 'completed' or 'failed').
class AddBookController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Initial state is idle
  }

  /// Upload a PDF book to the backend.
  ///
  /// [title]    — book title from the form
  /// [author]   — book author from the form (optional)
  /// [filePath] — local path to the selected PDF file
  Future<void> uploadBook({
    required String title,
    required String author,
    required String filePath,
  }) async {
    state = const AsyncLoading();

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found. Please select the PDF again.');
      }

      // Upload via multipart form — ApiClient handles auth headers
      final response = await ApiClient.instance.uploadFile(
        endpoint: '/books/upload/',
        filePath: filePath,
        fieldName: 'pdf_file',
        fields: {
          'title': title,
          if (author.trim().isNotEmpty) 'author': author.trim(),
        },
      );

      // The backend returns 202 Accepted with the upload ID
      // We don't need to poll here — the user will see the book
      // appear in their library after background processing completes.
      // A success message is shown in AddBookPage via the listener.

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final addBookControllerProvider = AsyncNotifierProvider.autoDispose<AddBookController, void>(
  AddBookController.new,
);