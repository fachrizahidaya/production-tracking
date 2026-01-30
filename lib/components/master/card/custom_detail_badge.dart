import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CustomDetailBadge extends StatelessWidget {
  final status;
  final rework;
  final forMachine;
  final label;
  final value;
  final child;
  final width;

  const CustomDetailBadge(
      {super.key,
      this.status,
      this.rework = false,
      this.forMachine = false,
      this.label,
      this.value,
      this.child,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        padding: CustomTheme().padding(rework ? 'badge-rework' : 'badge'),
        decoration: forMachine == true
            ? CustomTheme().containerCardDecoration()
            : CustomTheme().badgeTheme(status),
        child: Row(
          children: [
            ViewText(
              viewLabel: label,
              viewValue: value,
              childValue: child,
            ),
          ].separatedBy(CustomTheme().hGap('lg')),
        ));
  }
}
