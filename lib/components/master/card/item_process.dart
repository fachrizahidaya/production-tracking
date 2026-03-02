// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/process/content/card_content.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/process/card_header.dart';

class ItemProcess extends StatefulWidget {
  final dynamic item;
  final VoidCallback? onTap;
  final bool showTimeline;
  final ValueChanged<bool>? onExpandChanged;
  final bool isExpanded;

  const ItemProcess(
      {super.key,
      required this.item,
      this.onTap,
      this.showTimeline = true,
      this.onExpandChanged,
      this.isExpanded = false});

  @override
  State<ItemProcess> createState() => _ItemProcessState();
}

class _ItemProcessState extends State<ItemProcess> {
  bool _showAllTimeline = false;
  static const int _collapsedTimelineCount = 3;

  @override
  void initState() {
    super.initState();
    _showAllTimeline = widget.isExpanded;
  }

  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  void didUpdateWidget(covariant ItemProcess oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isExpanded != widget.isExpanded) {
      _showAllTimeline = widget.isExpanded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                CardHeader(
                  item: widget.item,
                  isTablet: isTablet,
                ),

                // Process Timeline / Grid
                CardContent(
                  item: widget.item,
                  isTablet: isTablet,
                  showAllTimeline: _showAllTimeline,
                  showTimeline: widget.showTimeline,
                  onExpandChanged: widget.onExpandChanged,
                  collapsedTimelineCount: _collapsedTimelineCount,
                ),
              ],
            ),
          );
        },
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
                // Item Info
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
                      // Process Status Dots
                      Row(
                        children: _buildProcessDots(processes, isTablet),
                      ),
                    ],
                  ),
                ),

                // Arrow
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
        margin: EdgeInsets.only(right: 6),
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
