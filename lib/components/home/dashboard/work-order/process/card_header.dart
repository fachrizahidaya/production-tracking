import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class CardHeader extends StatelessWidget {
  final dynamic item;
  final bool isTablet;

  const CardHeader({
    super.key,
    this.item,
    this.isTablet = false,
  });

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
        width: double.infinity,
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
          borderRadius: const BorderRadius.only(
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // =========================================================
                // HEADER
                // =========================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // WO NUMBER
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  itemName,
                                  style: TextStyle(
                                    fontSize: CustomTheme().fontSize('xl'),
                                    fontWeight:
                                        CustomTheme().fontWeight('bold'),
                                    color: Colors.grey[800],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: isTablet
                                    ? CustomTheme().iconSize('2xl')
                                    : CustomTheme().iconSize('xl'),
                                color: Colors.grey[500],
                              ),
                            ].separatedBy(
                              CustomTheme().hGap('xs'),
                            ),
                          ),

                          SizedBox(
                            height: 4,
                          ),

                          // SPK + DATE
                          Wrap(
                            spacing: 12,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              _buildSpkBadge(
                                itemCode,
                                isTablet,
                              ),
                              if (item['wo_date'] != null)
                                _buildDate(
                                  item['wo_date'],
                                  isTablet,
                                ),
                            ],
                          ),

                          SizedBox(
                            height: 12,
                          ),

                          // QTY
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _buildQtyInfo(
                                label: 'Qty Material',
                                value: formatNumber(
                                  item['wo_qty'],
                                ),
                                isTablet: isTablet,
                                unit: item['wo_unit'],
                              ),
                              _buildQtyInfo(
                                label: 'Qty Greige',
                                value: formatNumber(
                                  item['greige_qty'],
                                ),
                                isTablet: isTablet,
                                unit: item['greige_unit'],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // =====================================================
                    // STATUS
                    // =====================================================
                    if (!isMobile) ...[
                      SizedBox(
                        width: 16,
                      ),
                      Flexible(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CustomBadge(
                            withStatus: true,
                            title: item['status']?.toString() ?? '-',
                            status: item['status']?.toString() ?? '-',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // =========================================================
                // MOBILE STATUS
                // =========================================================
                if (isMobile) ...[
                  SizedBox(
                    height: 12,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomBadge(
                      withStatus: true,
                      title: item['status']?.toString() ?? '-',
                      status: item['status']?.toString() ?? '-',
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDate(
    dynamic date,
    bool isTablet,
  ) {
    DateTime? parsedDate;

    try {
      parsedDate = DateTime.parse(
        date.toString(),
      );
    } catch (_) {
      parsedDate = null;
    }

    if (parsedDate == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.calendar_month_outlined,
          size: CustomTheme().iconSize('md'),
          color: Colors.grey[500],
        ),
        Flexible(
          child: Text(
            DateFormat("dd MMM yyyy").format(parsedDate),
            style: TextStyle(
              fontSize: CustomTheme().fontSize('lg'),
              color: Colors.grey[600],
            ),
          ),
        ),
      ].separatedBy(
        CustomTheme().hGap('sm'),
      ),
    );
  }

  String _getOverallStatus() {
    final processes = item['processes'] as Map<String, dynamic>? ?? {};

    if (processes.isEmpty) {
      return 'Menunggu Diproses';
    }

    final List<String> statuses = [];

    for (final process in processes.values) {
      if (process is List) {
        for (final p in process) {
          if (p is Map) {
            statuses.add(
              p['status']?.toString().toLowerCase() ?? 'menunggu diproses',
            );
          }
        }
      } else if (process is Map) {
        statuses.add(
          process['status']?.toString().toLowerCase() ?? 'menunggu diproses',
        );
      }
    }

    if (statuses.isEmpty) {
      return 'Menunggu Diproses';
    }

    if (statuses.every(
      (s) => s == 'selesai' || s == 'completed',
    )) {
      return 'Selesai';
    }

    if (statuses.any(
      (s) => s == 'diproses' || s == 'in_progress' || s == 'processing',
    )) {
      return 'Diproses';
    }

    return 'Menunggu Diproses';
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'selesai':
        return {
          'label': 'Selesai',
          'color': CustomTheme().colors('Selesai'),
          'icon': Icons.task_alt_outlined,
        };

      case 'in_progress':
      case 'diproses':
      case 'processing':
        return {
          'label': 'Diproses',
          'color': CustomTheme().colors('Diproses'),
          'icon': Icons.access_time_outlined,
        };

      case 'skipped':
      case 'dilewati':
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
    dynamic unit,
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
          const SizedBox(width: 4),
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

  Widget _buildSpkBadge(
    String code,
    bool isTablet,
  ) {
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
