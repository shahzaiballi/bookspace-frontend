import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';

class FlashcardControls extends StatelessWidget {
  final VoidCallback onReviewLater;
  final VoidCallback onGotIt;
  final bool isVisible;

  const FlashcardControls({
    super.key,
    required this.onReviewLater,
    required this.onGotIt,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCircularButton(
            context: context,
            icon: Icons.replay,
            label: 'Review Later',
            color: Colors.orangeAccent,
            onTap: isVisible ? onReviewLater : null,
          ),
          SizedBox(width: context.responsive.wp(40)),
          _buildCircularButton(
            context: context,
            icon: Icons.check,
            label: 'Got it',
            color: Colors.greenAccent,
            onTap: isVisible ? onGotIt : null,
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(context.responsive.sp(20)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.1),
              border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
            ),
            child: Icon(icon, color: color, size: context.responsive.sp(32)),
          ),
        ),
        SizedBox(height: context.responsive.sp(12)),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: context.responsive.sp(14),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
