import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class ClickableText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final TextStyle? style;

  const ClickableText({
    super.key,
    required this.text,
    required this.onTap,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
            fontSize: CustomTheme().fontSize('lg'),
            fontWeight: CustomTheme().fontWeight('semibold'),
            decoration: TextDecoration.underline,
            color: CustomTheme().colors('primary')),
        softWrap: true,
        overflow: TextOverflow.visible,
        maxLines: null,
      ),
    );
  }
}
