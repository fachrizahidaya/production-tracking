import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final withBadgeBorder;

  const CustomCard(
      {super.key, required this.child, this.withBadgeBorder = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: withBadgeBorder == true
          ? CustomTheme().badgeTheme('')
          : CustomTheme().cardTheme(),
      padding: CustomTheme().padding('card'),
      child: child,
    );
  }
}
