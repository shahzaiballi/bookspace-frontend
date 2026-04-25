import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String? label;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.label,
    this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && widget.label!.isNotEmpty) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F36), // Slightly lighter than scaffold background
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Colors.white38),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                 vertical: 18, 
                 horizontal: widget.prefixIcon == null ? 16 : 0,
              ),
              prefixIcon: widget.prefixIcon != null 
                  ? Icon(widget.prefixIcon, color: Colors.white54, size: 20)
                  : null,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.white54,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

