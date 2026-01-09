import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color? color;
  final bool withBorder;
  final bool withBottomBorder;
  final Color? bottomBorderColor;
  final bool useCustomSize;
  final double? customWidth;
  final double? customHeight;
  final withBadgeBorder;

  const CustomCard(
      {super.key,
      required this.child,
      this.isLoading = false,
      this.color,
      this.withBorder = false,
      this.withBottomBorder = false,
      this.bottomBorderColor,
      this.customHeight,
      this.customWidth,
      this.useCustomSize = false,
      this.withBadgeBorder = false});

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
