import '../../domain/entities/library_book_entity.dart';
import '../../domain/repositories/library_repository.dart';
import '../network/api_client.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final ApiClient _api = ApiClient.instance;

  LibraryBookEntity _fromJson(Map<String, dynamic> json) {
    // Map backend status string to LibraryStatus enum
    LibraryStatus status;
    switch (json['status'] as String?) {
      case 'in_progress':
        status = LibraryStatus.inProgress;
        break;
      case 'completed':
        status = LibraryStatus.completed;
        break;
      default:
        status = LibraryStatus.notStarted;
    }

    return LibraryBookEntity(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      readersCount: json['readersCount']?.toString() ?? '0',
      category: json['category'] ?? '',
      hasAudio: json['hasAudio'] ?? false,
      badge: json['badge'] as String?,
      progressPercent: json['progressPercent'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
      status: status,
    );
  }

  @override
  Future<List<LibraryBookEntity>> getUserLibrary() async {
    final data = await _api.get('/api/v1/library/') as List<dynamic>;
    return data
        .cast<Map<String, dynamic>>()
        .map(_fromJson)
        .toList();
  }

  /// Toggle favorite — PATCH /api/v1/library/{id}/
  Future<void> toggleFavorite(String userBookId, bool isFavorite) async {
    await _api.patch(
      '/api/v1/library/$userBookId/',
      body: {'isFavorite': isFavorite},
    );
  }

  /// Remove book from library — DELETE /api/v1/library/{id}/
  Future<void> removeBook(String userBookId) async {
    await _api.delete('/api/v1/library/$userBookId/');
  }

  /// Update reading progress — PATCH /api/v1/library/{id}/
  Future<void> updateProgress(String userBookId, int progressPercent) async {
    await _api.patch(
      '/api/v1/library/$userBookId/',
      body: {'progressPercent': progressPercent},
    );
  }
}

