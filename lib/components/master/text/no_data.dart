import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';

class NoData extends StatelessWidget {
  final double fontSize;
  final Color? color;

  const NoData({super.key, this.fontSize = 16.0, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingColumn.screen,
      child: Text(
        'No Data',
        style: TextStyle(
            fontSize: fontSize, color: CustomTheme().colors('text-primary')),
      ),
    );
  }
}
