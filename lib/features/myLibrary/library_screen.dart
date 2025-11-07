import 'package:flutter/material.dart';
import 'package:fyp_future/features/myLibrary/widget/book_grid_card.dart';
import 'package:fyp_future/features/myLibrary/widget/caategory_tab.dart';
import 'model/book_model.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _selectedCategory = 'All';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // --- Dummy Book Data
  final List<Book> _books = List.generate(
    8,
        (i) => Book(
      id: i,
      title: 'Book Title ${i + 1}',
      author: 'Author ${i + 1}',
      image: 'assets/images/book.jpg',
      progress: ((i + 1) * 0.12).clamp(0.05, 0.95),
      isFavorite: i % 3 == 0,
    ),
  );


  List<Book> get filteredBooks {
    List<Book> books = _books;

    // Category filter
    if (_selectedCategory == 'Favorites') {
      books = books.where((b) => b.isFavorite).toList();
    } else if (_selectedCategory == 'In Progress') {
      // Books with progress less than 99%
      books = books.where((b) => b.progress < 0.99).toList();
    } else if (_selectedCategory == 'Completed') {
      // Books with progress 99% or more
      books = books.where((b) => b.progress >= 0.99).toList();
    }

    // Search filter
    if (_searchController.text.isNotEmpty) {
      books = books
          .where((b) => b.title.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    }

    return books;
  }

  // --- State Management Methods ---
  void _toggleFavorite(Book book) {
    setState(() {
      book.isFavorite = !book.isFavorite;
    });
  }

  void _deleteBook(Book book) {
    setState(() {
      _books.removeWhere((b) => b.id == book.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // 🖼️ Background Image
          Positioned.fill(
            child: Image.asset('assets/images/bg.jpg', fit: BoxFit.cover),
          ),
          // 🌑 Dark Overlay
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.7))),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isSearching
                        ? Container(
                      key: const ValueKey('searchBar'),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: "Search books...",
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSearching = false;
                                _searchController.clear();
                                // IMPORTANT: Clear the filter results too
                                // by calling setState, but since onChanged
                                // calls it, it's covered.
                              });
                            },
                            child: const Icon(Icons.close, color: Colors.white70),
                          ),
                        ],
                      ),
                    )
                        : Row(
                      key: const ValueKey('titleBar'),
                      children: [
                        const SizedBox(width: 80),
                        Expanded(
                          child: Center(
                            child: const Text(
                              'My Library',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // 3. Icons (Right side)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isSearching = true;
                            });
                          },
                          icon: const Icon(Icons.search_rounded, color: Colors.white70),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.filter_alt, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 🏷️ Category Tabs
                  CategoryTabs(
                    selected: _selectedCategory,
                    onChanged: (val) => setState(() => _selectedCategory = val),
                    categories: const ['All', 'In Progress', 'Completed', 'Favorites'],
                  ),
                  const SizedBox(height: 16),

                  // 📚 Books List
                  Expanded(
                    child: filteredBooks.isEmpty
                        ? const Center(
                      child: Text(
                        'No books found.',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                        : ListView.builder(
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = filteredBooks[index];
                        return BookGridCard(
                          book: book,
                          onToggleFavorite: () => _toggleFavorite(book),
                          onDelete: () => _deleteBook(book),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
