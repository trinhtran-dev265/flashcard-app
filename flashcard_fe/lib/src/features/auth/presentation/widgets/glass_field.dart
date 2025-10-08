import 'package:flutter/material.dart';

class GlassField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Widget? leading;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const GlassField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.leading,
    this.trailing,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final baseFill = Colors.white.withValues(alpha: 0.06);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: Colors.white.withValues(alpha: 0.28),
        width: 1,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.06),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: leading,
          suffixIcon: trailing,
          hintText: hintText,
          filled: true,
          fillColor: baseFill,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.55),
              width: 1.2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
