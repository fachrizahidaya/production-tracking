import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/util/margin_card.dart';

class DasboardCard extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bottomBorderColor;
  final withBottomBorder;

  const DasboardCard(
      {super.key,
      required this.child,
      this.isLoading = false,
      this.bottomBorderColor,
      this.withBottomBorder = false // default border color
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: MarginCard.screen,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: withBottomBorder == true
                      ? bottomBorderColor
                      : Colors.white,
                  width: 2, // adjust thickness here
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : child,
            ),
          ),
        ),
      ],
    );
  }
}
