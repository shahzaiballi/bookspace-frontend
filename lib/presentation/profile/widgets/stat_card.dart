import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
       child: Container(
          margin: EdgeInsets.symmetric(horizontal: context.responsive.wp(4)),
          padding: EdgeInsets.symmetric(vertical: context.responsive.sp(16)),
          decoration: BoxDecoration(
             color: const Color(0xFF1E233D),
             borderRadius: BorderRadius.circular(context.responsive.sp(12)),
          ),
          child: Column(
             children: [
                Icon(icon, color: const Color(0xFFB062FF), size: context.responsive.sp(22)),
                SizedBox(height: context.responsive.sp(12)),
                Text(
                   value,
                   style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(16), fontWeight: FontWeight.bold),
                ),
                SizedBox(height: context.responsive.sp(4)),
                Text(
                   label,
                   style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(11)),
                )
             ],
          ),
       ),
    );
  }
}

