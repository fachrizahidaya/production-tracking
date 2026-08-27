// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CardHeader extends StatelessWidget {
  final data;
  final statusColor;
  final isTablet;
  final filter;
  final getTotalCount;

  const CardHeader(
      {super.key,
      this.data,
      this.statusColor,
      this.isTablet,
      this.filter,
      this.getTotalCount});

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

    final total = _getFilteredTotal(summary);

    final displayTitle = data['name'] == 'Sorting' ? 'Sortir' : data['name'];

    if (!isTablet) {
      return _buildMobileHeader(
        context,
        displayTitle,
        total,
      );
    }

    return _buildTabletHeader(
      context,
      displayTitle,
      total,
    );
  }

  void _navigateToProcess(BuildContext context) {
    final String name = data['name']?.toString() ?? '';

    final String slug = name.toLowerCase().replaceAll(' ', '-');

    final String routeName = slug == 'press'
        ? '/press'
        : slug == 'embroidery'
            ? '/embroideries'
            : '/${slug}s';

    Navigator.pushNamed(context, routeName);
  }

  Widget _buildTabletHeader(
    BuildContext context,
    String displayTitle,
    int total,
  ) {
    return InkWell(
      onTap: () {
        _navigateToProcess(context);
      },
      child: Container(
        padding: CustomTheme().padding('card'),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              statusColor.withOpacity(0.15),
              statusColor.withOpacity(0.05),
            ],
          ),
          border: Border(
            bottom: BorderSide(
              color: statusColor.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: CustomTheme().padding('card'),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getProcessIcon(data['name']),
                size: CustomTheme().iconSize('3xl'),
                color: statusColor,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Text(
                    displayTitle ?? '-',
                    style: TextStyle(
                      fontSize: CustomTheme().fontSize('lg'),
                      fontWeight: CustomTheme().fontWeight('bold'),
                      color: Colors.grey[800],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: CustomTheme().iconSize('xl'),
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
            _buildTotalBadge(
              total,
              statusColor,
              true,
            ),
          ].separatedBy(
            CustomTheme().hGap('xl'),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileHeader(
    BuildContext context,
    String displayTitle,
    int total,
  ) {
    return InkWell(
      onTap: () {
        _navigateToProcess(context);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              statusColor.withOpacity(0.15),
              statusColor.withOpacity(0.05),
            ],
          ),
          border: Border(
            bottom: BorderSide(
              color: statusColor.withOpacity(0.2),
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getProcessIcon(data['name']),
                size: 22,
                color: statusColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          displayTitle ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: CustomTheme().fontWeight('bold'),
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: Colors.grey[500],
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$total Work Order',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
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

  IconData _getProcessIcon(String? name) {
    if (name == null) return Icons.category_outlined;

    final lowerName = name.toLowerCase();
    if (lowerName.contains('dyeing')) {
      return Icons.invert_colors_on_outlined;
    }
    if (lowerName.contains('press')) {
      return Icons.layers_outlined;
    }
    if (lowerName.contains('tumbler')) {
      return Icons.dry_cleaning_outlined;
    }
    if (lowerName.contains('stenter')) {
      return Icons.air_outlined;
    }
    if (lowerName.contains('long slitting')) {
      return Icons.content_paste_outlined;
    }
    if (lowerName.contains('long hemming')) {
      return Icons.cut_outlined;
    }
    if (lowerName.contains('cross cutting')) {
      return Icons.cut_outlined;
    }
    if (lowerName.contains('sewing')) {
      return Icons.link_outlined;
    }
    if (lowerName.contains('embroidery')) {
      return Icons.color_lens_outlined;
    }
    if (lowerName.contains('printing')) {
      return Icons.print_outlined;
    }
    if (lowerName.contains('sorting')) {
      return Icons.sort_outlined;
    }
    if (lowerName.contains('packing')) {
      return Icons.inventory_2_outlined;
    }

    return Icons.settings_outlined;
  }

  Widget _buildTotalBadge(int total, Color color, bool isTablet) {
    return Container(
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: isTablet
                ? CustomTheme().iconSize('lg')
                : CustomTheme().iconSize('md'),
            color: color,
          ),
          Text(
            formatNumber(total),
            style: TextStyle(
              fontSize: CustomTheme().fontSize(isTablet ? 'lg' : 'md'),
              fontWeight: CustomTheme().fontWeight('bold'),
              color: color,
            ),
          ),
        ].separatedBy(CustomTheme().hGap('md')),
      ),
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
