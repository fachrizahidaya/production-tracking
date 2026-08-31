import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';

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
<<<<<<< HEAD
    final woNo = item['wo_no']?.toString() ?? 'Item';
    final status = item['status']?.toString() ?? '-';
    final columnCount = isTablet ? 3 : 2;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        woNo,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Colors.grey.shade500,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusBadge(status),
            ],
          ),
          const SizedBox(height: 12),
          ..._buildInfoRows(
            [
              MapEntry('Tanggal', _formatDate(item['wo_date'])),
              MapEntry(
                'Proses saat ini',
                _formatCurrentProcess(
                  item['currentProcess'] ?? item['current_process'],
                ),
              ),
              MapEntry(
                'Qty Material',
                '${formatNumber(item['wo_qty'])} ${item['wo_unit'] ?? ''}'
                    .trim(),
              ),
              MapEntry(
                'Qty Greige',
                '${formatNumber(item['greige_qty'])} ${item['greige_unit'] ?? ''}'
                    .trim(),
              ),
            ],
            columnCount,
=======
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
>>>>>>> 83d26bbb (fix: UI mobile dashboard)
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  List<Widget> _buildInfoRows(
    List<MapEntry<String, String>> items,
    int columnCount,
  ) {
    final rows = <Widget>[];

    for (var start = 0; start < items.length; start += columnCount) {
      if (rows.isNotEmpty) {
        rows.add(const SizedBox(height: 12));
      }

      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(columnCount * 2 - 1, (position) {
            if (position.isOdd) {
              return const SizedBox(width: 16);
            }

            final index = start + (position ~/ 2);
            return Expanded(
              child: index < items.length
                  ? _buildInfoItem(items[index].key, items[index].value)
                  : const SizedBox.shrink(),
            );
          }),
        ),
      );
    }

    return rows;
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
=======
  Widget _buildSpkBadge(
    String code,
    bool isTablet,
  ) {
>>>>>>> 83d26bbb (fix: UI mobile dashboard)
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _getStatusColor(status),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
      case 'completed':
        return Colors.green;
      case 'diproses':
      case 'in_progress':
        return Colors.orange;
      case 'menunggu diproses':
      case 'waiting':
        return Colors.blue;
      case 'dilewati':
      case 'skipped':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return '-';

    try {
      final parsedDate = DateTime.parse(date.toString());
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (_) {
      return date.toString();
    }
  }

  String _formatCurrentProcess(dynamic process) {
    final value = process?.toString().trim() ?? '';
    if (value.isEmpty) return '-';
    if (value.toLowerCase() == 'sorting') return 'Sortir';
    return value;
  }
}
