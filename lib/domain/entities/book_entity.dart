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
}
