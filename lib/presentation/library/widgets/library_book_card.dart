import 'package:flutter/material.dart';
import '../../../../domain/entities/library_book_entity.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'package:go_router/go_router.dart';

class LibraryBookCard extends StatelessWidget {
  final LibraryBookEntity book;

  const LibraryBookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
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
                         if (book.isFavorite)
                           Icon(Icons.favorite, color: Colors.redAccent, size: context.responsive.sp(16)),
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
                ],
             )
          )
        ],
      )
      ),
    );
  }
}
