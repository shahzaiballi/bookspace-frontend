class BookEntity {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final double rating;
  final String readersCount;
  final String category;
  final bool hasAudio;
  final String? badge; // For things like "#1", "#2"

  const BookEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.rating,
    required this.readersCount,
    required this.category,
    this.hasAudio = false,
    this.badge,
  });

  BookEntity copyWith({
    String? id,
    String? title,
    String? author,
    String? imageUrl,
    double? rating,
    String? readersCount,
    String? category,
    bool? hasAudio,
    String? badge,
  }) {
    return BookEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      readersCount: readersCount ?? this.readersCount,
      category: category ?? this.category,
      hasAudio: hasAudio ?? this.hasAudio,
      badge: badge ?? this.badge,
    );
  }
}
