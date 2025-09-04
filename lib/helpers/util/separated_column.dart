import 'package:flutter/material.dart';

extension SeparatedColumn on List<Widget> {
  List<Widget> separatedBy(Widget separator) {
    return expand((widget) sync* {
      yield widget;
      yield separator;
    }).toList()
      ..removeLast();
  }
}
