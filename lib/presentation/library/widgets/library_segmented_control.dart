import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../controllers/library_controller.dart';

class LibrarySegmentedControl extends ConsumerWidget {
  const LibrarySegmentedControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(libraryFilterProvider);

    Map<int, Widget> children = {
      0: _buildSegment('All Books', 0, currentIndex, context),
      1: _buildSegment('Favorites', 1, currentIndex, context),
      2: _buildSegment('In Progress', 2, currentIndex, context),
      3: _buildSegment('Completed', 3, currentIndex, context),
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(20), vertical: context.responsive.sp(8)),
      child: CupertinoSlidingSegmentedControl<int>(
        backgroundColor: const Color(0xFF1E233D),
        thumbColor: const Color(0xFF381A5D), // Dark purple thumb
        groupValue: currentIndex,
        onValueChanged: (int? value) {
          if (value != null) {
            ref.read(libraryFilterProvider.notifier).state = value;
          }
        },
        children: children,
      ),
    );
  }

  Widget _buildSegment(String text, int index, int currentIndex, BuildContext context) {
    final isSelected = index == currentIndex;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.responsive.sp(8)),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white54,
          fontSize: context.responsive.sp(12),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

