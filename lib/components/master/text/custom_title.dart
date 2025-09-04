import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign textAlign;
  final double fontSize;

  const CustomTitle(
      {super.key,
      required this.text,
      this.fontSize = 16,
      this.color,
      this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(fontSize: fontSize, color: color ?? Colors.grey),
    );
  }
}
