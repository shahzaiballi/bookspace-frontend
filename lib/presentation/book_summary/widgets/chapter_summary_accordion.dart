import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../domain/entities/summary_entity.dart';
import '../controllers/summary_controller.dart';

class ChapterSummaryAccordion extends ConsumerWidget {
  final SummaryEntity summary;
  final int index;

  const ChapterSummaryAccordion({super.key, required this.summary, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (summary.isLocked) {
      return Padding(
        padding: EdgeInsets.only(bottom: context.responsive.sp(12)),
        child: Container(
          padding: EdgeInsets.all(context.responsive.sp(20)),
          decoration: BoxDecoration(
            color: const Color(0xFF161E3A),
            borderRadius: BorderRadius.circular(context.responsive.sp(16)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Icon(Icons.lock_outline, color: Colors.white38, size: context.responsive.sp(20)),
               SizedBox(height: context.responsive.sp(8)),
               Text(
                 'Continue reading to unlock summaries',
                 style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(12)),
                 textAlign: TextAlign.center,
               )
            ],
          ),
        ),
      );
    }

    final activeIndex = ref.watch(activeExpansionProvider);
    final isExpanded = activeIndex == index;

    return Padding(
      padding: EdgeInsets.only(bottom: context.responsive.sp(12)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: const Color(0xFF1E233D),
          borderRadius: BorderRadius.circular(context.responsive.sp(16)),
          border: isExpanded ? Border.all(color: const Color(0xFFB062FF).withValues(alpha: 0.3)) : null,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(context.responsive.sp(16)),
          onTap: () {
            ref.read(activeExpansionProvider.notifier).state = isExpanded ? null : index;
          },
          child: Padding(
            padding: EdgeInsets.all(context.responsive.sp(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Number + Title + Arrow)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: context.responsive.sp(32),
                      height: context.responsive.sp(32),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF281E4B),
                        borderRadius: BorderRadius.circular(context.responsive.sp(8)),
                      ),
                      child: Text(
                        '${summary.chapterNumber}',
                        style: TextStyle(color: const Color(0xFFB062FF), fontWeight: FontWeight.bold, fontSize: context.responsive.sp(14)),
                      ),
                    ),
                    SizedBox(width: context.responsive.wp(16)),
                    Expanded(
                      child: Text(
                        summary.title,
                        style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(15), fontWeight: FontWeight.bold, height: 1.3),
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.white54,
                      size: context.responsive.sp(20),
                    )
                  ],
                ),
                
                // Expanded Content
                if (isExpanded) ...[
                  SizedBox(height: context.responsive.sp(20)),
                  Text(
                    summary.summaryContent,
                    style: TextStyle(color: Colors.white70, fontSize: context.responsive.sp(14), height: 1.5),
                  ),
                  SizedBox(height: context.responsive.sp(20)),
                  
                  // Key Takeaways Box
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(context.responsive.sp(16)),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1626).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(context.responsive.sp(12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('KEY TAKEAWAYS', style: TextStyle(color: const Color(0xFFB062FF), fontSize: context.responsive.sp(10), fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                        SizedBox(height: context.responsive.sp(12)),
                        ...summary.keyTakeaways.map((takeaway) => Padding(
                          padding: EdgeInsets.only(bottom: context.responsive.sp(8)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: context.responsive.sp(6)),
                                child: Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFFB062FF), shape: BoxShape.circle)),
                              ),
                              SizedBox(width: context.responsive.wp(12)),
                              Expanded(
                                child: Text(takeaway, style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(13), height: 1.4)),
                              )
                            ],
                          ),
                        )),
                      ],
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

