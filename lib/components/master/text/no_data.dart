import 'package:flutter/material.dart';
import 'package:production_tracking/helpers/util/padding_column.dart';

class NoData extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;

  const NoData(
      {super.key, required this.text, this.fontSize = 16.0, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: PaddingColumn.screen);
  }
}
