
class Book {
  final String title;
  final String author;
  final String image;
  final double progress;

  Book({
    required this.title,
    required this.author,
    required this.image,
    required this.progress,
  });
}

final List<Book> recommendedBooks = [
  Book(
    title: "The Alchemist",
    author: "Paulo Coelho",
    image: "assets/images/book1.jpg",
    progress: 0.0,
  ),
  Book(
    title: "Atomic Habits",
    author: "James Clear",
    image: "assets/images/book2.jpg",
    progress: 0.0,
  ),
  Book(
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    image: "assets/images/book.jpg",
    progress: 0.0,
  ),
];
