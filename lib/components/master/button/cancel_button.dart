import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

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
      style: CustomTheme().secondaryButton(),
      child: Text(
        label,
        style: TextStyle(color: CustomTheme().colors('danger')),
      ),
    );
  }
}
