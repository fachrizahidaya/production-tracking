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
        return CustomTheme().colors('Selesai');
      case 2:
        return CustomTheme().colors('Diproses');
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
        return CustomTheme().statusColor('Total Work Orders');
      case 1:
        return CustomTheme().statusColor('Selesai');
      case 2:
        return CustomTheme().statusColor('Diproses');
      default:
        return CustomTheme().statusColor('Menunggu Diproses');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data == null || widget.data.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (widget.isFetching == true) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 8 : 16,
          ),
          child: const CircularProgressIndicator(),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = isMobile ? 10.0 : 16.0;

        final cardWidth = isMobile
            ? constraints.maxWidth
            : (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: isMobile ? 10 : 12,
          children: [
            for (int i = 0; i < widget.data.length; i++)
              SizedBox(
                width: cardWidth,
                child: buildStatsCard(i, isMobile),
              ),
          ],
        );
      },
    );
  }

  Widget buildStatsCard(int i, bool isMobile) {
    final item = widget.data[i];

    return StatsCard(
      bottomBorderColor: getBorderColor(i),
      child: isMobile
          ? _buildMobileStatsCard(item, i)
          : _buildTabletStatsCard(item, i),
    );
  }

  Widget _buildTabletStatsCard(dynamic item, int i) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: getIconBgColor(i),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(9),
          child: Icon(
            getIcon(i),
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            item['value'].toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 26,
              fontWeight: CustomTheme().fontWeight('bold'),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: CustomBadge(
            title: item['label'],
            withStatus: i != 0,
            status: item['label'],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileStatsCard(dynamic item, int i) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: getIconBgColor(i),
            borderRadius: BorderRadius.circular(7),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(
            getIcon(i),
            color: Colors.white,
            size: 21,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item['value'].toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: CustomTheme().fontWeight('bold'),
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomBadge(
                  title: item['label'],
                  withStatus: i != 0,
                  status: item['label'],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
