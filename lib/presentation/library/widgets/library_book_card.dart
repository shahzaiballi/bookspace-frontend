import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/library_book_entity.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'package:go_router/go_router.dart';
import '../controllers/library_state_provider.dart';

class LibraryBookCard extends ConsumerWidget {
  final LibraryBookEntity book;

  const LibraryBookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoriteBooksProvider).contains(book.id);

    return GestureDetector(
      onTap: () => context.push('/book_detail/${book.id}'),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: context.responsive.wp(20), vertical: context.responsive.sp(8)),
        padding: EdgeInsets.all(context.responsive.sp(16)),
      decoration: BoxDecoration(
        color: const Color(0xFF1E233D),
        borderRadius: BorderRadius.circular(context.responsive.sp(16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(context.responsive.sp(8)),
            child: Image.network(
              book.imageUrl,
              height: context.responsive.sp(100),
              width: context.responsive.wp(70),
              fit: BoxFit.cover,
               errorBuilder: (context, error, stackTrace) => Container(
                  height: context.responsive.sp(100), width: context.responsive.wp(70), color: Colors.white10),
            ),
          ),
          SizedBox(width: context.responsive.wp(16)),
          Expanded(
             child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Expanded(
                           child: Text(
                             book.title,
                             style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(15), fontWeight: FontWeight.bold),
                             maxLines: 1,
                             overflow: TextOverflow.ellipsis,
                           ),
                         ),
                         Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             GestureDetector(
                               onTap: () {
                                 ref.read(favoriteBooksProvider.notifier).toggleFavorite(book.id);
                               },
                               child: Icon(
                                 isFavorite ? Icons.favorite : Icons.favorite_border,
                                 color: isFavorite ? Colors.redAccent : Colors.white54,
                                 size: context.responsive.sp(20)
                               ),
                             ),
                             SizedBox(width: context.responsive.wp(12)),
                             GestureDetector(
                               onTap: () {
                                 _showDeleteConfirm(context, ref);
                               },
                               child: Icon(
                                 Icons.delete_outline,
                                 color: Colors.white54,
                                 size: context.responsive.sp(20)
                               ),
                             ),
                           ],
                         )
                      ],
                   ),
                   SizedBox(height: context.responsive.sp(4)),
                   Text(
                      book.author,
                      style: TextStyle(color: Colors.white70, fontSize: context.responsive.sp(13)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                   ),
                   SizedBox(height: context.responsive.sp(12)),
                   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text('Progress', style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(11))),
                         Text('${book.progressPercent}%', style: TextStyle(color: const Color(0xFFB062FF), fontSize: context.responsive.sp(11), fontWeight: FontWeight.bold)),
                      ],
                   ),
                   SizedBox(height: context.responsive.sp(6)),
                   ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: book.progressPercent / 100,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB062FF)), // Vibrant Purple
                        minHeight: context.responsive.sp(5),
                      ),
                   ),
                   SizedBox(height: context.responsive.sp(8)),
                   Align(
                     alignment: Alignment.centerRight,
                     child: TextButton(
                       onPressed: () => context.push('/book_detail/${book.id}'),
                       style: TextButton.styleFrom(
                         padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(12), vertical: context.responsive.sp(4)),
                         minimumSize: Size.zero,
                         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                       ),
                       child: Text(
                         'Details',
                         style: TextStyle(color: const Color(0xFFB062FF), fontSize: context.responsive.sp(12), fontWeight: FontWeight.bold),
                       ),
                     ),
                   )
                ],
             )
          )
        ],
      )
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E233D),
        title: const Text('Remove Book', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to remove this book from your library?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              ref.read(deletedBooksProvider.notifier).deleteBook(book.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Removed from Library'),
                  backgroundColor: Color(0xFF1E233D),
                ),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
