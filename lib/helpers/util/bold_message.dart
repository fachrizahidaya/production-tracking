import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

Widget buildBoldMessage({
  required String message,
  required String prefix, // 👈 dynamic
}) {
  final RegExp regExp = RegExp(r'(' + prefix + r'\/\S+)', caseSensitive: false);
  final matches = regExp.allMatches(message);

  if (matches.isEmpty) {
    return Text(
      message,
      style: TextStyle(
        fontSize: CustomTheme().fontSize('lg'),
      ),
    );
  }

  final List<TextSpan> spans = [];
  int start = 0;

  for (final match in matches) {
    // Normal text before match
    if (match.start > start) {
      spans.add(
        TextSpan(
          text: message.substring(start, match.start),
        ),
      );
    }

    // Bold matched text
    spans.add(
      TextSpan(
        text: match.group(0),
        style: TextStyle(
          fontWeight: CustomTheme().fontWeight('bold'),
        ),
      ),
    );

    start = match.end;
  }

  // Remaining normal text
  if (start < message.length) {
    spans.add(
      TextSpan(
        text: message.substring(start),
      ),
    );
  }

  return RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: CustomTheme().fontSize('xl'),
        color: Colors.black,
        height: 1.5,
      ),
      children: spans,
    ),
  );
}
