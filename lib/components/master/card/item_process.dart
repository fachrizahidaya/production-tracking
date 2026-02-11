// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

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
      width: 600,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;

          final processes =
              widget.item['processes'] as Map<String, dynamic>? ?? {};

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeader(isTablet),

                // Process Timeline / Grid
                Padding(
                  padding: EdgeInsets.all(isTablet ? 20 : 16),
                  child: Column(
                    children: [
                      _buildMaterialSection(isTablet),
                      widget.showTimeline
                          ? _buildProcessTimeline(processes, isTablet)
                          : _buildProcessGrid(processes, isTablet),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Header Section
  Widget _buildHeader(bool isTablet) {
    final itemName = widget.item['wo_no']?.toString() ?? 'Item';
    final itemCode = widget.item['spk_no']?.toString() ?? '-';
    final overallStatus = _getOverallStatus();
    final statusConfig = _getStatusConfig(overallStatus);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkOrderDetail(
              id: widget.item['id'].toString(),
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
        child: Row(
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
                          fontSize:
                              CustomTheme().fontSize(isTablet ? 'xl' : 'lg'),
                          fontWeight: CustomTheme().fontWeight('bold'),
                          color: Colors.grey[800],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: isTablet ? 24 : 20,
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
                          if (widget.item['wo_date'] != null) ...[
                            Icon(
                              Icons.calendar_month_outlined,
                              size: isTablet ? 14 : 12,
                              color: Colors.grey[500],
                            ),
                            Text(
                              DateFormat("dd MMM yyyy").format(
                                  DateTime.parse(widget.item['wo_date'])),
                              style: TextStyle(
                                fontSize: isTablet ? 12 : 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ].separatedBy(CustomTheme().hGap('sm')),
                      ),

                      // Qty Material + Qty Greige
                      Row(
                        children: [
                          _buildQtyInfo(
                            label: 'Qty Material',
                            value: widget.item['wo_qty'],
                            isTablet: isTablet,
                            unit: widget.item['wo_unit'],
                          ),
                          _buildQtyInfo(
                            label: 'Qty Greige',
                            value: widget.item['greige_qty'],
                            isTablet: isTablet,
                            unit: widget.item['greige_unit'],
                          ),
                        ].separatedBy(CustomTheme().hGap('md')),
                      ),
                    ].separatedBy(CustomTheme().vGap('xs')),
                  ),
                ].separatedBy(CustomTheme().vGap('sm')),
              ),
            ),

            // Overall Status Badge
            CustomBadge(
              withStatus: true,
              title: widget.item['status'],
              status: widget.item['status'],
            ),
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
      ),
    );
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
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: isTablet ? 11 : 10,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${value?.toString() ?? '-'} ${unit ?? ''}',
            style: TextStyle(
              fontSize: isTablet ? 12 : 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  /// Code Badge
  Widget _buildSpkBadge(String code, bool isTablet) {
    return Container(
      padding: CustomTheme().padding('badge-rework'),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        code,
        style: TextStyle(
          fontSize: CustomTheme().fontSize('sm'),
          fontWeight: CustomTheme().fontWeight('semibold'),
          color: Colors.grey[700],
        ),
      ),
    );
  }

  /// Process Timeline
  Widget _buildProcessTimeline(Map<String, dynamic> processes, bool isTablet) {
    final processKeys = _getOrderedProcessKeys(processes);

    final visibleKeys = _showAllTimeline
        ? processKeys
        : processKeys.take(_collapsedTimelineCount).toList();

    final hasMore = processKeys.length > _collapsedTimelineCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          icon: Icons.timeline_outlined,
          title: 'Alur Proses',
          isTablet: isTablet,
        ),

        /// Timeline Items
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: Column(
            children: visibleKeys.asMap().entries.map((entry) {
              final index = entry.key;
              final key = entry.value;
              final process = processes[key] ?? {};
              final isLast = index == visibleKeys.length - 1;

              return _buildTimelineItem(
                processKey: key,
                process: process,
                index: index,
                isLast: isLast,
                isTablet: isTablet,
              );
            }).toList(),
          ),
        ),

        /// Expand / Collapse Button
        if (hasMore) ...[
          SizedBox(height: isTablet ? 16 : 12),
          Center(
            child: InkWell(
              onTap: () {
                final next = !_showAllTimeline;
                setState(() {
                  _showAllTimeline = next;
                });
                widget.onExpandChanged?.call(next);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _showAllTimeline ? Icons.expand_less : Icons.expand_more,
                    size: isTablet ? 20 : 18,
                    color: CustomTheme().buttonColor('primary'),
                  ),
                  Text(
                    _showAllTimeline
                        ? 'Sembunyikan Proses'
                        : 'Lihat Semua Proses',
                    style: TextStyle(
                      fontSize: CustomTheme().fontSize('sm'),
                      fontWeight: CustomTheme().fontWeight('semibold'),
                      color: CustomTheme().buttonColor('primary'),
                    ),
                  ),
                ].separatedBy(CustomTheme().hGap('sm')),
              ),
            ),
          ),
        ],
      ].separatedBy(CustomTheme().vGap('xl')),
    );
  }

  /// Timeline Item
  Widget _buildTimelineItem({
    required String processKey,
    required Map<String, dynamic> process,
    required int index,
    required bool isLast,
    required bool isTablet,
  }) {
    final status = process['status']?.toString().toLowerCase() ?? 'pending';
    final statusConfig = _getProcessStatusConfig(status);
    final processConfig = _getProcessConfig(processKey);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Indicator
          SizedBox(
            width: isTablet ? 50 : 40,
            child: Column(
              children: [
                // Circle Indicator
                Container(
                  width: isTablet ? 36 : 30,
                  height: isTablet ? 36 : 30,
                  decoration: BoxDecoration(
                    color: statusConfig['color'].withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: statusConfig['color'],
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      statusConfig['icon'],
                      size: isTablet ? 18 : 14,
                      color: statusConfig['color'],
                    ),
                  ),
                ),
                // Connecting Line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            statusConfig['color'],
                            Colors.grey[300]!,
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Process Card Content
          Expanded(
            child: Container(
              margin:
                  EdgeInsets.only(bottom: isLast ? 0 : (isTablet ? 16 : 12)),
              child: _buildProcessCard(
                processKey: processKey,
                process: process,
                processConfig: processConfig,
                statusConfig: statusConfig,
                isTablet: isTablet,
              ),
            ),
          ),
        ].separatedBy(CustomTheme().hGap('xl')),
      ),
    );
  }

  /// Process Card
  Widget _buildProcessCard({
    required String processKey,
    required Map<String, dynamic> process,
    required Map<String, dynamic> processConfig,
    required Map<String, dynamic> statusConfig,
    required bool isTablet,
  }) {
    return Container(
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: statusConfig['color'].withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: statusConfig['color'].withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Process Header
          Row(
            children: [
              Container(
                padding: CustomTheme().padding('process-content'),
                decoration: BoxDecoration(
                  color: processConfig['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  processConfig['icon'],
                  size: isTablet ? 20 : 18,
                  color: processConfig['color'],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      processConfig['title'],
                      style: TextStyle(
                        fontSize:
                            CustomTheme().fontSize(isTablet ? 'lg' : 'md'),
                        fontWeight: CustomTheme().fontWeight('bold'),
                        color: Colors.grey[800],
                      ),
                    ),
                    if (process['updated_at'] != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        _formatDateTime(process['updated_at']),
                        style: TextStyle(
                          fontSize: CustomTheme().fontSize('sm'),
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Status Chip
              _buildMiniStatusBadge(process, statusConfig, isTablet),
            ].separatedBy(CustomTheme().hGap('md')),
          ),

          // Process Details
          if (_hasProcessDetails(process)) ...[
            SizedBox(height: isTablet ? 14 : 12),
            Divider(height: 1, color: Colors.grey[200]),
            SizedBox(height: isTablet ? 14 : 12),
            _buildProcessDetails(process, processKey, isTablet),
          ],

          // Grades (if applicable)
          if (process['grades'] != null &&
              (process['grades'] as List).isNotEmpty) ...[
            SizedBox(height: isTablet ? 14 : 12),
            _buildGradesSection(process['grades'], isTablet),
          ],
        ],
      ),
    );
  }

  /// Mini Status Badge
  Widget _buildMiniStatusBadge(Map<String, dynamic> process,
      Map<String, dynamic> config, bool isTablet) {
    return CustomBadge(
      withStatus: true,
      rework: true,
      title: process['status'],
      status: process['status'],
    );
  }

  /// Process Details
  Widget _buildProcessDetails(
      Map<String, dynamic> process, String processKey, bool isTablet) {
    final details = <Widget>[];

    // Quantity
    if (process['qty'] != null) {
      details.add(_buildDetailItem(
        icon: Icons.inventory_2_outlined,
        label: 'Qty',
        value:
            '${formatNumber(process['qty'])} ${process['unit']['code'] ?? 'PCS'}',
        isTablet: isTablet,
      ));
    }

    // Weight
    if (process['weight'] != null) {
      details.add(_buildDetailItem(
        icon: Icons.scale_outlined,
        label: 'Berat',
        value:
            '${formatNumber(process['weight'])} ${process['weight_unit']['code'] ?? 'KG'}',
        isTablet: isTablet,
      ));
    }

    // Item Qty
    if (process['item_qty'] != null) {
      details.add(_buildDetailItem(
        icon: Icons.format_list_numbered,
        label: 'Qty',
        value:
            '${formatNumber(process['item_qty'])} ${process['item_unit']['code'] ?? 'PCS'} ',
        isTablet: isTablet,
      ));
    }

    if (details.isEmpty) return const SizedBox.shrink();

    return isTablet
        ? Wrap(
            spacing: 16,
            runSpacing: 12,
            children: details,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: details.map((detail) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: detail,
              );
            }).toList(),
          );
  }

  /// Detail Item
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isTablet,
    bool isFullWidth = false,
  }) {
    final content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Container(
          padding: CustomTheme().padding('process-content'),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: isTablet ? 14 : 12,
            color: Colors.grey[600],
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('sm'),
                  color: Colors.grey[500],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('sm'),
                  fontWeight: CustomTheme().fontWeight('semibold'),
                  color: Colors.grey[800],
                ),
                maxLines: isFullWidth ? 2 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ].separatedBy(CustomTheme().hGap('lg')),
    );

    if (isTablet && !isFullWidth) {
      return SizedBox(
        width: 180,
        child: content,
      );
    }

    return content;
  }

  /// Grades Section
  Widget _buildGradesSection(List<dynamic> grades, bool isTablet) {
    return Container(
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.purple.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.grade_outlined,
                size: isTablet ? 16 : 14,
                color: Colors.purple,
              ),
              const SizedBox(width: 6),
              Text(
                'Grades',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('sm'),
                  fontWeight: CustomTheme().fontWeight('semibold'),
                  color: Colors.purple[700],
                ),
              ),
            ],
          ),
          Wrap(
            spacing: isTablet ? 10 : 8,
            runSpacing: isTablet ? 8 : 6,
            children: grades.map((grade) {
              return _buildGradeChip(grade, isTablet);
            }).toList(),
          ),
        ].separatedBy(CustomTheme().vGap('lg')),
      ),
    );
  }

  /// Grade Chip
  Widget _buildGradeChip(dynamic grade, bool isTablet) {
    final gradeName =
        grade['item_grade']['code']?.toString() ?? grade.toString();
    final gradeQty = grade['qty'];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 12 : 10,
        vertical: isTablet ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            gradeName,
            style: TextStyle(
              fontSize: isTablet ? 12 : 11,
              fontWeight: FontWeight.w600,
              color: Colors.purple[700],
            ),
          ),
          if (gradeQty != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${formatNumber(gradeQty)} ${grade['unit']['code'] ?? 'PCS'}',
                style: TextStyle(
                  fontSize: isTablet ? 11 : 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Process Grid (Alternative Layout)
  Widget _buildProcessGrid(Map<String, dynamic> processes, bool isTablet) {
    final processKeys = _getOrderedProcessKeys(processes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          icon: Icons.grid_view_outlined,
          title: 'Status Proses',
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 16 : 12),
        Wrap(
          spacing: isTablet ? 12 : 8,
          runSpacing: isTablet ? 12 : 8,
          children: processKeys.map((key) {
            final process = processes[key] ?? {};
            return _buildProcessGridItem(key, process, isTablet);
          }).toList(),
        ),
      ],
    );
  }

  /// Process Grid Item
  Widget _buildProcessGridItem(
      String processKey, Map<String, dynamic> process, bool isTablet) {
    final status = process['status']?.toString().toLowerCase() ?? 'pending';
    final statusConfig = _getProcessStatusConfig(status);
    final processConfig = _getProcessConfig(processKey);

    return Container(
      width: isTablet ? 160 : 140,
      padding: EdgeInsets.all(isTablet ? 14 : 12),
      decoration: BoxDecoration(
        color: statusConfig['color'].withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusConfig['color'].withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: processConfig['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              processConfig['icon'],
              size: isTablet ? 24 : 20,
              color: processConfig['color'],
            ),
          ),
          SizedBox(height: isTablet ? 10 : 8),
          // Title
          Text(
            processConfig['title'],
            style: TextStyle(
              fontSize: isTablet ? 13 : 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isTablet ? 8 : 6),
          // Status
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: statusConfig['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  statusConfig['icon'],
                  size: isTablet ? 12 : 10,
                  color: statusConfig['color'],
                ),
                const SizedBox(width: 4),
                Text(
                  statusConfig['label'],
                  style: TextStyle(
                    fontSize: isTablet ? 10 : 9,
                    fontWeight: FontWeight.w600,
                    color: statusConfig['color'],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Title
  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required bool isTablet,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: isTablet ? 20 : 18,
          color: CustomTheme().buttonColor('primary'),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 15 : 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
        ),
      ].separatedBy(CustomTheme().hGap('xl')),
    );
  }

  Widget _buildMaterialSection(bool isTablet) {
    final List items = widget.item['items'] ?? [];

    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          icon: Icons.inventory_2_outlined,
          title: 'Material',
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 16 : 12),
        Column(
          children: items.map<Widget>((item) {
            return _buildMaterialCard(item, isTablet);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMaterialCard(dynamic item, bool isTablet) {
    final code = item['item_code'];
    final name = item['item_name'];
    final variants = item['variants'] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize:
                            CustomTheme().fontSize(isTablet ? 'md' : 'sm'),
                        fontWeight: CustomTheme().fontWeight('bold'),
                        color: Colors.grey[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      code,
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('sm'),
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ].separatedBy(CustomTheme().hGap('md')),
          ),

          /// Variants
          if (variants.isNotEmpty) ...[
            SizedBox(height: isTablet ? 12 : 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: variants.map<Widget>((v) {
                return _buildVariantChip(v);
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVariantChip(dynamic variant) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        '${capitalizeFirst(variant['type'])}: ${variant['value']}',
        style: TextStyle(
          fontSize: CustomTheme().fontSize('sm'),
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Helper Methods
  String _getOverallStatus() {
    final processes = widget.item['processes'] as Map<String, dynamic>? ?? {};
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

  Map<String, dynamic> _getProcessStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'selesai':
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

      default:
        return {
          'label': 'Menunggu Diproses',
          'color': CustomTheme().colors('secondary'),
          'icon': Icons.error_outline,
        };
    }
  }

  Map<String, dynamic> _getProcessConfig(String processKey) {
    switch (processKey.toLowerCase()) {
      case 'dyeing':
        return {
          'title': 'Dyeing',
          'icon': Icons.invert_colors_on_outlined,
          'color': Colors.purple,
        };
      case 'press':
        return {
          'title': 'Press',
          'icon': Icons.layers_outlined,
          'color': Colors.teal,
        };
      case 'tumbler':
        return {
          'title': 'Tumbler',
          'icon': Icons.dry_cleaning_outlined,
          'color': Colors.indigo,
        };
      case 'stenter':
        return {
          'title': 'Stenter',
          'icon': Icons.air_outlined,
          'color': Colors.indigo,
        };
      case 'long_slitting':
        return {
          'title': 'Long Slitting',
          'icon': Icons.content_paste_outlined,
          'color': Colors.indigo,
        };
      case 'long_hemming':
        return {
          'title': 'Long Hemming',
          'icon': Icons.cut_outlined,
          'color': Colors.indigo,
        };
      case 'cross_cutting':
        return {
          'title': 'Cross Cutting',
          'icon': Icons.cut_outlined,
          'color': Colors.indigo,
        };
      case 'sewing':
        return {
          'title': 'Sewing',
          'icon': Icons.link_outlined,
          'color': Colors.pink,
        };
      case 'embroidery':
        return {
          'title': 'Embroidery',
          'icon': Icons.color_lens_outlined,
          'color': Colors.cyan,
        };
      case 'printing':
        return {
          'title': 'Printing',
          'icon': Icons.print_outlined,
          'color': Colors.pink,
        };
      case 'sorting':
        return {
          'title': 'Sorting',
          'icon': Icons.sort_outlined,
          'color': Colors.pink,
        };
      case 'packing':
        return {
          'title': 'Packing',
          'icon': Icons.inventory_2_outlined,
          'color': Colors.brown,
        };
      default:
        return {
          'title': _capitalizeFirst(processKey),
          'icon': Icons.settings_outlined,
          'color': Colors.blueGrey,
        };
    }
  }

  List<String> _getOrderedProcessKeys(Map<String, dynamic> processes) {
    final order = [
      'dyeing',
      'press',
      'tumbler',
      'stenter',
      'long_slitting',
      'long_hemming',
      'cross_cutting',
      'sewing',
      'embroidery',
      'printing',
      'sorting',
      'packing',
    ];
    final keys = processes.keys.toList();

    keys.sort((a, b) {
      final indexA = order.indexOf(a.toLowerCase());
      final indexB = order.indexOf(b.toLowerCase());
      if (indexA == -1 && indexB == -1) return a.compareTo(b);
      if (indexA == -1) return 1;
      if (indexB == -1) return -1;
      return indexA.compareTo(indexB);
    });

    return keys;
  }

  bool _hasProcessDetails(Map<String, dynamic> process) {
    return process['qty'] != null ||
        process['weight'] != null ||
        process['item_qty'] != null;
  }

  String _formatDateTime(dynamic dateTime) {
    if (dateTime == null) return '-';
    try {
      final dt = DateTime.parse(dateTime.toString());
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTime.toString();
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
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
