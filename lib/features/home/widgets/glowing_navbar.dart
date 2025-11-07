
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:fyp_future/features/myLibrary/library_screen.dart';
import '../../../core/constant/app_colors.dart';
import '../home_Screen.dart';
import 'add_book_bottom_sheet.dart';


class GlowingNavBar extends StatefulWidget {
  const GlowingNavBar({super.key});

  @override
  State<GlowingNavBar> createState() => _GlowingNavBarState();
}

class _GlowingNavBarState extends State<GlowingNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    LibraryScreen(),
    Center(child: Text('Community Coming Soon', style: TextStyle(color: Colors.white))),
    Center(child: Text('Profile Coming Soon', style: TextStyle(color: Colors.white))),
  ];

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SingleChildScrollView(
        child: const AddBookSheetContent(),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, {VoidCallback? onTap}) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: onTap ??
              () {
            setState(() {
              _selectedIndex = index;
            });
          },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.36),
              blurRadius: 12,
              spreadRadius: 2,
            )
          ]
              : [],
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.accent : Colors.white70,
          size: 26,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,

      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.15),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavIcon(Icons.home, 0),
                  _buildNavIcon(Icons.library_books, 1),

                  GestureDetector(
                    onTap: () => _showAddSheet(context),
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.accent,
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),

                  _buildNavIcon(Icons.people, 2),
                  _buildNavIcon(Icons.person, 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}