import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/stats_card.dart';
import 'package:textile_tracking/components/master/theme.dart';

class WorkOrderStats extends StatefulWidget {
  final dynamic data;
  final bool isFetching;
  final bool isMobile;

  const WorkOrderStats({
    super.key,
    this.data,
    this.isFetching = false,
    this.isMobile = true,
  });

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

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    if (widget.data?.length == 0) return const SizedBox();

    if (widget.isFetching) {
      return Padding(
        padding: CustomTheme().padding('content'),
        child: const Center(
          child: CircularProgressIndicator(),
=======
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
>>>>>>> d86a31e7 (fix: UI mobile dashboard)
        ),
      );
    }

<<<<<<< HEAD
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(16, 0, 16, 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 16.0;
          final cardWidth = (constraints.maxWidth - spacing) / 2;

          return Wrap(
            spacing: spacing,
            runSpacing: widget.isMobile ? 8 : 16,
            children: [
              for (int i = 0; i < widget.data.length; i++)
                SizedBox(
                  width: cardWidth,
                  child: widget.isMobile
                      ? _buildMobileCard(i)
                      : _buildTabletCard(i),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabletCard(int index) {
    final item = widget.data[index];
    final label = item['label']?.toString() ?? '';
    final value = item['value']?.toString() ?? '0';

    return StatsCard(
      bottomBorderColor: getBorderColor(index),
      child: SizedBox(
        height: 120,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              right: 75,
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A566A),
                  height: 1.2,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: _buildIcon(index),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                      height: 0.9,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'WO',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF98A2B3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileCard(int index) {
    final item = widget.data[index];
    final label = item['label']?.toString() ?? '';
    final value = item['value']?.toString() ?? '0';

    return StatsCard(
      bottomBorderColor: getBorderColor(index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A566A),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF101828),
                  height: 0.9,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'WO',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF98A2B3),
=======
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
>>>>>>> d86a31e7 (fix: UI mobile dashboard)
                ),
              ),
            ],
          ),
<<<<<<< HEAD
        ],
      ),
=======
        ),
      ],
>>>>>>> d86a31e7 (fix: UI mobile dashboard)
    );
  }

  Widget _buildIcon(int index) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: getBorderColor(index),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Icon(
        getIcon(index),
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
