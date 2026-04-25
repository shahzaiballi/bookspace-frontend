import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int count;

  const DotIndicator({
    super.key,
    required this.currentIndex,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: currentIndex == index ? 24 : 8,
          decoration: BoxDecoration(
            color: currentIndex == index ? const Color(0xFFB062FF) : Colors.white24,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

