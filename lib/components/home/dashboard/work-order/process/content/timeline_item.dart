// ignore_for_file: deprecated_member_use

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
    List<Map<String, dynamic>> normalizeProcess(
      String key,
      dynamic process,
    ) {
      // Khusus process tertentu
      const specialKeys = ['dyeing', 'press', 'tumbler'];

      if (process is List) {
        final list = process.cast<Map<String, dynamic>>();

        if (specialKeys.contains(key)) {
          if (list.length > 1) {
            final reworkItem = list.firstWhere(
              (e) => e['rework_dyeing'] == true,
              orElse: () => list.first,
            );
            return [reworkItem]; // ✅ hanya 1 item
          }
        }

        return list; // default
      }

      if (process is Map<String, dynamic>) {
        return [process];
      }

      return [];
    }

    return AnimatedSize(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Column(
        children: visibleKeys.asMap().entries.expand<Widget>((entry) {
          final index = entry.key;
          final key = entry.value;

          final rawProcess = processes[key];

          final processList = normalizeProcess(key, rawProcess);

          return processList.asMap().entries.map((pEntry) {
            final i = pEntry.key;
            final process = pEntry.value;

            final isLast =
                index == visibleKeys.length - 1 && i == processList.length - 1;

            return _buildTimelineItem(
                processKey: key,
                process: process,
                index: i,
                isLast: isLast,
                isTablet: isTablet,
                rawProcess: rawProcess);
          });
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
    dynamic rawProcess,
  }) {
    final status =
        process['status']?.toString().toLowerCase() ?? 'menunggu diproses';
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
                  rawProcess: rawProcess,
                  allProcesses: processes),
            ),
          ),
        ].separatedBy(CustomTheme().hGap('xl')),
      ),
    );
  }

  Widget _buildProcessCard(
      {required String processKey,
      required Map<String, dynamic> process,
      required Map<String, dynamic> processConfig,
      required Map<String, dynamic> statusConfig,
      required bool isTablet,
      dynamic rawProcess,
      required Map<String, dynamic> allProcesses}) {
    String? getProcessNumber(String processKey, Map<String, dynamic> process) {
      final fieldMap = {
        'dyeing': 'dyeing_no',
        'press': 'press_no',
        'tumbler': 'tumbler_no',
        'stenter': 'stenter_no',
        'long_slitting': 'ls_no',
        'long_hemming': 'lh_no',
        'cross_cutting': 'cc_no',
        'sewing': 'sewing_no',
        'sorting': 'sorting_no',
        'packing': 'packing_no',
      };

      final field = fieldMap[processKey];
      if (field == null) return null;

      return process[field]?.toString();
    }

    Map<String, dynamic>? getReworkData(dynamic rawProcess) {
      if (rawProcess is List) {
        try {
          return rawProcess.firstWhere((e) => e['rework_dyeing'] == true);
        } catch (_) {}
      }
      return null;
    }

    String getStatus(dynamic process) {
      if (process is List && process.isNotEmpty) {
        return process.first['status']?.toString().toLowerCase() ?? '';
      } else if (process is Map<String, dynamic>) {
        return process['status']?.toString().toLowerCase() ?? '';
      }
      return '';
    }

    final processNumber = getProcessNumber(processKey, process);

    final rework = getReworkData(rawProcess);

    final isSpecial = ['dyeing', 'press', 'tumbler'].contains(processKey);

    final printing = allProcesses['printing'];

    final sortingStatus = getStatus(allProcesses['sorting']);
    final printingStatus = getStatus(allProcesses['printing']);

    final printingExists =
        printing is Map<String, dynamic> && printing['id'] != null;

    String finalStatus = process['status'];

    if (sortingStatus == 'diproses' || sortingStatus == 'selesai') {
      if (processKey == 'embroidery' || processKey == 'printing') {
        finalStatus = 'Dilewati';
      }
    }

    if ((printingStatus == 'diproses' || printingStatus == 'selesai') &&
        printingExists) {
      if (processKey == 'embroidery') {
        finalStatus = 'Dilewati';
      }
    }

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    Column(
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

                        // ✅ NOMOR PROCESS

                        if (processNumber != null) ...[
                          SizedBox(height: 2),
                          Text(
                            processNumber,
                            style: TextStyle(
                              fontSize: CustomTheme().fontSize('sm'),
                              color: Colors.grey[600],
                              fontWeight: CustomTheme().fontWeight('medium'),
                            ),
                          ),
                        ],

                        // existing updated_at
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

              _buildMiniStatusBadge(process, statusConfig, isTablet,
                  customStatus: finalStatus),
            ].separatedBy(CustomTheme().hGap('md')),
          ),

          // Process Details
          if (_hasProcessDetails(process)) ...[
            SizedBox(height: isTablet ? 14 : 12),
            Divider(height: 1, color: Colors.grey[200]),
            SizedBox(height: isTablet ? 14 : 12),
            _buildProcessDetails(process, processKey, isTablet),
          ],

          if (isSpecial && rework != null) ...[
            SizedBox(height: 12),
            _buildReworkCard(processKey, rework, isTablet),
          ],

          // Grades (if applicable)
          if (process['grades'] != null &&
              (process['grades'] as List).isNotEmpty) ...[
            SizedBox(height: isTablet ? 14 : 12),
            _buildGradesSection(process['grades'], isTablet),
          ],

          // ✅ Sorting Improvement Section
          if (processKey == 'sorting') ...[
            SizedBox(height: isTablet ? 14 : 12),
            _buildSortingImprovementSection(process, isTablet),

            SizedBox(height: isTablet ? 10 : 8),
            _buildSortingTotalSection(process, isTablet), // ✅ DIPISAH
          ],

          if (processKey == 'packing') ...[
            SizedBox(height: isTablet ? 14 : 12),
            Divider(height: 1, color: Colors.grey[200]),
            SizedBox(height: isTablet ? 14 : 12),
            _buildPackingSection(process, isTablet),
          ],
        ],
      ),
    );
  }

  Widget _buildMiniStatusBadge(
    Map<String, dynamic> process,
    Map<String, dynamic> config,
    bool isTablet, {
    String? customStatus,
    String? processKey,
  }) {
    final status = customStatus ?? process['status'];

    final isSkipped =
        (processKey == 'embroidery' || processKey == 'printing') &&
            status.toString().toLowerCase() == 'dilewati';

    return CustomBadge(
      withStatus: true,
      rework: true,
      title: status,
      status: status,
      isSkipped: isSkipped,
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

    // Good Weight (Berat Bagus)
    if (process['good_weight'] != null) {
      details.add(_buildDetailItem(
        icon: Icons.thumb_up_outlined,
        label: 'Berat Bagus',
        value:
            '${formatNumber(process['good_weight'])} ${process['good_weight_unit']?['code'] ?? 'KG'}',
        isTablet: isTablet,
      ));
    }

    // Item Qty
    if (process['item_qty'] != null) {
      details.add(_buildDetailItem(
        icon: Icons.inventory_2_outlined,
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

  Widget _buildReworkCard(
      String processKey, Map<String, dynamic> process, bool isTablet) {
    String? getProcessNumber(String processKey, Map<String, dynamic> process) {
      final fieldMap = {
        'dyeing': 'dyeing_no',
        'press': 'press_no',
        'tumbler': 'tumbler_no',
        'stenter': 'stenter_no',
        'long_slitting': 'ls_no',
        'long_hemming': 'lh_no',
        'cross_cutting': 'cc_no',
        'sewing': 'sewing_no',
        'sorting': 'sorting_no',
        'packing': 'packing_no',
      };

      final field = fieldMap[processKey];
      if (field == null) return null;

      return process[field]?.toString();
    }

    final processNumber = getProcessNumber(processKey, process);

    String value = '-';

    if (process['qty'] != null) {
      value =
          '${formatNumber(process['qty'])} ${process['unit']?['code'] ?? ''}';
    } else if (process['weight'] != null) {
      value =
          '${formatNumber(process['weight'])} ${process['weight_unit']?['code'] ?? ''}';
    }

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.refresh, color: Colors.orange),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rework',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                if (processNumber != null) Text(processNumber),
                Text(value),
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildSortingImprovementSection(
      Map<String, dynamic> process, bool isTablet) {
    final reworkLH = process['rework_long_hemming'] ?? 0;
    final spraying = process['spraying'] ?? 0;
    final combing = process['combing'] ?? 0;

    // optional hide kalau kosong semua
    if (reworkLH == 0 && spraying == 0 && combing == 0) {
      return SizedBox.shrink();
    }

    return Container(
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.orange.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.build_circle_outlined,
                size: CustomTheme().iconSize(isTablet ? 'lg' : 'md'),
                color: Colors.orange,
              ),
              SizedBox(width: 6),
              Text(
                'Perbaikan',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('md'),
                  fontWeight: CustomTheme().fontWeight('semibold'),
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildSimpleChip('Rework LH', reworkLH),
              _buildSimpleChip('Spraying', spraying),
              _buildSimpleChip('Combing', combing),
            ],
          ),
        ].separatedBy(SizedBox(height: 10)),
      ),
    );
  }

  Widget _buildSortingTotalSection(
      Map<String, dynamic> process, bool isTablet) {
    final reworkLH = process['rework_long_hemming'] ?? 0;
    final spraying = process['spraying'] ?? 0;
    final combing = process['combing'] ?? 0;

    final grades = process['grades'] as List? ?? [];

    final totalGradeQty = grades.fold<int>(
      0,
      (sum, g) => sum + ((g['qty'] ?? 0) as int),
    );

    final totalSorting = reworkLH + spraying + combing + totalGradeQty;

    return Container(
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.green.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calculate_outlined,
            color: Colors.green,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Total Sorting',
              style: TextStyle(
                fontWeight: CustomTheme().fontWeight('bold'),
                color: Colors.green[700],
              ),
            ),
          ),
          Text(
            '${formatNumber(totalSorting)} PCS',
            style: TextStyle(
              fontWeight: CustomTheme().fontWeight('bold'),
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackingSection(
    Map<String, dynamic> process,
    bool isTablet,
  ) {
    return Container(
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.scale_outlined,
                size: CustomTheme().iconSize(isTablet ? 'lg' : 'md'),
                color: Colors.blue,
              ),
              SizedBox(width: 6),
              Text(
                'Gramasi & Berat',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('md'),
                  fontWeight: CustomTheme().fontWeight('semibold'),
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              if (process['weight_per_dozen'] != null)
                _buildDetailItem(
                  icon: Icons.line_weight,
                  label: 'Weight / Dozen',
                  value: '${process['weight_per_dozen']}',
                  isTablet: isTablet,
                ),
              if (process['gsm'] != null)
                _buildDetailItem(
                  icon: Icons.texture,
                  label: 'GSM',
                  value: '${process['gsm']}',
                  isTablet: isTablet,
                ),
              if (process['weight_grade_a'] != null)
                _buildDetailItem(
                  icon: Icons.verified,
                  label: 'Berat Grade A',
                  value: formatNumber(process['weight_grade_a']),
                  isTablet: isTablet,
                ),
              if (process['total_weight'] != null)
                _buildDetailItem(
                  icon: Icons.scale,
                  label: 'Total Berat',
                  value: formatNumber(process['total_weight']),
                  isTablet: isTablet,
                ),
            ],
          ),
        ],
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

  Widget _buildSimpleChip(String label, int value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Text(
        '$label: ${formatNumber(value)}',
        style: TextStyle(fontSize: 12),
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
        process['item_qty'] != null ||
        process['good_weight'] != null;
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
