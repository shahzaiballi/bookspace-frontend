import 'package:flutter/material.dart';
import '../core/constant/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final baseBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white24, width: 1.0),
    );

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: AppColors.textLight),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.accent, width: 1.5),
        ),
        suffixIcon: suffixIcon,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}
