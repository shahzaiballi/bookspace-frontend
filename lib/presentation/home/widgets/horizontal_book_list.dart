import 'package:flutter/material.dart';
import '../../../../domain/entities/book_entity.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'package:go_router/go_router.dart';

class HorizontalBookList extends StatelessWidget {
  final String title;
  final List<BookEntity> books;
  final bool showBadges;
  final bool showsAuthor;
  final VoidCallback? onViewAll;

  const HorizontalBookList({
    super.key, 
    required this.title, 
    required this.books,
    this.showBadges = false,
    this.showsAuthor = true,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Row(
                 children: [
                   Text(
                      title,
                      style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(18), fontWeight: FontWeight.bold),
                   ),
                   if (showBadges) ...[
                      SizedBox(width: context.responsive.wp(8)),
                      Container(
                        padding: EdgeInsets.all(context.responsive.sp(4)),
                        decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.2), shape: BoxShape.circle),
                        child: Icon(Icons.trending_up, color: Colors.orangeAccent, size: context.responsive.sp(14)),
                      )
                   ]
                 ],
               ),
               if (onViewAll != null)
                 TextButton(
                   onPressed: onViewAll,
                   child: Row(
                     children: [
                       Text('View All', style: TextStyle(color: const Color(0xFFB062FF), fontSize: context.responsive.sp(13))),
                       Icon(Icons.arrow_forward, color: const Color(0xFFB062FF), size: context.responsive.sp(14))
                     ],
                   ),
                 )
            ],
          ),
        ),
        SizedBox(height: context.responsive.sp(8)),
        SizedBox(
          height: context.responsive.sp(230),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(12)),
            itemCount: books.length,
            itemBuilder: (context, index) {
               final book = books[index];
               return _buildCard(book, context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BookEntity book, BuildContext context) {
     return GestureDetector(
       onTap: () => context.push('/book_detail/${book.id}'),
       child: Container(
         width: context.responsive.wp(140),
         margin: EdgeInsets.symmetric(horizontal: context.responsive.wp(8)),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
            Stack(
              children: [
                 ClipRRect(
                   borderRadius: BorderRadius.circular(context.responsive.sp(12)),
                   child: Image.network(
                     book.imageUrl,
                     height: context.responsive.sp(180),
                     width: double.infinity,
                     fit: BoxFit.cover,
                   ),
                 ),
                 if (showBadges && book.badge != null)
                   Positioned(
                      top: context.responsive.sp(8),
                      left: context.responsive.sp(8),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(8), vertical: context.responsive.sp(4)),
                        decoration: BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(context.responsive.sp(6))),
                        child: Text(book.badge!, style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(11), fontWeight: FontWeight.bold)),
                      ),
                   )
              ],
            ),
            SizedBox(height: context.responsive.sp(8)),
            Text(
              book.title,
              style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(14), fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (showsAuthor) ...[
               SizedBox(height: context.responsive.sp(2)),
               Text(
                 book.author,
                 style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(12)),
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
               ),
            ]
         ],
       ),
       ),
     );
  }
}
