// ignore_for_file: deprecated_member_use

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
  final customHeight;

  const CancelButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.backgroundColor,
      this.fontSize = 16.0,
      this.padding =
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      this.borderRadius = 8.0,
      this.width,
      this.customHeight});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: CustomTheme().secondaryButton().copyWith(
            minimumSize: customHeight != null
                ? MaterialStateProperty.all(Size(double.infinity, customHeight))
                : null,
          ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: fontSize, color: CustomTheme().colors('danger')),
      ),
    );
  }
}
