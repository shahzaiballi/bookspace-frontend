import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../domain/entities/flashcard_entity.dart';

class FlipCardWidget extends StatelessWidget {
  final FlashcardEntity flashcard;
  final bool isFlipped;
  final VoidCallback onTap;

  const FlipCardWidget({
    super.key,
    required this.flashcard,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: isFlipped ? pi : 0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        builder: (context, val, child) {
          bool isBack = val >= (pi / 2);
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(val),
            child: isBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _buildBack(context),
                  )
                : _buildFront(context),
          );
        },
      ),
    );
  }

  Widget _buildFront(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.responsive.sp(400),
      decoration: BoxDecoration(
        color: const Color(0xFF1A223B), // Dark Navy Background
        borderRadius: BorderRadius.circular(context.responsive.sp(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.white10, width: 1),
      ),
      padding: EdgeInsets.all(context.responsive.sp(32)),
      child: Center(
        child: Text(
          flashcard.question,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: context.responsive.sp(22),
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildBack(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.responsive.sp(400),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB062FF), Color(0xFF6A4CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(context.responsive.sp(24)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB062FF).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(context.responsive.sp(32)),
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            flashcard.answer,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: context.responsive.sp(20),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
