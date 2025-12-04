import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/util/margin_card.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CustomBadge extends StatelessWidget {
  final String title;
  final color;
  final withDifferentColor;
  final status;
  final withStatus;
  final icon;

  const CustomBadge(
      {super.key,
      required this.title,
      this.color,
      this.withDifferentColor = false,
      this.status,
      this.withStatus,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: withDifferentColor == true ? color : Colors.green.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: MarginCard.screen,
        child: Row(
          children: [
            if (withStatus == true)
              Icon(
                icon ??
                    (status == 'Menunggu Diproses'
                        ? Icons.warning_outlined
                        : status == 'Diproses'
                            ? Icons.access_time_outlined
                            : status == 'Selesai'
                                ? Icons.task_alt_outlined
                                : null),
                size: 16,
              ),
            Text(
              title,
              style: TextStyle(fontSize: 14),
            ),
          ].separatedBy(SizedBox(
            width: 4,
          )),
        ));
  }
}
