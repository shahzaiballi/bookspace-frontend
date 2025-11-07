
import 'package:flutter/material.dart';
import '../../../core/constant/app_colors.dart';
import '../../../shared_widgets/glowing_button.dart';
import 'circular_progress.dart';

class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.accent.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          // Book Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              "assets/images/book.jpg",
              height: 150,
              width: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),

          // Book Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "The Great Gatsby",
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Text(
                  "F. Scott Fitzgerald",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 10),


              ],
            ),
          ),

          // Continue Button
          Column(
            children: [
              const CircularProgress(progress: 0.62),
              SizedBox(height: 10,),
              SizedBox(
                width: 120,
                height: 40,
                child: GlowingButton(
                  text: "Continue",
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
