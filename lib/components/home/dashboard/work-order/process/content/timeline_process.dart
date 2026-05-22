import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/process/content/timeline_item.dart';

class TimelineProcess extends StatelessWidget {
  final buildSectionTitle;
  final isTablet;
  final showAllTimeline;
  final getOrderedProcessKeys;
  final processes;
  final collapsedTimelineCount;
  final onExpandChanged;
  final getProcessStatusConfig;
  final getProcessConfig;

  const TimelineProcess(
      {super.key,
      this.buildSectionTitle,
      this.isTablet,
      this.showAllTimeline,
      this.getOrderedProcessKeys,
      this.processes,
      this.collapsedTimelineCount,
      this.onExpandChanged,
      this.getProcessConfig,
      this.getProcessStatusConfig});

  @override
  Widget build(BuildContext context) {
    final processKeys = getOrderedProcessKeys(processes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(
          icon: Icons.timeline_outlined,
          title: 'Alur Proses',
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 16 : 12),
        TimelineItem(
          getProcessConfig: getProcessConfig,
          getProcessStatusConfig: getProcessStatusConfig,
          isTablet: isTablet,
          processes: processes,
          visibleKeys: processKeys,
        ),
      ],
    );
  }
}
