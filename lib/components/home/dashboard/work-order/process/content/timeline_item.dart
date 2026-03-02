import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class TimelineItem extends StatelessWidget {
  final processes;
  final getProcessStatusConfig;
  final getProcessConfig;
  final isTablet;
  final visibleKeys;
  const TimelineItem(
      {super.key,
      this.getProcessConfig,
      this.getProcessStatusConfig,
      this.processes,
      this.isTablet,
      this.visibleKeys});

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Column(
        children: visibleKeys.asMap().entries.map<Widget>((entry) {
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
    );
  }

  Widget _buildTimelineItem({
    required String processKey,
    required Map<String, dynamic> process,
    required int index,
    required bool isLast,
    required bool isTablet,
  }) {
    final status = process['status']?.toString().toLowerCase() ?? 'pending';
    final statusConfig = getProcessStatusConfig(status);
    final processConfig = getProcessConfig(processKey);

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
                      size: CustomTheme().iconSize(isTablet ? 'lg' : 'md'),
                      color: statusConfig['color'],
                    ),
                  ),
                ),
                // Connecting Line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: EdgeInsets.symmetric(vertical: 4),
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
            offset: Offset(0, 2),
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
                  size: CustomTheme().iconSize(isTablet ? 'xl' : 'lg'),
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
                      SizedBox(height: 2),
                      Text(
                        _formatDateTime(process['updated_at']),
                        style: TextStyle(
                          fontSize: CustomTheme().fontSize('md'),
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

  Widget _buildMiniStatusBadge(Map<String, dynamic> process,
      Map<String, dynamic> config, bool isTablet) {
    return CustomBadge(
      withStatus: true,
      rework: true,
      title: process['status'],
      status: process['status'],
    );
  }

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

    if (details.isEmpty) return SizedBox.shrink();

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
                padding: EdgeInsets.only(bottom: 10),
                child: detail,
              );
            }).toList(),
          );
  }

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
                size: CustomTheme().iconSize(isTablet ? 'lg' : 'md'),
                color: Colors.purple,
              ),
              SizedBox(width: 6),
              Text(
                'Grades',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('md'),
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
              fontSize: CustomTheme().fontSize(isTablet ? 'lg' : 'md'),
              fontWeight: CustomTheme().fontWeight('semibold'),
              color: Colors.purple[700],
            ),
          ),
          if (gradeQty != null) ...[
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(
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
                  fontSize: CustomTheme().fontSize(isTablet ? 'md' : 'sm'),
                  fontWeight: CustomTheme().fontWeight('bold'),
                  color: Colors.purple,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

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
            size: CustomTheme().iconSize(isTablet ? 'md' : 'sm'),
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
                  fontSize: CustomTheme().fontSize('md'),
                  color: Colors.grey[500],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('md'),
                  fontWeight: CustomTheme().fontWeight('semibold'),
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
}
