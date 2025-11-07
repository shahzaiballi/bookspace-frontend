import 'package:flutter/material.dart';
import '../core/constant/app_colors.dart';

class GlowingButton extends StatelessWidget {
  final String text;
  final Widget? child;
  final VoidCallback onTap;

  const GlowingButton({
    required this.text,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width, // ✅ Safe width
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.accent.withOpacity(0.95),
              AppColors.accent.withOpacity(0.75),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.45),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: child ??
            Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
      ),
    );
  }
}
