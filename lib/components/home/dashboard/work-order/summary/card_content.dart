// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';

class CardContent extends StatelessWidget {
  final data;
  final filter;
  final showProgress;
  final isTablet;

  const CardContent({
    super.key,
    this.showProgress,
    this.data,
    this.isTablet,
    this.filter,
  });

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

    final items = _filteredItems(summary);
    final progress = _getProgress(summary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showProgress == true) ...[
          _buildProgressSection(summary, progress),
          const SizedBox(height: 10),
        ],
        for (int row = 0; row < items.length; row += 2) ...[
          if (row > 0) const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildInfo(items[row].label, items[row].value)),
              const SizedBox(width: 12),
              Expanded(
                child: row + 1 < items.length
                    ? _buildInfo(items[row + 1].label, items[row + 1].value)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildProgressSection(Map<String, dynamic> summary, double progress) {
    final completed = summary['completed'] ?? 0;
    final total = _getTotalCount(summary);
    final barHeight = isTablet == true ? 8.0 : 6.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progres Penyelesaian',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
                height: 1.2,
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.green,
                height: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LayoutBuilder(
          builder: (context, constraints) {
            final barWidth = constraints.maxWidth * progress.clamp(0.0, 1.0);

            return Stack(
              children: [
                Container(
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  height: barHeight,
                  width: barWidth,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 4),
        Text(
          '$completed dari $total selesai',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
            height: 1.2,
          ),
        ),
      ],
    );
  }

<<<<<<< HEAD
  List<_StatusItem> _filteredItems(Map<String, dynamic> summary) {
=======
  Widget _buildStatusGrid(
    Map<String, dynamic> summary,
    bool isTablet,
  ) {
    final bool hasOverdueWaiting = data['hasOverdueWaiting'] == true;

>>>>>>> d86a31e7 (fix: UI mobile dashboard)
    final allItems = [
      _StatusItem(label: 'Selesai', value: summary['completed'] ?? 0),
      _StatusItem(label: 'Dilewati', value: summary['skipped'] ?? 0),
      _StatusItem(label: 'Diproses', value: summary['in_progress'] ?? 0),
      _StatusItem(
<<<<<<< HEAD
        label: 'Menunggu',
        value: summary['waiting'] ?? 0,
=======
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
>>>>>>> d86a31e7 (fix: UI mobile dashboard)
      ),
    ];

    return allItems.where((item) {
      switch (filter) {
        case 'Selesai':
          return item.label == 'Selesai';
        case 'Dilewati':
          return item.label == 'Dilewati';
        case 'Diproses':
          return item.label == 'Diproses';
        case 'Menunggu Diproses':
          return item.label == 'Menunggu';
        default:
          return true;
      }
    }).toList();
<<<<<<< HEAD
  }

  Widget _buildInfo(String label, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          formatNumber(value),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
=======

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
>>>>>>> d86a31e7 (fix: UI mobile dashboard)
        ),
      ],
    );
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

  _StatusItem({
    required this.label,
    required this.value,
  });
}
