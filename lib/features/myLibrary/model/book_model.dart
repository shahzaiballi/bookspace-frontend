class Book {
  final int id;
  final String title;
  final String author;
  final String image;
  double progress;
  bool isFavorite;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.image,
    this.progress = 0.0,
    this.isFavorite = false,
  });
}
