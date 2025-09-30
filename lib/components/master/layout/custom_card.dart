import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/util/margin_card.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const CustomCard({super.key, required this.child, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MarginCard.screen,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: isLoading ? const CircularProgressIndicator() : child,
        ));
  }
}
