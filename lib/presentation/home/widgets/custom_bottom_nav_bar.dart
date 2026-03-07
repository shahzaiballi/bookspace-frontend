import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF10142A),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      padding: EdgeInsets.symmetric(vertical: context.responsive.sp(8)),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
             _NavBarItem(icon: Icons.home_filled, label: 'Home', isSelected: currentIndex == 0, onTap: () => onTap(0), context: context),
             _NavBarItem(icon: Icons.library_books, label: 'Library', isSelected: currentIndex == 1, onTap: () => onTap(1), context: context),
             _NavBarItem(icon: Icons.chat_bubble_outline, label: 'Discussions', isSelected: currentIndex == 2, onTap: () => onTap(2), context: context),
             _NavBarItem(icon: Icons.person_outline, label: 'Profile', isSelected: currentIndex == 3, onTap: () => onTap(3), context: context),
          ],
        ),
      ),
    );
  }

  Widget _NavBarItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(16), vertical: context.responsive.sp(8)),
        decoration: isSelected 
          ? BoxDecoration(color: const Color(0xFFB062FF).withOpacity(0.15), borderRadius: BorderRadius.circular(context.responsive.sp(12))) 
          : const BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Icon(icon, color: isSelected ? const Color(0xFFB062FF) : Colors.white54, size: context.responsive.sp(24)),
             SizedBox(height: context.responsive.sp(4)),
             Text(
               label,
               style: TextStyle(
                 color: isSelected ? const Color(0xFFB062FF) : Colors.white54,
                 fontSize: context.responsive.sp(10),
                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
               ),
             )
          ],
        ),
      ),
    );
  }
}
