import '../entities/library_book_entity.dart';

abstract class LibraryRepository {
  Future<List<LibraryBookEntity>> getUserLibrary();
}

