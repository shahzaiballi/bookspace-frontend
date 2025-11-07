
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/constant/app_colors.dart';

class GlowingProgress extends StatefulWidget {
  final double progress; // 0.0 → 1.0

  const GlowingProgress({super.key, required this.progress});

  @override
  State<GlowingProgress> createState() => _GlowingProgressState();
}

class _GlowingProgressState extends State<GlowingProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return CustomPaint(
          size: const Size(50, 50),
          painter: _CircularPainter(_animation.value),
        );
      },
    );
  }
}

class _CircularPainter extends CustomPainter {
  final double progress;

  _CircularPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 5.0;
    final rect = Offset.zero & size;

    final base = Paint()
      ..color = Colors.white24
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final glow = Paint()
      ..color = AppColors.accent
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);

    final arcAngle = 2 * math.pi * progress;
    canvas.drawArc(rect.deflate(strokeWidth / 2), -math.pi / 2, arcAngle, false, base);
    canvas.drawArc(rect.deflate(strokeWidth / 2), -math.pi / 2, arcAngle, false, glow);
  }

  @override
  bool shouldRepaint(covariant _CircularPainter old) =>
      old.progress != progress;
}
