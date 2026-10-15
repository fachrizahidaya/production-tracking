// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';

class CardHeader extends StatelessWidget {
  final data;
  final statusColor;
  final isTablet;
  final filter;
  final getTotalCount;

  const CardHeader({
    super.key,
    this.data,
    this.statusColor,
    this.isTablet,
    this.filter,
    this.getTotalCount,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final Map<String, dynamic> summary =
        (data['summary'] as Map<String, dynamic>?) ??
            {
              'completed': 0,
              'in_progress': 0,
              'waiting': 0,
              'skipped': 0,
            };

    final total = _getFilteredTotal(summary);
    final displayTitle = data['name'] == 'Sorting' ? 'Sortir' : data['name'];

    return Row(
      children: [
        Expanded(
          child: Text(
            displayTitle ?? '-',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (!isMobile) ...[
          Text(
            formatNumber(total),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 4),
        ],
        Icon(
          Icons.chevron_right,
          size: 20,
          color: Colors.grey.shade500,
        ),
      ],
    );
  }

  int _getFilteredTotal(Map<String, dynamic> summary) {
    switch (filter) {
      case 'Selesai':
        return summary['completed'] ?? 0;
      case 'Dilewati':
        return summary['skipped'] ?? 0;
      case 'Diproses':
        return summary['in_progress'] ?? 0;
      case 'Menunggu Diproses':
        return summary['waiting'] ?? 0;
      default:
        return getTotalCount(summary);
    }
  }
}
