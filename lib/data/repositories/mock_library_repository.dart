import '../../domain/entities/library_book_entity.dart';
import '../../domain/repositories/library_repository.dart';

class MockLibraryRepository implements LibraryRepository {
  @override
  Future<List<LibraryBookEntity>> getUserLibrary() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const [
      LibraryBookEntity(
        id: 'lib_1',
        title: 'Atomic Habits',
        author: 'James Clear',
        rating: 4.8,
        readersCount: '3M',
        category: 'Self-Improvement',
        imageUrl: 'https://covers.openlibrary.org/b/isbn/9780735211292-L.jpg',
        progressPercent: 65,
        status: LibraryStatus.inProgress,
        isFavorite: true,
      ),
      LibraryBookEntity(
        id: 'lib_2',
        title: 'Deep Work',
        author: 'Cal Newport',
        rating: 4.7,
        readersCount: '1.1M',
        category: 'Productivity',
        imageUrl: 'https://covers.openlibrary.org/b/isbn/9781455586691-L.jpg',
        progressPercent: 30,
        status: LibraryStatus.inProgress,
        isFavorite: false,
      ),
      LibraryBookEntity(
        id: 'lib_3',
        title: 'Thinking, Fast and Slow',
        author: 'Daniel Kahneman',
        rating: 4.6,
        readersCount: '1.9M',
        category: 'Psychology',
        imageUrl: 'https://covers.openlibrary.org/b/isbn/9780374275631-L.jpg',
        progressPercent: 80,
        status: LibraryStatus.inProgress,
        isFavorite: true,
      ),
      LibraryBookEntity(
        id: 'lib_4',
        title: 'Sapiens',
        author: 'Yuval Noah Harari',
        rating: 4.8,
        readersCount: '3.4M',
        category: 'History',
        imageUrl: 'https://covers.openlibrary.org/b/isbn/9780062316097-L.jpg',
        progressPercent: 45,
        status: LibraryStatus.inProgress,
        isFavorite: false,
      ),
      LibraryBookEntity(
        id: 'lib_5',
        title: 'The Psychology of Money',
        author: 'Morgan Housel',
        rating: 4.9,
        readersCount: '2.5M',
        category: 'Finance',
        imageUrl: 'https://covers.openlibrary.org/b/isbn/9780857197689-L.jpg',
        progressPercent: 15,
        status: LibraryStatus.inProgress,
        isFavorite: false,
      ),
      LibraryBookEntity(
        id: 'lib_6',
        title: 'Educated',
        author: 'Tara Westover',
        rating: 4.7,
        readersCount: '2.1M',
        category: 'Biography',
        imageUrl: 'https://covers.openlibrary.org/b/isbn/9780399590504-L.jpg',
        progressPercent: 100,
        status: LibraryStatus.completed,
        isFavorite: true,
      ),
    ];
  }
}
