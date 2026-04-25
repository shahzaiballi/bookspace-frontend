import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../domain/entities/book_entity.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/widgets/minimal_book_row_card.dart';

class AllBooksPage extends ConsumerStatefulWidget {
  final String category;

  const AllBooksPage({super.key, required this.category});

  @override
  ConsumerState<AllBooksPage> createState() => _AllBooksPageState();
}

class _AllBooksPageState extends ConsumerState<AllBooksPage> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    // Determine which provider to use based on the category string from path parameters
    AsyncValue<List<BookEntity>> asyncBooks;
    String displayTitle;

    switch (widget.category.toLowerCase()) {
      case 'recommended':
        asyncBooks = ref.watch(recommendedBooksProvider);
        displayTitle = 'Recommended for You';
        break;
      case 'trending':
        asyncBooks = ref.watch(trendingBooksProvider);
        displayTitle = 'Trending This Week';
        break;
      default:
        // Use a generic or trending fallback
        asyncBooks = ref.watch(trendingBooksProvider);
        displayTitle = 'All Books';
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F1626),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1626),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(
          displayTitle,
          style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(18), fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          )
        ],
      ),
      body: SafeArea(
        child: asyncBooks.when(
          data: (books) {
            if (books.isEmpty) {
              return const Center(child: Text('No books found', style: TextStyle(color: Colors.white)));
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(16)),
              child: _isGridView ? _buildGridView(books) : _buildListView(books),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB062FF)))),
          error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
        ),
      ),
    );
  }

  Widget _buildGridView(List<BookEntity> books) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: context.responsive.sp(16)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.responsive.isLandscape ? 4 : 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: context.responsive.wp(16),
        mainAxisSpacing: context.responsive.sp(24),
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return GestureDetector(
          onTap: () => context.push('/book_detail/${book.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    book.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.white10),
                  ),
                ),
              ),
              SizedBox(height: context.responsive.sp(8)),
              Text(
                book.title,
                style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(14), fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: context.responsive.sp(4)),
              Text(
                book.author,
                style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(12)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListView(List<BookEntity> books) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: context.responsive.sp(16)),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: context.responsive.sp(16)),
          child: MinimalBookRowCard(book: books[index]),
        );
      },
    );
  }
}

