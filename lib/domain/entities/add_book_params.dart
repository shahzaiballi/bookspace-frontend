class AddBookParams {
  final String title;
  final String author;
  final String? isbn;

  const AddBookParams({
    required this.title,
    required this.author,
    this.isbn,
  });
}
