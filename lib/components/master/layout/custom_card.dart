import 'package:flutter/material.dart';
import 'package:production_tracking/helpers/util/padding_column.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const CustomCard({super.key, required this.child, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: PaddingColumn.screen,
        child: isLoading ? const CircularProgressIndicator() : child,
      ),
    );
  }
}
