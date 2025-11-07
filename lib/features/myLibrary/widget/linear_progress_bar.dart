import 'package:flutter/material.dart';
import '../../../core/constant/app_colors.dart';

class ProgressBar extends StatelessWidget {
  final double value;
  const ProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15), // unfilled visible background
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3), // slight glowing border
          width: 0.8,
        ),
      ),
      child: Stack(
        children: [
          // Unfilled area
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Filled area (progress)
          FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.9),
                    AppColors.accent.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.7),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
