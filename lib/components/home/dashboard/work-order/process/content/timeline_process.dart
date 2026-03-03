import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/process/content/timeline_item.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

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

    final visibleKeys = showAllTimeline
        ? processKeys
        : processKeys.take(collapsedTimelineCount).toList();

    final hasMore = processKeys.length > collapsedTimelineCount;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        visibleKeys: visibleKeys,
      ),
      if (hasMore)
        ...[
          SizedBox(height: isTablet ? 16 : 12),
          Center(
            child: InkWell(
              onTap: () {
                final next = !showAllTimeline;
                onExpandChanged?.call(next);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    showAllTimeline ? Icons.expand_less : Icons.expand_more,
                    size: isTablet ? 20 : 18,
                    color: CustomTheme().buttonColor('primary'),
                  ),
                  Text(
                    showAllTimeline
                        ? 'Sembunyikan Proses'
                        : 'Lihat Semua Proses',
                    style: TextStyle(
                      fontSize: CustomTheme().fontSize('sm'),
                      fontWeight: CustomTheme().fontWeight('semibold'),
                      color: CustomTheme().buttonColor('primary'),
                    ),
                  ),
                ].separatedBy(CustomTheme().hGap('sm')),
              ),
            ),
          ),
        ].separatedBy(CustomTheme().vGap('xl')),
    ]);
  }
}
