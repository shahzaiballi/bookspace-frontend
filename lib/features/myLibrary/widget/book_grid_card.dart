import 'package:flutter/material.dart';
import '../../../core/constant/app_colors.dart';
import '../model/book_model.dart';
import 'linear_progress_bar.dart';

// 🔹 ACTION ICON BUILDER
Widget _buildActionButton({
  required IconData icon,
  required Color color,
  required VoidCallback onPressed,
  required String tooltip,
}) {
  // Ensuring a defined, tappable area for a professional feel
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05), // Subtle background for pop
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 4),
    child: IconButton(
      tooltip: tooltip,
      padding: const EdgeInsets.all(8), // Ensures min 48x48 tap area
      constraints: const BoxConstraints(),
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: color,
        size: 20, // Slightly smaller icon within a larger tap area
      ),
    ),
  );
}

class BookGridCard extends StatelessWidget {
  final Book book;
  final VoidCallback onToggleFavorite;
  final VoidCallback onDelete;

  const BookGridCard({
    super.key,
    required this.book,
    required this.onToggleFavorite,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isReading = book.progress > 0 && book.progress < 100;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      // Card structure for the professional floating effect
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 3,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: Colors.white.withOpacity(0.08), // Card background (Dark theme)
          padding: const EdgeInsets.only(left: 10,right:8,top: 16,bottom: 16), // Overall padding
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📘 1. Book Cover Image (Fixed Height 125)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  book.image,
                  fit: BoxFit.cover,
                  width: 80,
                  height: 125, // <-- Vertical reference height
                ),
              ),

              const SizedBox(width: 18),

              // 📖 2. Text + Progress Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Author
                      Text(
                        book.author,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Progress Bar + Status
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProgressBar(value: book.progress),
                          const SizedBox(height: 6),
                          if (book.progress < 100)
                            Text(
                              '${book.progress.toStringAsFixed(0)}% complete',
                              style: TextStyle(
                                color: AppColors.accent.withOpacity(0.9), // Highlight with accent
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),


              SizedBox(
                height: 125,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Favorite Icon
                      _buildActionButton(
                        tooltip: 'Favorite',
                        onPressed: onToggleFavorite,
                        icon: book.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: book.isFavorite ? AppColors.accent : Colors.white54,
                      ),
                      // Delete Icon
                      _buildActionButton(
                        tooltip: 'Delete',
                        onPressed: onDelete,
                        icon: Icons.delete_outline,
                        color: Colors.white54,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}