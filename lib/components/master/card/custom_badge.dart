import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CustomBadge extends StatelessWidget {
  final String title;
  final status;
  final withStatus;
  final rework;
  final forMachine;

  const CustomBadge(
      {super.key,
      required this.title,
      this.status,
      this.withStatus = false,
      this.rework = false,
      this.forMachine = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: CustomTheme().padding(rework ? 'badge-rework' : 'badge'),
        decoration: forMachine == true
            ? CustomTheme().containerCardDecoration()
            : CustomTheme().badgeTheme(status),
        child: Row(
          children: [
            if (withStatus == true) CustomTheme().icon(status),
            Text(
              title,
              style: TextStyle(
                  fontSize: CustomTheme().fontSize(rework ? 'sm' : null)),
            ),
          ].separatedBy(CustomTheme().hGap('lg')),
        ));
  }
}
