import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dasboard_card.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/helpers/util/margin_card.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class SummaryStatusCard extends StatefulWidget {
  final summary;

  const SummaryStatusCard({super.key, this.summary});

  @override
  State<SummaryStatusCard> createState() => _SummaryStatusCardState();
}

class _SummaryStatusCardState extends State<SummaryStatusCard> {
  Color getBorderColor(int i) {
    switch (i) {
      case 0:
        return const Color(0xFF10b981);
      case 1:
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
        return Icons.task_alt_outlined;
      case 1:
        return Icons.access_time_outlined;
      default:
        return Icons.error_outline;
    }
  }

  Color getBadgeColor(int i) {
    switch (i) {
      case 0:
        return const Color(0xffd1fae4);
      case 1:
        return const Color(0xFFfff3c6);
      default:
        return const Color(0xFFf1f5f9);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.summary == null) return const SizedBox();
    final isMobile = MediaQuery.of(context).size.width < 600;

    final List<Map<String, dynamic>> summaryList = [
      {"label": "Completed", "value": widget.summary["completed"]},
      {"label": "In Progress", "value": widget.summary["in_progress"]},
      {"label": "Waiting", "value": widget.summary["waiting"]},
    ];

    Widget buildStatsCard(int i) {
      final item = summaryList[i];

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
                withStatus: true,
                status: item['label'],
                icon: getIcon(i),
              )
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < summaryList.length; i++) buildStatsCard(i),
      ],
    );
  }
}
