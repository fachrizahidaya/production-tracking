import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class StatsCard extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bottomBorderColor;
  final withBottomBorder;
  final bgColor;

  const StatsCard(
      {super.key,
      required this.child,
      this.isLoading = false,
      this.bottomBorderColor,
      this.withBottomBorder = false,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CustomTheme().statsCardTheme(bottomBorderColor),
      padding: CustomTheme().padding('card'),
      child: child,
    );
  }
}
