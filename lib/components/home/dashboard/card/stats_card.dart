import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class StatsCard extends StatelessWidget {
  final Widget child;
  final bottomBorderColor;

  const StatsCard({
    super.key,
    required this.child,
    this.bottomBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CustomTheme().statsCardTheme(bottomBorderColor),
      padding: CustomTheme().padding('card'),
      child: child,
    );
  }
}
