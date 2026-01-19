// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

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
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  int _getFilteredTotal(Map<String, dynamic> summary) {
    switch (widget.filter) {
      case 'Selesai':
        return summary['completed'] ?? 0;
      case 'Diproses':
        return summary['in_progress'] ?? 0;
      case 'Menunggu Diproses':
        return summary['waiting'] ?? 0;
      default:
        return _getTotalCount(summary); // Semua
    }
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
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: _buildCard(isTablet),
          ),
        );
      },
    );
  }

  Widget _buildCard(bool isTablet) {
    final summary = widget.data['summary'] ?? {};
    final statusColor = _getSummaryColor(summary);
    final progress = _getProgress(summary);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Section
            _buildHeader(statusColor, isTablet),

            // Content Section
            Padding(
              padding: CustomTheme().padding('card'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Section
                  if (widget.showProgress)
                    _buildProgressSection(summary, progress, isTablet),

                  // Status Grid
                  _buildStatusGrid(summary, isTablet),
                ].separatedBy(CustomTheme().vGap('lg')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header Section dengan nama dan total
  Widget _buildHeader(Color statusColor, bool isTablet) {
    final summary = widget.data['summary'] ?? {};
    final total = _getFilteredTotal(summary);

    return Container(
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
          // Icon Container
          Container(
            padding: CustomTheme().padding('card'),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getProcessIcon(widget.data['name']),
              size: isTablet ? 28 : 24,
              color: statusColor,
            ),
          ),

          // Name and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data['name'] ?? '-',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize(isTablet ? 'lg' : 'md'),
                    fontWeight: CustomTheme().fontWeight('bold'),
                    color: Colors.grey[800],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ].separatedBy(CustomTheme().vGap('sm')),
            ),
          ),

          // Total Badge
          _buildTotalBadge(total, statusColor, isTablet),
        ].separatedBy(CustomTheme().hGap('xl')),
      ),
    );
  }

  /// Total Badge
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
            size: isTablet ? 16 : 14,
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

  /// Progress Section
  Widget _buildProgressSection(
      Map<String, dynamic> summary, double progress, bool isTablet) {
    final completed = summary['completed'] ?? 0;
    final total = _getTotalCount(summary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress Penyelesaian',
              style: TextStyle(
                fontSize: CustomTheme().fontSize('sm'),
                fontWeight: CustomTheme().fontWeight('semibold'),
                color: Colors.grey[700],
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: CustomTheme().fontSize('md'),
                fontWeight: CustomTheme().fontWeight('bold'),
                color: _getProgressColor(progress),
              ),
            ),
          ],
        ),
        // Progress Bar
        Stack(
          children: [
            Container(
              height: isTablet ? 10 : 8,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              height: isTablet ? 10 : 8,
              width: (MediaQuery.of(context).size.width - 100) * progress,
              constraints: BoxConstraints(
                maxWidth: double.infinity,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getProgressColor(progress),
                    _getProgressColor(progress).withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: _getProgressColor(progress).withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
        Text(
          '$completed dari $total selesai',
          style: TextStyle(
            fontSize: CustomTheme().fontSize('sm'),
            color: Colors.grey[500],
          ),
        ),
      ].separatedBy(CustomTheme().vGap('md')),
    );
  }

  /// Status Grid
  Widget _buildStatusGrid(Map<String, dynamic> summary, bool isTablet) {
    final allItems = [
      _StatusItem(
        label: 'Selesai',
        value: summary['completed'] ?? 0,
        icon: Icons.task_alt_outlined,
        color: const Color(0xffd1fae4),
        iconColor: const Color(0xFF10b981),
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
      ),
    ];

    // 👇 FILTER BASED ON ACTIVE TAB
    final filteredItems = allItems.where((item) {
      switch (widget.filter) {
        case 'Selesai':
          return item.label == 'Selesai';
        case 'Diproses':
          return item.label == 'Diproses';
        case 'Menunggu Diproses':
          return item.label == 'Menunggu Diproses';
        default:
          return true; // Semua
      }
    }).toList();

    return Row(
      children: filteredItems
          .map((item) => _buildStatusItem(item, isTablet))
          .toList()
          .separatedBy(SizedBox(width: isTablet ? 12 : 8)),
    );
  }

  /// Status Item Widget
  Widget _buildStatusItem(_StatusItem item, bool isTablet) {
    return Container(
      padding: CustomTheme().padding('badge'),
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            size: isTablet ? 18 : 16,
            color: item.iconColor,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatNumber(item.value),
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('md'),
                  fontWeight: CustomTheme().fontWeight('bold'),
                  color: item.iconColor,
                ),
              ),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('xs'),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ].separatedBy(CustomTheme().hGap('lg')),
      ),
    );
  }

  /// Get Summary Color based on status
  Color _getSummaryColor(Map<String, dynamic> summary) {
    final completed = summary['completed'] ?? 0;
    final inProgress = summary['in_progress'] ?? 0;
    final waiting = summary['waiting'] ?? 0;

    if (inProgress > 0) {
      return Color(0xfff18800);
    }

    if (waiting > 0) {
      return Color.fromRGBO(113, 113, 123, 1);
    }

    if (completed > 0) {
      return Color(0xFF10b981);
    }

    return Colors.grey;
  }

  /// Get Total Count
  int _getTotalCount(Map<String, dynamic> summary) {
    return (summary['completed'] ?? 0) +
        (summary['in_progress'] ?? 0) +
        (summary['waiting'] ?? 0) +
        (summary['rework'] ?? 0);
  }

  /// Get Progress (0.0 - 1.0)
  double _getProgress(Map<String, dynamic> summary) {
    final total = _getTotalCount(summary);
    if (total == 0) return 0.0;

    final completed = summary['completed'] ?? 0;
    return completed / total;
  }

  /// Get Progress Color
  Color _getProgressColor(double progress) {
    return Colors.green;
  }

  /// Get Process Icon
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
    if (lowerName.contains('long sitting')) {
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

  /// Get Process Subtitle
}

/// Status Item Model
class _StatusItem {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final Color iconColor;

  _StatusItem(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color,
      required this.iconColor});
}

/// Grid Summary Card untuk dashboard
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
          physics: const NeverScrollableScrollPhysics(),
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

/// Compact Summary Card untuk list view
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
        final summary = data['summary'] ?? {};
        final statusColor = _getSummaryColor(summary);

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
                // Left: Icon + Name
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getProcessIcon(data['name']),
                    size: isTablet ? 24 : 20,
                    color: statusColor,
                  ),
                ),
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
                // Right: Arrow
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

  Color _getSummaryColor(Map<String, dynamic> summary) {
    final inProgress = summary['in_progress'] ?? 0;
    final waiting = summary['waiting'] ?? 0;
    final completed = summary['completed'] ?? 0;

    if (inProgress > 0) return Colors.blue;
    if (waiting > 0) return Colors.orange;
    if (completed > 0) return Colors.green;
    return Colors.grey;
  }

  IconData _getProcessIcon(String? name) {
    if (name == null) return Icons.category_outlined;

    final lowerName = name.toLowerCase();
    if (lowerName.contains('dyeing')) return Icons.invert_colors_on_outlined;
    if (lowerName.contains('press')) return Icons.layers_outlined;
    if (lowerName.contains('tumbler')) return Icons.dry_cleaning_outlined;
    if (lowerName.contains('stenter')) return Icons.air;
    if (lowerName.contains('long sitting')) return Icons.content_paste_outlined;
    if (lowerName.contains('long hemming')) return Icons.cut_outlined;
    if (lowerName.contains('cross cutting')) return Icons.cut_outlined;
    if (lowerName.contains('sewing')) return Icons.link_outlined;
    if (lowerName.contains('embroidery')) return Icons.color_lens_outlined;
    if (lowerName.contains('printing')) return Icons.print_outlined;
    if (lowerName.contains('sorting')) return Icons.sort_outlined;
    if (lowerName.contains('packing')) return Icons.inventory_2_outlined;

    return Icons.settings_outlined;
  }
}
