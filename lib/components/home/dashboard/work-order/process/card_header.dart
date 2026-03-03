import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class CardHeader extends StatelessWidget {
  final item;
  final isTablet;
  const CardHeader({super.key, this.item, this.isTablet});

  @override
  Widget build(BuildContext context) {
    final itemName = item['wo_no']?.toString() ?? 'Item';
    final itemCode = item['spk_no']?.toString() ?? '-';
    final overallStatus = _getOverallStatus();
    final statusConfig = _getStatusConfig(overallStatus);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkOrderDetail(
              id: item['id'].toString(),
            ),
          ),
        );
      },
      child: Container(
        padding: CustomTheme().padding('card'),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              statusConfig['color'].withOpacity(0.1),
              statusConfig['color'].withOpacity(0.03),
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          border: Border(
            bottom: BorderSide(
              color: statusConfig['color'].withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Info + Chevron
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // WO + Chevron
                  Row(
                    children: [
                      Text(
                        itemName,
                        style: TextStyle(
                          fontSize: CustomTheme().fontSize('xl'),
                          fontWeight: CustomTheme().fontWeight('bold'),
                          color: Colors.grey[800],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: isTablet
                            ? CustomTheme().iconSize('2xl')
                            : CustomTheme().iconSize('xl'),
                        color: Colors.grey[500],
                      ),
                    ].separatedBy(CustomTheme().hGap('xs')),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SPK + Date
                      Row(
                        children: [
                          _buildSpkBadge(itemCode, isTablet),
                          if (item['wo_date'] != null)
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: CustomTheme().iconSize('md'),
                                  color: Colors.grey[500],
                                ),
                                Text(
                                  DateFormat("dd MMM yyyy")
                                      .format(DateTime.parse(item['wo_date'])),
                                  style: TextStyle(
                                    fontSize: CustomTheme().fontSize('lg'),
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ].separatedBy(CustomTheme().hGap('sm')),
                            )
                        ].separatedBy(CustomTheme().hGap('lg')),
                      ),

                      // Qty Material + Qty Greige
                      Row(
                        children: [
                          _buildQtyInfo(
                            label: 'Qty Material',
                            value: item['wo_qty'],
                            isTablet: isTablet,
                            unit: item['wo_unit'],
                          ),
                          _buildQtyInfo(
                            label: 'Qty Greige',
                            value: item['greige_qty'],
                            isTablet: isTablet,
                            unit: item['greige_unit'],
                          ),
                        ].separatedBy(CustomTheme().hGap('md')),
                      ),
                    ].separatedBy(CustomTheme().vGap('lg')),
                  ),
                ].separatedBy(CustomTheme().vGap('sm')),
              ),
            ),

            // Overall Status Badge
            CustomBadge(
              withStatus: true,
              title: item['status'],
              status: item['status'],
            ),
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
      ),
    );
  }

  String _getOverallStatus() {
    final processes = item['processes'] as Map<String, dynamic>? ?? {};
    if (processes.isEmpty) return 'Menunggu Diproses';

    final statuses = processes.values
        .map((p) => (p['status']?.toString().toLowerCase() ?? 'waiting'))
        .toList();

    if (statuses.every((s) => s == 'completed' || s == 'Selesai')) {
      return 'Selesai';
    }
    if (statuses.any((s) => s == 'in_progress' || s == 'Diproses')) {
      return 'Diproses';
    }

    return 'Menunggu Diproses';
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'Selesai':
        return {
          'label': 'Selesai',
          'color': CustomTheme().colors('Selesai'),
          'icon': Icons.task_alt_outlined,
        };
      case 'in_progress':
      case 'Diproses':
        return {
          'label': 'Diproses',
          'color': CustomTheme().colors('Diproses'),
          'icon': Icons.access_time_outlined,
        };
      case 'skipped':
      case 'Dilewati':
        return {
          'label': 'Dilewati',
          'color': CustomTheme().colors('primary'),
          'icon': Icons.fast_forward_outlined,
        };

      default:
        return {
          'label': 'Menunggu Diproses',
          'color': CustomTheme().colors('secondary'),
          'icon': Icons.error_outline,
        };
    }
  }

  Widget _buildQtyInfo({
    required String label,
    required dynamic value,
    required bool isTablet,
    unit,
  }) {
    return Container(
      padding: CustomTheme().padding('badge-rework'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: isTablet
                  ? CustomTheme().fontSize('lg')
                  : CustomTheme().fontSize('md'),
              color: Colors.grey[500],
            ),
          ),
          SizedBox(width: 4),
          Text(
            '${value?.toString() ?? '-'} ${unit ?? ''}',
            style: TextStyle(
              fontSize: isTablet
                  ? CustomTheme().fontSize('lg')
                  : CustomTheme().fontSize('md'),
              fontWeight: CustomTheme().fontWeight('semibold'),
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpkBadge(String code, bool isTablet) {
    return Container(
      padding: CustomTheme().padding('badge-rework'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        code,
        style: TextStyle(
          fontSize: CustomTheme().fontSize('lg'),
          fontWeight: CustomTheme().fontWeight('semibold'),
          color: Colors.grey[700],
        ),
      ),
    );
  }
}
