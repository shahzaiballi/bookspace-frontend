
import 'package:flutter/material.dart';

import '../../../core/constant/app_colors.dart';

class CircularProgress extends StatelessWidget {
  final double progress; // 0.0 to 1.0

  const CircularProgress({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 5,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation(AppColors.accent),
          ),
          Text(
            "${(progress * 100).toInt()}%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
