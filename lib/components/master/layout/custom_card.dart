import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/util/margin_card.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final color;
  final withBorder;

  const CustomCard(
      {super.key,
      required this.child,
      this.isLoading = false,
      this.color,
      this.withBorder = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MarginCard.screen,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: withBorder
                ? BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  )
                : BorderSide.none,
          ),
          color: color ?? Colors.white,
          child: isLoading ? const CircularProgressIndicator() : child,
        ));
  }
}
