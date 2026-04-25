import 'package:flutter/material.dart';
import '../../../../domain/entities/book_entity.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'package:go_router/go_router.dart';

class BookGridCard extends StatelessWidget {
  final BookEntity book;

  const BookGridCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/book_detail/${book.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(context.responsive.sp(12)),
                  child: Image.network(
                    book.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (book.badge != null)
                  Positioned(
                    top: context.responsive.sp(6),
                    left: context.responsive.sp(6),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.responsive.wp(6),
                          vertical: context.responsive.sp(2)),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(context.responsive.sp(6)),
                      ),
                      child: Text(
                        book.badge!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: context.responsive.sp(10),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: context.responsive.sp(8)),
          Text(
            book.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: context.responsive.sp(12),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: context.responsive.sp(2)),
          Text(
            book.author,
            style: TextStyle(
              color: Colors.white54,
              fontSize: context.responsive.sp(10),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

