import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constant/app_colors.dart'; // Ensure this path is correct

class AddBookSheetContent extends StatelessWidget {
  const AddBookSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // We use a Stack to place the blurred image/background first,
    // and then the content on top.
    return Stack(
      children: [
        // ❌ NOTE: The background is blurred here because we assume the
        // home screen itself is what's being blurred by the default
        // showModalBottomSheet behavior (which uses a semi-transparent barrier).
        // To strictly blur *only* the sheet's area and nothing else:

        // 1. We wrap the entire sheet content in ClipRRect to define the area.
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  // 2. The Blur Effect Layer
                  // This is a Box that covers the sheet's area and applies the blur.
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Stronger blur
                    child: Container(
                      color: Colors.black.withOpacity(0.0), // Fully transparent to let the blur show through
                      height: 350, // Set a defined height or use IntrinsicHeight
                      width: double.infinity,
                    ),
                  ),

                  // 3. Sheet Content Layer (on top of the blur)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      // Using a semi-transparent color for depth
                      color: Colors.black.withOpacity(0.6),
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.3),
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 1. Drag Handle
                        Center(
                          child: Container(
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 2. Title
                        const Text(
                          "Add a Book",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 3. Action Cards
                        Row(
                          children: [
                            // Search Online Card
                            Expanded(
                              child: _ActionCard(
                                icon: Icons.search_rounded,
                                title: "Search Online",
                                onTap: () {
                                  Navigator.pop(context);
                                  // TODO: Navigate to search screen
                                },
                                color: AppColors.accent,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Upload from Gallery Card
                            Expanded(
                              child: _ActionCard(
                                icon: Icons.file_upload_outlined,
                                title: "Upload from Gallery",
                                onTap: () {
                                  Navigator.pop(context);
                                  // TODO: Open gallery
                                },
                                color: Colors.blueAccent.shade100,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // 4. Cancel Button
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Colors.white54, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Widget for the Action Card Design (same as before)
class _ActionCard extends StatelessWidget {
  // ... (Your _ActionCard code remains the same as in the previous response) ...
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}