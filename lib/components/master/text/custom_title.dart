import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

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
      style: TextStyle(
          fontSize: fontSize,
          color: color ?? CustomTheme().colors('text-primary')),
    );
  }
}
