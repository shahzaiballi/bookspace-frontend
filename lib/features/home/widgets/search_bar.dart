
import 'package:flutter/material.dart';
import '../../../core/constant/app_colors.dart';
import '../model/user_data.dart';

class GlowingSearchBar extends StatefulWidget {
  const GlowingSearchBar({super.key});

  @override
  State<GlowingSearchBar> createState() => _GlowingSearchBarState();
}

class _GlowingSearchBarState extends State<GlowingSearchBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          _isSearching
              ? Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
            ),
          )
              : Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(currentUser.avatarUrl),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: 10),
              Text(
                "Welcome back, ${currentUser.name}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // RIGHT SIDE - Icons Row
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) _searchController.clear();
                  });
                },
                child: Icon(
                  _isSearching ? Icons.close_rounded : Icons.search_rounded,
                  color: Colors.white70,
                  size: 22,
                ),
              ),
              const SizedBox(width: 8),
              if (!_isSearching) ...[
                Icon(Icons.local_fire_department_rounded,
                    color: Colors.orange, size: 22),
                const SizedBox(width: 8),
                Icon(Icons.notifications_none, color: Colors.white, size: 22),
              ]
            ],
          ),
        ],
      ),
    );
  }
}

