import 'package:flutter/material.dart';
import '../../../../domain/entities/book_detail_entity.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../domain/entities/chapter_entity.dart';

class ChapterHeaderCard extends StatelessWidget {
  final BookDetailEntity book; // Reusing BookDetailEntity to populate the summary header
  final List<ChapterEntity> chapters;

  const ChapterHeaderCard({super.key, required this.book, required this.chapters});

  @override
  Widget build(BuildContext context) {
    final completedChapters = chapters.where((c) => c.isCompleted).length;
    final totalChapters = chapters.length;
    final progress = totalChapters > 0 ? (completedChapters / totalChapters) : 0.0;

    return Container(
      padding: EdgeInsets.all(context.responsive.sp(20)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF381A5D), Color(0xFF1E233D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(context.responsive.sp(16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(context.responsive.sp(8)),
            child: Image.network(
              book.imageUrl,
              height: context.responsive.sp(80),
              width: context.responsive.wp(55),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: context.responsive.wp(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(16), fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.responsive.sp(4)),
                Text(
                  'by ${book.author}',
                  style: TextStyle(color: Colors.white70, fontSize: context.responsive.sp(12)),
                ),
                SizedBox(height: context.responsive.sp(16)),
                Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text('Progress', style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(11))),
                     Text('$completedChapters/$totalChapters chapters', style: TextStyle(color: const Color(0xFFB062FF), fontSize: context.responsive.sp(11))),
                   ],
                ),
                SizedBox(height: context.responsive.sp(6)),
                ClipRRect(
                   borderRadius: BorderRadius.circular(4),
                   child: LinearProgressIndicator(
                     value: progress, 
                     backgroundColor: Colors.white12,
                     valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB062FF)), // Purple Match
                     minHeight: context.responsive.sp(4),
                   ),
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}

