import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: onTap,
       child: Container(
          margin: EdgeInsets.only(bottom: context.responsive.sp(12)),
          padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(16), vertical: context.responsive.sp(16)),
          decoration: BoxDecoration(
             color: const Color(0xFF1E233D),
             borderRadius: BorderRadius.circular(context.responsive.sp(12)),
          ),
          child: Row(
             children: [
                Container(
                   padding: EdgeInsets.all(context.responsive.sp(10)),
                   decoration: BoxDecoration(
                      color: const Color(0xFF2A2F4C),
                      borderRadius: BorderRadius.circular(context.responsive.sp(10)),
                   ),
                   child: Icon(icon, color: const Color(0xFFB062FF), size: context.responsive.sp(18)),
                ),
                SizedBox(width: context.responsive.wp(16)),
                Expanded(
                  child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                        Text(
                           title,
                           style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(14), fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: context.responsive.sp(4)),
                        Text(
                           subtitle,
                           style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(12)),
                        )
                     ],
                  ),
                ),
                trailing,
             ],
          ),
       ),
    );
  }
}

