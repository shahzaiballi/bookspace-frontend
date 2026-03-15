import 'package:flutter/material.dart';
import '../../../../domain/entities/user_stats_entity.dart';
import '../../../../core/utils/responsive_utils.dart';

class InsightsGrid extends StatelessWidget {
  final InsightsEntity insights;

  const InsightsGrid({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Book Insights',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.responsive.sp(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Functionality to view all insights to be added later
                },
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        color: const Color(0xFFB062FF),
                        fontSize: context.responsive.sp(13),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: const Color(0xFFB062FF),
                      size: context.responsive.sp(14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.responsive.sp(16)), // Add spacing between header and grid
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(20)),
          child: Row(
            children: [
               Expanded(child: _InsightBox(
                 icon: Icons.bookmark_border, 
                 iconColor: const Color(0xFFB062FF), // Purple
                 value: insights.cardsDue.toString(), 
                 label: 'Cards Due', 
                 context: context
               )),
               SizedBox(width: context.responsive.wp(12)),
               Expanded(child: _InsightBox(
                 icon: Icons.play_arrow_outlined, 
                 iconColor: const Color(0xFF2196F3), // Blue
                 value: '${insights.readTodayMinutes}m', 
                 label: 'Read Today', 
                 context: context
               )),
               SizedBox(width: context.responsive.wp(12)),
               Expanded(child: _InsightBox(
                 icon: Icons.check_circle_outline, 
                 iconColor: const Color(0xFF00E676), // Green
                 value: insights.dayStreak.toString(), 
                 label: 'Day Streak', 
                 context: context
               )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _InsightBox({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required BuildContext context,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: context.responsive.sp(16)),
      decoration: BoxDecoration(
        color: const Color(0xFF1E233D),
        borderRadius: BorderRadius.circular(context.responsive.sp(16)),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
           Container(
             padding: EdgeInsets.all(context.responsive.sp(8)),
             decoration: BoxDecoration(
               color: iconColor.withOpacity(0.15),
               shape: BoxShape.circle,
             ),
             child: Icon(icon, color: iconColor, size: context.responsive.sp(20)),
           ),
           SizedBox(height: context.responsive.sp(12)),
           Text(
             value,
             style: TextStyle(
               color: Colors.white,
               fontSize: context.responsive.sp(20),
               fontWeight: FontWeight.bold,
             ),
           ),
           SizedBox(height: context.responsive.sp(4)),
           Text(
              label,
              style: TextStyle(
                color: Colors.white54,
                fontSize: context.responsive.sp(11),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
           ),
        ],
      ),
    );
  }
}
