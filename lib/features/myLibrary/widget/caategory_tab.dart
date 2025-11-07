import 'package:flutter/material.dart';

class CategoryTabs extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;
  final List<String> categories;

  const CategoryTabs({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tabWidth = (constraints.maxWidth - ((categories.length - 1) * 8)) / categories.length;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: categories.map((category) {
            final isSelected = category == selected;

            return GestureDetector(
              onTap: () => onChanged(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: tabWidth, // 👈 Force equal width
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Colors.tealAccent
                        : Colors.tealAccent.withOpacity(0.4),
                  ),
                  color: isSelected
                      ? Colors.tealAccent.withOpacity(0.15)
                      : Colors.transparent,
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: Colors.tealAccent.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  category,
                  style: TextStyle(
                    color:
                    isSelected ? Colors.tealAccent : Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

