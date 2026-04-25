import 'package:flutter/material.dart';
import '../../../../domain/entities/achievement_entity.dart';
import '../../../../core/utils/responsive_utils.dart';

class AchievementTile extends StatelessWidget {
  final AchievementEntity achievement;

  const AchievementTile({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
       margin: EdgeInsets.only(bottom: context.responsive.sp(12)),
       padding: EdgeInsets.all(context.responsive.sp(16)),
       decoration: BoxDecoration(
          color: const Color(0xFF1E233D),
          borderRadius: BorderRadius.circular(context.responsive.sp(12)),
       ),
       child: Row(
          children: [
             Container(
               width: context.responsive.sp(44),
               height: context.responsive.sp(44),
               decoration: BoxDecoration(
                  color: const Color(0xFF2A2F4C),
                  borderRadius: BorderRadius.circular(context.responsive.sp(10)),
               ),
               child: Center(
                  child: Text(
                     _getEmoji(achievement.iconCode),
                     style: TextStyle(fontSize: context.responsive.sp(20)),
                  ),
               ),
             ),
             SizedBox(width: context.responsive.wp(16)),
             Expanded(
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                      Text(
                         achievement.title,
                         style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(14), fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: context.responsive.sp(4)),
                      Text(
                         achievement.description,
                         style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(12)),
                      ),
                   ],
                ),
             )
          ],
       ),
    );
  }

  String _getEmoji(String code) {
    switch (code) {
      case 'trophy': return '🏆';
      case 'books': return '📚';
      case 'target': return '🎯';
      default: return '🏅';
    }
  }
}

