import 'package:flutter/material.dart';
import '../../../../domain/entities/book_entity.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'package:go_router/go_router.dart';

class MinimalBookRowCard extends StatelessWidget {
  final BookEntity book;

  const MinimalBookRowCard({super.key, required this.book});

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
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(context.responsive.sp(8)),
            child: Image.network(
              book.imageUrl,
              height: context.responsive.sp(85),
              width: context.responsive.wp(60),
              fit: BoxFit.cover,
               errorBuilder: (context, error, stackTrace) => Container(
                  height: context.responsive.sp(85), width: context.responsive.wp(60), color: Colors.white10),
            ),
          ),
          SizedBox(width: context.responsive.wp(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(15), fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.responsive.sp(4)),
                Text(
                  book.author,
                  style: TextStyle(color: Colors.white70, fontSize: context.responsive.sp(13)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.responsive.sp(8)),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: context.responsive.sp(14)),
                    SizedBox(width: context.responsive.wp(4)),
                    Text(
                      '${book.rating}',
                      style: TextStyle(color: Colors.white70, fontSize: context.responsive.sp(12)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(8)),
                      child: Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle)),
                    ),
                    Text(
                      '${book.readersCount} readers',
                      style: TextStyle(color: Colors.white70, fontSize: context.responsive.sp(12)),
                    )
                  ],
                ),
                SizedBox(height: context.responsive.sp(8)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(10), vertical: context.responsive.sp(4)),
                  decoration: BoxDecoration(
                     color: const Color(0xFF381A5D),
                     borderRadius: BorderRadius.circular(context.responsive.sp(20)),
                  ),
                  child: Text(
                     book.category,
                     style: TextStyle(color: const Color(0xFFB062FF), fontSize: context.responsive.sp(10), fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      ),
    );
  }
}
