import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CardContent extends StatelessWidget {
  final data;
  final isTablet;
  const CardContent({
    super.key,
    this.data,
    this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: CustomTheme().padding('content'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data['start_time'] != null || data['end_time'] != null) ...[
            _buildTimeSection(data, isTablet),
          ],
          _buildQuantitySection(data, isTablet),
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
                    icon: Icons.access_time_outlined,
                    label: 'Waktu Mulai',
                    value: _formatTime(data['start_time']),
                    color: Colors.green,
                    isTablet: isTablet,
                  ),
                if (data['start_time'] != null && data['end_time'] != null)
                  if (data['end_time'] != null)
                    _buildTimeItem(
                      icon: Icons.task_alt_outlined,
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
                Text(
                  '${formatNumber(grade['qty'])} ${grade['unit_code']}',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('xs'),
                    fontWeight: CustomTheme().fontWeight('bold'),
                    color: Colors.purple,
                  ),
                ),
              ],
            ].separatedBy(CustomTheme().hGap('lg')),
          ),
        );
      }).toList(),
    );
  }

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

  String _formatTime(dynamic time) {
    if (time == null) return '-';

    try {
      final dateTime = DateTime.parse(time.toString());

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      final day = dateTime.day.toString().padLeft(2, '0');
      final month = months[dateTime.month - 1];
      final year = dateTime.year;

      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');

      return '$day $month $year, $hour.$minute';
    } catch (e) {
      return time.toString();
    }
  }
}
