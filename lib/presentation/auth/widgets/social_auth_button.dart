import 'package:flutter/material.dart';

class SocialAuthButton extends StatelessWidget {
  final String text;
  final Widget icon; // Using Widget so we can pass Image or Icon
  final VoidCallback onPressed;

  const SocialAuthButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
         color: const Color(0xFF1E233D), // Slightly lighter than background, matching design
         borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               icon,
               const SizedBox(width: 12),
               Text(
                 text,
                 style: const TextStyle(
                   color: Colors.white,
                   fontSize: 14,
                   fontWeight: FontWeight.w500,
                 ),
               )
            ],
          ),
        ),
      ),
    );
  }
}

