import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/network/api_client.dart';
import 'package:flutter/foundation.dart';

/// ✅ CLEAN: Uses ApiClient (handles auth + web/mobile automatically)
class AddBookController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// ✅ Upload PDF - works on web/mobile (ApiClient handles auth)
  Future<void> uploadBook({
    required String title,
    required String author,
    String? filePath,
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    state = const AsyncLoading();

    try {
      // ✅ Validate file
      if (filePath == null && fileBytes == null) {
        throw Exception('No file selected');
      }

      // ✅ ApiClient handles auth token + refresh automatically!
      final response = await ApiClient.instance.uploadFile(
        endpoint: '/api/v1/books/upload/',
        filePath: filePath,
        fileBytes: fileBytes,
        fileName: fileName,
        fields: {
          'title': title,
          if (author.trim().isNotEmpty) 'author': author.trim(),
        },
      );

      debugPrint('📤 Upload response: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 202) {
        state = const AsyncData(null);
      } else {
        throw Exception('Upload failed: ${response.statusCode}');
      }
    } catch (e, st) {
      debugPrint('❌ Upload error: $e');
      state = AsyncError(e, st);
    }
  }
}

final addBookControllerProvider = AsyncNotifierProvider.autoDispose<AddBookController, void>(
  AddBookController.new,
);
