import 'book_entity.dart';

enum LibraryStatus {
  inProgress,
  completed,
  notStarted,
}

class LibraryBookEntity extends BookEntity {
  final int progressPercent;
  final bool isFavorite;
  final LibraryStatus status;

  const LibraryBookEntity({
    required super.id,
    required super.title,
    required super.author,
    required super.imageUrl,
    required super.rating,
    required super.readersCount,
    required super.category,
    super.hasAudio,
    super.badge,
    this.progressPercent = 0,
    this.isFavorite = false,
    this.status = LibraryStatus.notStarted,
  });
}
