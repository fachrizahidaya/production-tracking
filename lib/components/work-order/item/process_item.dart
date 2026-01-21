// ignore_for_file: deprecated_member_use, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ProcessItem extends StatefulWidget {
  final dynamic item;
  final VoidCallback? onTap;
  final bool isExpanded;
  final bool showDetails;

  const ProcessItem({
    super.key,
    required this.item,
    this.onTap,
    this.isExpanded = false,
    this.showDetails = true,
  });

  @override
  State<ProcessItem> createState() => _ProcessItemState();
}

class _ProcessItemState extends State<ProcessItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final data = widget.item['data'] ?? [];
        final hasData = data.isNotEmpty;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasData)
                    // Header Section
                    _buildHeader(hasData, data, isTablet)
                  else
                    Container(
                      padding: CustomTheme().padding('card'),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.orange.withOpacity(0.08),
                            Colors.orange.withOpacity(0.02),
                          ],
                        ),
                        border: hasData && widget.showDetails
                            ? Border(
                                bottom: BorderSide(
                                  color: Colors.grey[200]!,
                                  width: 1,
                                ),
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          // Process Icon
                          Container(
                            padding: CustomTheme().padding('process-content'),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getProcessIcon(widget.item['label']),
                              size: isTablet ? 24 : 20,
                              color: Colors.orange,
                            ),
                          ),

                          // Process Label & Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.item['label']?.toString() ?? '-',
                                  style: TextStyle(
                                    fontSize: CustomTheme()
                                        .fontSize(isTablet ? 'lg' : 'md'),
                                    fontWeight:
                                        CustomTheme().fontWeight('bold'),
                                    color: Colors.grey[800],
                                  ),
                                ),
                                Row(
                                  children: [
                                    // Status Indicator
                                    Container(
                                      width: isTablet ? 8 : 6,
                                      height: isTablet ? 8 : 6,
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.orange.withOpacity(0.5),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      // statusConfig['label'],
                                      'Menunggu Diproses',
                                      style: TextStyle(
                                        fontSize: CustomTheme().fontSize('sm'),
                                        // color: statusConfig['color'],
                                        fontWeight:
                                            CustomTheme().fontWeight('bold'),
                                      ),
                                    ),
                                    // Additional Info
                                  ].separatedBy(CustomTheme().hGap('md')),
                                ),
                              ].separatedBy(CustomTheme().vGap('xs')),
                            ),
                          ),

                          // Expand/Action Button
                        ].separatedBy(CustomTheme().hGap('xl')),
                      ),
                    ),

                  // Expandable Details
                  if (hasData)
                    _buildExpandableDetails(true, data.first, isTablet)
                  else
                    NoData(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Header Section
  Widget _buildHeader(bool hasData, List<dynamic> data, bool isTablet) {
    final bool hasProcessData = data.isNotEmpty;

    final String status = !hasProcessData
        ? 'Menunggu Diproses'
        : (data.first['status']?.toString() ?? 'Menunggu Diproses');

    final statusConfig = _getStatusConfig(status);

    return Container(
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            statusConfig['color'].withOpacity(0.08),
            statusConfig['color'].withOpacity(0.02),
          ],
        ),
        border: hasData && widget.showDetails
            ? Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          // Process Icon
          Container(
            padding: CustomTheme().padding('process-content'),
            decoration: BoxDecoration(
              color: statusConfig['color'].withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getProcessIcon(widget.item['label']),
              size: isTablet ? 24 : 20,
              color: statusConfig['color'],
            ),
          ),

          // Process Label & Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item['label']?.toString() ?? '-',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize(isTablet ? 'lg' : 'md'),
                    fontWeight: CustomTheme().fontWeight('bold'),
                    color: Colors.grey[800],
                  ),
                ),
                Row(
                  children: [
                    // Status Indicator
                    Container(
                      width: isTablet ? 8 : 6,
                      height: isTablet ? 8 : 6,
                      decoration: BoxDecoration(
                        color: statusConfig['color'],
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: statusConfig['color'].withOpacity(0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      statusConfig['label'],
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('sm'),
                        color: statusConfig['color'],
                        fontWeight: CustomTheme().fontWeight('bold'),
                      ),
                    ),
                    // Additional Info
                  ].separatedBy(CustomTheme().hGap('md')),
                ),
              ].separatedBy(CustomTheme().vGap('xs')),
            ),
          ),

          // Expand/Action Button
        ].separatedBy(CustomTheme().hGap('xl')),
      ),
    );
  }

  /// Expandable Details Section
  Widget _buildExpandableDetails(hasData, data, bool isTablet) {
    return Container(
      padding: CustomTheme().padding('content'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Section
          if (data['start_time'] != null || data['end_time'] != null) ...[
            _buildTimeSection(data, isTablet),
          ],

          // Quantity & Weight
          _buildQuantitySection(data, isTablet),

          // Grades
          if (data['grades'] != null &&
              (data['grades'] as List).isNotEmpty) ...[
            _buildSectionTitle(
              icon: Icons.grade_outlined,
              title: 'Grades',
              isTablet: isTablet,
            ),
            _buildGradesSection(data['grades'], isTablet),
          ],
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

  /// Section Title Widget
  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required bool isTablet,
  }) {
    return Row(
      children: [
        Container(
          padding: CustomTheme().padding('badge'),
          decoration: BoxDecoration(
            color: CustomTheme().buttonColor('primary').withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: isTablet ? 16 : 14,
            color: CustomTheme().buttonColor('primary'),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('md'),
            fontWeight: CustomTheme().fontWeight('semibold'),
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
        ),
      ].separatedBy(CustomTheme().hGap('lg')),
    );
  }

  /// Time Section
  Widget _buildTimeSection(Map<String, dynamic> data, bool isTablet) {
    final isNarrow = !isTablet;

    return Container(
      padding: CustomTheme().padding('process-content'),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data['start_time'] != null)
                  _buildTimeItem(
                    icon: Icons.play_circle_outline,
                    label: 'Waktu Mulai',
                    value: _formatTime(data['start_time']),
                    color: Colors.green,
                    isTablet: isTablet,
                  ),
                if (data['start_time'] != null && data['end_time'] != null)
                  if (data['end_time'] != null)
                    _buildTimeItem(
                      icon: Icons.check_circle_outline,
                      label: 'Waktu Selesai',
                      value: _formatTime(data['end_time']),
                      color: Colors.red,
                      isTablet: isTablet,
                    ),
              ].separatedBy(CustomTheme().vGap('xl')),
            )
          : Row(
              children: [
                if (data['start_time'] != null)
                  Expanded(
                    child: _buildTimeItem(
                      icon: Icons.play_circle_outline,
                      label: 'Waktu Mulai',
                      value: _formatTime(data['start_time']),
                      color: CustomTheme().buttonColor('primary'),
                      isTablet: isTablet,
                    ),
                  ),
                if (data['start_time'] != null && data['end_time'] != null)
                  Padding(
                    padding: CustomTheme().padding('list-card'),
                    child: Icon(Icons.arrow_forward, color: Colors.grey[400]),
                  ),
                if (data['end_time'] != null)
                  Expanded(
                    child: _buildTimeItem(
                      icon: Icons.check_circle_outline,
                      label: 'Waktu Selesai',
                      value: _formatTime(data['end_time']),
                      color: Colors.green,
                      isTablet: isTablet,
                    ),
                  ),
              ],
            ),
    );
  }

  /// Time Item Widget
  Widget _buildTimeItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isTablet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: isTablet ? 16 : 14,
              color: color,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: CustomTheme().fontSize('sm'),
                color: Colors.grey[600],
              ),
            ),
          ].separatedBy(CustomTheme().hGap('md')),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('md'),
            fontWeight: CustomTheme().fontWeight('bold'),
            color: Colors.grey[800],
          ),
        ),
      ].separatedBy(CustomTheme().vGap('sm')),
    );
  }

  /// Quantity Section
  Widget _buildQuantitySection(Map<String, dynamic> data, bool isTablet) {
    return Row(
      children: [
        if (data['qty'] != null || data['item_qty'] != null)
          Expanded(
            child: _buildInfoCard(
              icon: Icons.inventory_2_outlined,
              label: 'Quantity',
              value: formatNumber(data['qty'] ?? data['item_qty']),
              unit: data['item_unit'] != null
                  ? data['item_unit']['code'].toString()
                  : data['unit']['code']?.toString(),
              color: Colors.purple,
              isTablet: isTablet,
            ),
          ),
        if (data['weight'] != null)
          Expanded(
            child: _buildInfoCard(
              icon: Icons.scale_outlined,
              label: 'Berat',
              value: formatNumber(data['weight']),
              unit: data['weight_unit']['code']?.toString(),
              color: Colors.orange,
              isTablet: isTablet,
            ),
          ),
      ].separatedBy(CustomTheme().hGap('lg')),
    );
  }

  /// Info Card Widget
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    String? unit,
    required Color color,
    required bool isTablet,
  }) {
    return Container(
      padding: CustomTheme().padding('process-content'),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: CustomTheme().padding('process-content'),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  icon,
                  size: isTablet ? 16 : 14,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('xs'),
                  color: Colors.grey[600],
                ),
              ),
            ].separatedBy(CustomTheme().hGap('md')),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize(isTablet ? 'lg' : 'md'),
                    fontWeight: CustomTheme().fontWeight('bold'),
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (unit != null) ...[
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('sm'),
                    color: color.withOpacity(0.7),
                  ),
                ),
              ],
            ].separatedBy(CustomTheme().hGap('sm')),
          ),
        ].separatedBy(CustomTheme().vGap('lg')),
      ),
    );
  }

  /// Grades Section
  Widget _buildGradesSection(List<dynamic> grades, bool isTablet) {
    return Wrap(
      spacing: isTablet ? 10 : 8,
      runSpacing: isTablet ? 10 : 8,
      children: grades.map((grade) {
        return Container(
          padding: CustomTheme().padding('process-content'),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.purple.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.grade,
                size: isTablet ? 14 : 12,
                color: Colors.purple,
              ),
              Text(
                grade['grade']?.toString() ?? grade.toString(),
                style: TextStyle(
                  fontSize: CustomTheme().fontSize(isTablet ? 'sm' : 'xs'),
                  fontWeight: CustomTheme().fontWeight('semibold'),
                  color: Colors.purple[700],
                ),
              ),
              if (grade['qty'] != null) ...[
                Container(
                  padding: CustomTheme().padding('badge-rework'),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${formatNumber(grade['qty'])} ${grade['unit_code']}',
                    style: TextStyle(
                      fontSize: CustomTheme().fontSize('xs'),
                      fontWeight: CustomTheme().fontWeight('bold'),
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ].separatedBy(CustomTheme().hGap('lg')),
          ),
        );
      }).toList(),
    );
  }

  /// Remarks Section

  /// Helper Methods
  Map<String, dynamic> _getStatusConfig(String status) {
    if (status.contains('Selesai')) {
      return {
        'label': 'Selesai',
        'color': Colors.green,
      };
    } else if (status.contains('Diproses')) {
      return {
        'label': 'Diproses',
        'color': Colors.blue,
      };
    } else {
      return {
        'label': 'Menunggu Diproses',
        'color': Colors.orange,
      };
    }
  }

  IconData _getProcessIcon(String? label) {
    if (label == null) return Icons.settings_outlined;

    final lowerLabel = label.toLowerCase();
    if (lowerLabel.contains('dyeing')) return Icons.invert_colors_on_outlined;
    if (lowerLabel.contains('press')) return Icons.layers_outlined;
    if (lowerLabel.contains('tumbler')) return Icons.dry_cleaning_outlined;
    if (lowerLabel.contains('stenter')) return Icons.air;
    if (lowerLabel.contains('long sitting')) {
      return Icons.content_paste_outlined;
    }
    if (lowerLabel.contains('long hemming')) return Icons.cut_outlined;
    if (lowerLabel.contains('cross cutting')) return Icons.cut_outlined;
    if (lowerLabel.contains('sewing')) return Icons.link_outlined;
    if (lowerLabel.contains('embroidery')) return Icons.color_lens_outlined;
    if (lowerLabel.contains('printing')) return Icons.print_outlined;
    if (lowerLabel.contains('sorting')) return Icons.sort_outlined;
    if (lowerLabel.contains('packing')) return Icons.inventory_2_outlined;

    return Icons.settings_outlined;
  }

  String _formatTime(dynamic time) {
    if (time == null) return '-';
    try {
      final dateTime = DateTime.parse(time.toString());
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return time.toString();
    }
  }
}
