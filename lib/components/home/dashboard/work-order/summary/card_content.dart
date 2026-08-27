// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/pulse_icon.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CardContent extends StatelessWidget {
  final data;
  final filter;
  final showProgress;
  final isTablet;
  final showWorkOrdersByStatusDialog;

  const CardContent(
      {super.key,
      this.showProgress,
      this.showWorkOrdersByStatusDialog,
      this.data,
      this.isTablet,
      this.filter});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> summary =
        (data['summary'] as Map<String, dynamic>?) ??
            {
              'completed': 0,
              'in_progress': 0,
              'waiting': 0,
              'skipped': 0,
            };

    final progress = _getProgress(summary);

    return Padding(
      padding: CustomTheme().padding('card'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showProgress) _buildProgressSection(summary, progress, isTablet),
          _buildStatusGrid(summary, isTablet),
        ].separatedBy(CustomTheme().vGap('lg')),
      ),
    );
  }

  Widget _buildProgressSection(
      Map<String, dynamic> summary, double progress, bool isTablet) {
    final completed = summary['completed'] ?? 0;
    final total = _getTotalCount(summary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progres Penyelesaian',
              style: TextStyle(
                fontSize: CustomTheme().fontSize('md'),
                fontWeight: CustomTheme().fontWeight('semibold'),
                color: Colors.grey[700],
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: CustomTheme().fontSize('md'),
                fontWeight: CustomTheme().fontWeight('bold'),
                color: _getProgressColor(progress),
              ),
            ),
          ],
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final barWidth = constraints.maxWidth * progress.clamp(0.0, 1.0);

            return Stack(
              children: [
                Container(
                  height: isTablet ? 10 : 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  height: isTablet ? 10 : 8,
                  width: barWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getProgressColor(progress),
                        _getProgressColor(progress).withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: _getProgressColor(progress).withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        Text(
          '$completed dari $total selesai',
          style: TextStyle(
            fontSize: CustomTheme().fontSize('md'),
            color: Colors.grey[500],
          ),
        ),
      ].separatedBy(CustomTheme().vGap('md')),
    );
  }

  Widget _buildStatusGrid(
    Map<String, dynamic> summary,
    bool isTablet,
  ) {
    final bool hasOverdueWaiting = data['hasOverdueWaiting'] == true;

    final allItems = [
      _StatusItem(
        label: 'Selesai',
        value: summary['completed'] ?? 0,
        icon: Icons.task_alt_outlined,
        color: const Color(0xffd1fae4),
        iconColor: const Color(0xFF10b981),
      ),
      _StatusItem(
        label: 'Dilewati',
        value: summary['skipped'] ?? 0,
        icon: Icons.fast_forward_outlined,
        color: const Color(0xffe9eefd),
        iconColor: CustomTheme().colors('primary'),
      ),
      _StatusItem(
        label: 'Diproses',
        value: summary['in_progress'] ?? 0,
        icon: Icons.access_time_outlined,
        color: const Color(0xFFfff3c6),
        iconColor: const Color(0xfff18800),
      ),
      _StatusItem(
        label: 'Menunggu Diproses',
        value: summary['waiting'] ?? 0,
        icon: Icons.error_outline,
        color: const Color(0xFFf1f5f9),
        iconColor: const Color.fromRGBO(113, 113, 123, 1),
        showPulse: hasOverdueWaiting,
      ),
    ];

    final filteredItems = allItems.where((item) {
      switch (filter) {
        case 'Selesai':
          return item.label == 'Selesai';
        case 'Dilewati':
          return item.label == 'Dilewati';
        case 'Diproses':
          return item.label == 'Diproses';
        case 'Menunggu Diproses':
          return item.label == 'Menunggu Diproses';
        default:
          return true;
      }
    }).toList();

    if (!isTablet) {
      return _buildMobileStatusGrid(filteredItems);
    }

    return Wrap(
      spacing: 8,
      runSpacing: 16,
      children:
          filteredItems.map((item) => _buildStatusItem(item, true)).toList(),
    );
  }

  Widget _buildMobileStatusGrid(
    List<_StatusItem> items,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;

        final itemWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: 8,
          children: items.map((item) {
            return SizedBox(
              width: itemWidth,
              child: _buildStatusItem(
                item,
                false,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Color _getProgressColor(double progress) {
    return Colors.green;
  }

  Widget _buildStatusItem(
    _StatusItem item,
    bool isTablet,
  ) {
    final woList = _getWOListByStatus(item.label);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        showWorkOrdersByStatusDialog(
          title: item.label,
          woList: woList,
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 10 : 8,
          vertical: isTablet ? 10 : 8,
        ),
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: isTablet ? 22 : 19,
              color: item.iconColor,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          formatNumber(item.value),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 13,
                            fontWeight: CustomTheme().fontWeight('bold'),
                            color: item.iconColor,
                          ),
                        ),
                      ),
                      if (item.showPulse) ...[
                        const SizedBox(width: 4),
                        PulseIcon(
                          icon: Icons.circle,
                          color: Colors.red,
                          size: 10,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isTablet ? 13 : 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (item.value > 0)
              Icon(
                Icons.chevron_right_outlined,
                size: isTablet ? 20 : 17,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }

  List<dynamic> _getWOListByStatus(String label) {
    switch (label) {
      case 'Menunggu Diproses':
        return data['waiting'] as List? ?? [];
      case 'Selesai':
        return data['completed'] as List? ?? [];
      case 'Diproses':
        return data['in_progress'] as List? ?? [];
      case 'Dilewati':
        return data['skipped'] as List? ?? [];
      default:
        return [];
    }
  }

  double _getProgress(Map<String, dynamic> summary) {
    final total = _getTotalCount(summary);
    if (total == 0) return 0.0;

    final completed = summary['completed'] ?? 0;
    return completed / total;
  }

  int _getTotalCount(Map<String, dynamic> summary) {
    return (summary['completed'] ?? 0) +
        (summary['skipped'] ?? 0) +
        (summary['in_progress'] ?? 0) +
        (summary['waiting'] ?? 0);
  }
}

class _StatusItem {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final bool showPulse;

  _StatusItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.iconColor,
    this.showPulse = false,
  });
}
