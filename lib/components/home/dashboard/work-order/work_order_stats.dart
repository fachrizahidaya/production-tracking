import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/stats_card.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WorkOrderStats extends StatefulWidget {
  final dynamic data;
  final bool isFetching;

  const WorkOrderStats({
    super.key,
    this.data,
    this.isFetching = false,
  });

  @override
  State<WorkOrderStats> createState() => _WorkOrderStatsState();
}

class _WorkOrderStatsState extends State<WorkOrderStats> {
  static const double tabletBreakpoint = 600;

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
    if (widget.data == null || widget.data.isEmpty) {
      return const SizedBox.shrink();
    }

    if (widget.isFetching) {
      return Padding(
        padding: CustomTheme().padding('content'),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Tablet = 2 kolom
        // Mobile = 1 kolom
        final isTablet = width >= tabletBreakpoint;

        final columnCount = isTablet ? 2 : 1;
        const spacing = 16.0;

        final cardWidth =
            columnCount == 1 ? width : (width - spacing) / columnCount;

        return Wrap(
          spacing: spacing,
          runSpacing: 16,
          children: [
            for (int i = 0; i < widget.data.length; i++)
              SizedBox(
                width: cardWidth,
                child: _buildStatsCard(
                  context,
                  i,
                  isTablet: isTablet,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildStatsCard(
    BuildContext context,
    int index, {
    required bool isTablet,
  }) {
    final item = widget.data[index];

    final label = item['label']?.toString() ?? '';
    final value = item['value']?.toString() ?? '0';

    return StatsCard(
      bottomBorderColor: getBorderColor(index),
      child: SizedBox(
        // Tinggi dibuat konsisten agar 2 card tablet
        // terlihat rapi sejajar.
        height: isTablet ? 120 : 80,
        child: Stack(
          children: [
            // =========================
            // LABEL
            // =========================
            Positioned(
              left: 0,
              top: 0,
              right: 75,
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isTablet ? 22 : 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4A566A),
                  height: 1.2,
                ),
              ),
            ),

            // =========================
            // ICON
            // =========================
            Positioned(
              top: 0,
              right: 0,
              child: _buildIcon(index),
            ),

            // =========================
            // VALUE
            // =========================
            Positioned(
              left: 0,
              bottom: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: isTablet ? 32 : 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF101828),
                      height: 0.9,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'WO',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF98A2B3),
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
