import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';

class CustomBadge extends StatelessWidget {
  final String title;
  const CustomBadge({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: PaddingColumn.screen,
      child: Text(
        title,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
