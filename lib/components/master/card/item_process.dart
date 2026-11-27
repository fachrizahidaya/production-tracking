// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/process/content/card_content.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/process/card_header.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class ItemProcess extends StatelessWidget {
  final dynamic item;
  final VoidCallback? onTap;
  final bool showTimeline;
  final bool isMobile;

  const ItemProcess({
    super.key,
    required this.item,
    this.onTap,
    this.showTimeline = true,
    this.isMobile = true,
  });

  void _navigateToDetail(BuildContext context) {
    final id = item['id']?.toString();
    if (id == null || id.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkOrderDetail(id: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = !isMobile;

    return GestureDetector(
      onTap: onTap ?? () => _navigateToDetail(context),
      child: Container(
        width: double.infinity,
        decoration: CustomTheme().cardTheme(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CardHeader(
              item: item,
              isTablet: isTablet,
            ),
            CardContent(
              item: item,
              isTablet: isTablet,
              showTimeline: showTimeline,
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact Item Process Card
class CompactItemProcess extends StatelessWidget {
  final dynamic item;
  final VoidCallback? onTap;

  const CompactItemProcess({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 400;
        final processes = item['processes'] as Map<String, dynamic>? ?? {};

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(bottom: isTablet ? 12 : 8),
            padding: EdgeInsets.all(isTablet ? 16 : 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name']?.toString() ?? 'Item',
                        style: TextStyle(
                          fontSize: isTablet ? 15 : 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: _buildProcessDots(processes, isTablet),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: isTablet ? 24 : 20,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildProcessDots(
      Map<String, dynamic> processes, bool isTablet) {
    return processes.entries.take(5).map((entry) {
      final status =
          entry.value['status']?.toString().toLowerCase() ?? 'pending';
      final color = _getStatusColor(status);

      return Container(
        margin: const EdgeInsets.only(right: 6),
        child: Tooltip(
          message:
              '${_capitalizeFirst(entry.key)}: ${_capitalizeFirst(status)}',
          child: Container(
            width: isTablet ? 12 : 10,
            height: isTablet ? 12 : 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'selesai':
        return Colors.green;
      case 'in_progress':
      case 'proses':
        return Colors.blue;
      case 'rework':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
