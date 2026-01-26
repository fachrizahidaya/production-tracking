import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/stats_card.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WorkOrderStats extends StatefulWidget {
  final data;
  final isFetching;

  const WorkOrderStats({super.key, this.data, this.isFetching});

  @override
  State<WorkOrderStats> createState() => _WorkOrderStatsState();
}

class _WorkOrderStatsState extends State<WorkOrderStats> {
  Color getBorderColor(int i) {
    switch (i) {
      case 0:
        return CustomTheme().colors('primary');
      case 1:
        return Color(0xFF10b981);
      case 2:
        return Color(0xfff18800);
      default:
        return CustomTheme().colors('secondary');
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

    return StatsCard(
      bottomBorderColor: getBorderColor(i),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: getIconBgColor(i),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                padding: CustomTheme().padding('badge'),
                child: Icon(
                  getIcon(i),
                  color: Colors.white,
                  size: CustomTheme().iconSize('2xl'),
                ),
              ),
              Text(
                item['value'].toString(),
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('2xl'),
                  fontWeight: CustomTheme().fontWeight('bold'),
                ),
              )
            ].separatedBy(CustomTheme().hGap('lg')),
          ),
          CustomBadge(
            title: item['label'],
            withStatus: i == 0 ? false : true,
            status: item['label'],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data?.length == 0) return SizedBox();

    return widget.isFetching == true
        ? Center(
            child: Padding(
              padding: CustomTheme().padding('content'),
              child: CircularProgressIndicator(),
            ),
          )
        : Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              for (int i = 0; i < widget.data?.length; i++)
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 48) / 2,
                  child: buildStatsCard(i),
                ),
            ],
          );
  }
}
