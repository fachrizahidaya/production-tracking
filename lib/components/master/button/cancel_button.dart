import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double? width;

  const CancelButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.backgroundColor,
      this.fontSize = 16.0,
      this.padding =
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      this.borderRadius = 8.0,
      this.width});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.grey),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
