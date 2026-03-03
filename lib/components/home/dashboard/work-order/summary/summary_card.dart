// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/summary/card_content.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/summary/card_dialog.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/summary/card_header.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';

class SummaryCard extends StatefulWidget {
  final dynamic data;
  final VoidCallback? onTap;
  final bool isSelected;
  final showProgress;
  final filter;

  const SummaryCard(
      {super.key,
      required this.data,
      this.onTap,
      this.isSelected = false,
      this.showProgress,
      this.filter});

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _showWorkOrdersByStatusDialog({
    required String title,
    required List<dynamic> woList,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return CardDialog(
          title: title,
          woList: woList,
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 400;

        return GestureDetector(
          onTapDown: (_) => _animationController.forward(),
          onTapUp: (_) => _animationController.reverse(),
          onTapCancel: () => _animationController.reverse(),
          onTap: widget.onTap,
          child: SizedBox(
            width: double.infinity,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: _buildCard(isTablet),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(bool isTablet) {
    final Map<String, dynamic> summary =
        (widget.data['summary'] as Map<String, dynamic>?) ??
            {
              'completed': 0,
              'in_progress': 0,
              'waiting': 0,
              'skipped': 0,
            };

    final statusColor = _getSummaryColor(summary);

    return AnimatedContainer(
      width: double.infinity,
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.isSelected
              ? CustomTheme().buttonColor('primary')
              : Colors.grey[200]!,
          width: widget.isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isSelected
                ? CustomTheme().buttonColor('primary').withOpacity(0.15)
                : Colors.black.withOpacity(0.05),
            blurRadius: widget.isSelected ? 12 : 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CardHeader(
              data: widget.data,
              isTablet: isTablet,
              statusColor: statusColor,
              filter: widget.filter,
              getTotalCount: _getTotalCount,
            ),
            CardContent(
              data: widget.data,
              filter: widget.filter,
              isTablet: isTablet,
              showProgress: widget.showProgress,
              showWorkOrdersByStatusDialog: _showWorkOrdersByStatusDialog,
            ),
          ],
        ),
      ),
    );
  }

  Color _getSummaryColor(Map<String, dynamic> summary) {
    final completed = summary['completed'] ?? 0;
    final skipped = summary['skipped'] ?? 0;
    final inProgress = summary['in_progress'] ?? 0;
    final waiting = summary['waiting'] ?? 0;

    if (inProgress > 0) {
      return CustomTheme().colors('Diproses');
    }

    if (skipped > 0) {
      return CustomTheme().colors('primary');
    }
    if (waiting > 0) {
      return CustomTheme().colors('secondary');
    }

    if (completed > 0) {
      return CustomTheme().colors('Selesai');
    }

    return Colors.grey;
  }

  int _getTotalCount(Map<String, dynamic> summary) {
    return (summary['completed'] ?? 0) +
        (summary['skipped'] ?? 0) +
        (summary['in_progress'] ?? 0) +
        (summary['waiting'] ?? 0);
  }
}

class SummaryCardGrid extends StatelessWidget {
  final List<dynamic> items;
  final Function(dynamic)? onItemTap;
  final int? selectedIndex;

  const SummaryCardGrid({
    super.key,
    required this.items,
    this.onItemTap,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final crossAxisCount = isTablet ? 2 : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: isTablet ? 16 : 12,
            mainAxisSpacing: isTablet ? 16 : 12,
            childAspectRatio: isTablet ? 1.6 : 1.4,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return SummaryCard(
              data: items[index],
              isSelected: selectedIndex == index,
              onTap: () => onItemTap?.call(items[index]),
            );
          },
        );
      },
    );
  }
}

class CompactSummaryCard extends StatelessWidget {
  final dynamic data;
  final VoidCallback? onTap;

  const CompactSummaryCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 400;
        final Map<String, dynamic> summary =
            (data['summary'] as Map<String, dynamic>?) ??
                {
                  'completed': 0,
                  'in_progress': 0,
                  'waiting': 0,
                  'skipped': 0,
                };

        return GestureDetector(
          onTap: onTap,
          child: Container(
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
                Container(),
                SizedBox(width: isTablet ? 14 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data['name'] ?? '-',
                        style: TextStyle(
                          fontSize: isTablet ? 15 : 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      _buildCompactStatus(summary, isTablet),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: isTablet ? 24 : 22,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactStatus(Map<String, dynamic> summary, bool isTablet) {
    final completed = summary['completed'] ?? 0;
    final inProgress = summary['in_progress'] ?? 0;
    final waiting = summary['waiting'] ?? 0;

    return Row(
      children: [
        _buildMiniStatusBadge(
          value: completed,
          color: Colors.green,
          isTablet: isTablet,
        ),
        const SizedBox(width: 8),
        _buildMiniStatusBadge(
          value: inProgress,
          color: Colors.blue,
          isTablet: isTablet,
        ),
        const SizedBox(width: 8),
        _buildMiniStatusBadge(
          value: waiting,
          color: Colors.orange,
          isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildMiniStatusBadge({
    required int value,
    required Color color,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 8 : 6,
        vertical: isTablet ? 4 : 3,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        formatNumber(value),
        style: TextStyle(
          fontSize: isTablet ? 12 : 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
