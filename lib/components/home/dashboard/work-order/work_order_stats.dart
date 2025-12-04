import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dasboard_card.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/helpers/util/margin_card.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WorkOrderStats extends StatefulWidget {
  final data;

  const WorkOrderStats({super.key, this.data});

  @override
  State<WorkOrderStats> createState() => _WorkOrderStatsState();
}

class _WorkOrderStatsState extends State<WorkOrderStats> {
  Color getBorderColor(int i) {
    switch (i) {
      case 0:
        return const Color(0xff3b82f6);
      case 1:
        return const Color(0xFF10b981);
      case 2:
        return const Color(0xfff18800);
      default:
        return const Color(0xFF94a3b8);
    }
  }

  Color getIconBgColor(int i) {
    return getBorderColor(i);
  }

  IconData getIcon(int i) {
    switch (i) {
      case 0:
        return Icons.work_outline;
      case 1:
        return Icons.task_alt_outlined;
      case 2:
        return Icons.access_time_outlined;
      default:
        return Icons.error_outline;
    }
  }

  Color getBadgeColor(int i) {
    switch (i) {
      case 0:
        return const Color(0xffdbeaff);
      case 1:
        return const Color(0xffd1fae4);
      case 2:
        return const Color(0xFFfff3c6);
      default:
        return const Color(0xFFf1f5f9);
    }
  }

  Widget buildStatsCard(int i) {
    final item = widget.data[i];

    return DasboardCard(
      withBottomBorder: true,
      bottomBorderColor: getBorderColor(i),
      child: Padding(
        padding: PaddingColumn.screen,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: getIconBgColor(i),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: MarginCard.screen,
                  child: Icon(
                    getIcon(i),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                Text(
                  item['value'].toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ].separatedBy(const SizedBox(width: 8)),
            ),
            CustomBadge(
              title: item['label'],
              withDifferentColor: true,
              color: getBadgeColor(i),
              withStatus: i == 0 ? false : true,
              status: item['label'],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final length = widget.data?.length ?? 0;

    if (length == 0) return const SizedBox();

    return isMobile
        ? Column(
            children: [
              for (int i = 0; i < length; i++) buildStatsCard(i),
            ],
          )
        : Column(
            children: [
              Row(
                children: [
                  for (int i = 0; i < length && i < 2; i++)
                    Expanded(child: buildStatsCard(i))
                ],
              ),
              if (length > 2)
                Row(
                  children: [
                    for (int i = 2; i < length; i++)
                      Expanded(child: buildStatsCard(i))
                  ],
                ),
            ],
          );
  }
}
