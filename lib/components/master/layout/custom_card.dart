import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/util/margin_card.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color? color;
  final bool withBorder;
  final bool withBottomBorder;
  final Color? bottomBorderColor;

  const CustomCard({
    super.key,
    required this.child,
    this.isLoading = false,
    this.color,
    this.withBorder = false,
    this.withBottomBorder = false,
    this.bottomBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MarginCard.screen,
      child: Card(
        color: color ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: withBorder
              ? BorderSide(
                  color: Colors.grey.shade400,
                  width: 1.0,
                )
              : BorderSide.none,
        ),
        elevation: 1,
        child: Container(
          decoration: BoxDecoration(
            border: withBottomBorder
                ? Border(
                    bottom: BorderSide(
                      color: bottomBorderColor ?? Colors.grey.shade400,
                      width: 2,
                    ),
                  )
                : null,
          ),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : child,
        ),
      ),
    );
  }
}
