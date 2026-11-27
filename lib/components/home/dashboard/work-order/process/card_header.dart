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
          ),
        ],
      ),
    );
  }

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
