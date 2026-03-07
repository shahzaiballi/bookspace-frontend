import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';

class QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final bool hasNotification;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.hasNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
       margin: EdgeInsets.only(bottom: context.responsive.sp(12)),
       decoration: BoxDecoration(
          color: const Color(0xFF1E233D),
          borderRadius: BorderRadius.circular(context.responsive.sp(12)),
          // Subtle glow effect as seen on 'Reading Plan' in design if it's the primary color
          boxShadow: iconColor == const Color(0xFFB062FF) ? [
             BoxShadow(color: const Color(0xFFB062FF).withOpacity(0.1), blurRadius: 20, spreadRadius: -5)
          ] : [],
       ),
       child: Material(
         color: Colors.transparent,
         child: InkWell(
           borderRadius: BorderRadius.circular(context.responsive.sp(12)),
           onTap: onTap,
           child: Padding(
             padding: EdgeInsets.all(context.responsive.sp(16)),
             child: Row(
               children: [
                  Container(
                    padding: EdgeInsets.all(context.responsive.sp(10)),
                    decoration: BoxDecoration(
                       color: iconColor.withOpacity(0.15),
                       shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: context.responsive.sp(20)),
                  ),
                  SizedBox(width: context.responsive.wp(16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(title, style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(15), fontWeight: FontWeight.bold)),
                         SizedBox(height: context.responsive.sp(4)),
                         Text(subtitle, style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(13))),
                      ],
                    ),
                  ),
                  if (hasNotification)
                    Container(
                      margin: EdgeInsets.only(right: context.responsive.wp(12)),
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                      child: Text('1', style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(10), fontWeight: FontWeight.bold)),
                    ),
                  Icon(Icons.chevron_right, color: Colors.white30, size: context.responsive.sp(20)),
               ],
             ),
           ),
         ),
       ),
    );
  }
}
