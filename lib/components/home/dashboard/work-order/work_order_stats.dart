import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/stats_card.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/theme.dart';
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
      withBottomBorder: true,
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
            withDifferentColor: true,
            color: getBadgeColor(i),
            withStatus: i == 0 ? false : true,
            status: item['label'],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final length = widget.data?.length ?? 0;

    if (length == 0) return const SizedBox();

    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < length && i < 2; i++)
              Expanded(child: buildStatsCard(i))
          ].separatedBy(CustomTheme().hGap('lg')),
        ),
        if (length > 2)
          Row(
            children: [
              for (int i = 2; i < length; i++)
                Expanded(child: buildStatsCard(i))
            ].separatedBy(CustomTheme().hGap('lg')),
          ),
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }
}
