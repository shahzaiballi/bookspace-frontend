import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/user_stats_entity.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'package:go_router/go_router.dart';
import '../../profile/controllers/reading_plan_controller.dart';

class CurrentlyReadingCard extends ConsumerWidget {
  final UserProgressEntity progress;

  const CurrentlyReadingCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingPlan = ref.watch(readingPlanProvider);
    // Calculated estimate assuming 200 pages left on average at 1 page/min speed
    final int estimatedDaysLeft = ((100 - progress.progressPercent) * 2 / readingPlan.dailyMinutes).ceil().clamp(1, 100);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.responsive.wp(20)),
      padding: EdgeInsets.all(context.responsive.sp(20)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF381A5D), Color(0xFF1E2A4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(context.responsive.sp(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURRENTLY READING',
            style: TextStyle(
              color: Colors.white60,
              fontSize: context.responsive.sp(11),
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: context.responsive.sp(16)),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(context.responsive.sp(12)),
                child: Image.network(
                  progress.imageUrl,
                  height: context.responsive.sp(80),
                  width: context.responsive.sp(55),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: context.responsive.sp(80),
                    width: context.responsive.sp(55),
                    color: Colors.white10,
                    child: Icon(Icons.book, color: Colors.white54, size: context.responsive.sp(24)),
                  ),
                ),
              ),
              SizedBox(width: context.responsive.wp(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      progress.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: context.responsive.sp(18),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.responsive.sp(4)),
                    Text(
                      'by ${progress.author}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: context.responsive.sp(13),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.responsive.sp(16)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Progress', style: TextStyle(color: Colors.white60, fontSize: context.responsive.sp(12))),
                        Text('${progress.progressPercent}%', style: TextStyle(color: const Color(0xFFB062FF), fontSize: context.responsive.sp(12), fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: context.responsive.sp(6)),
                    Text(
                       '$estimatedDaysLeft days left to finish', 
                       style: TextStyle(color: Colors.greenAccent, fontSize: context.responsive.sp(11), fontWeight: FontWeight.w600)
                    ),
                    SizedBox(height: context.responsive.sp(8)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: LinearProgressIndicator(
                        value: progress.progressPercent / 100,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB062FF)), // Vibrant Purple
                        minHeight: context.responsive.sp(6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.responsive.sp(20)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => context.push('/chapters/${progress.bookId}'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Icon(Icons.play_arrow_rounded, size: context.responsive.sp(20)),
                 SizedBox(width: context.responsive.wp(8)),
                 Text('Continue Reading', style: TextStyle(fontSize: context.responsive.sp(14), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          SizedBox(height: context.responsive.sp(12)),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24, width: 1),
                    padding: EdgeInsets.symmetric(vertical: context.responsive.sp(12)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {},
                  icon: Icon(Icons.style_outlined, color: Colors.white70, size: context.responsive.sp(16)),
                  label: Text('Flashcards', style: TextStyle(color: Colors.white70, fontSize: context.responsive.sp(13))),
                ),
              ),
              SizedBox(width: context.responsive.wp(12)),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24, width: 1),
                    padding: EdgeInsets.symmetric(vertical: context.responsive.sp(12)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {},
                  icon: Icon(Icons.description_outlined, color: Colors.white70, size: context.responsive.sp(16)),
                  label: Text('Summary', style: TextStyle(color: Colors.white70, fontSize: context.responsive.sp(13))),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
