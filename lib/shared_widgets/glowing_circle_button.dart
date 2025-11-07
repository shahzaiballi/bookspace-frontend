import 'package:flutter/material.dart';
import '../core/constant/app_colors.dart';

class GlowingCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const GlowingCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.accent.withOpacity(0.9), width: 2.2),
          boxShadow: [
            BoxShadow(color: AppColors.accent.withOpacity(0.28), blurRadius: 18, spreadRadius: 3),
          ],
        ),
        child: Center(
          child: Icon(icon, color: AppColors.accent.withOpacity(0.95), size: 30),
        ),
      ),
    );
  }
}
