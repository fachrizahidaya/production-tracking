// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CardContent extends StatelessWidget {
  final data;
  final isTablet;
  final processKey;

  const CardContent({super.key, this.data, this.isTablet, this.processKey});

  @override
  Widget build(BuildContext context) {
    final bool isList = data is List;

    final Map<String, dynamic> mainData =
        isList ? data.last : data; // ambil latest (cycle terakhir)

    final List allData = isList ? data : [data];

    final processNumber = getProcessNumber(mainData, processKey);

    return Container(
      padding: CustomTheme().padding('content'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (processNumber != null)
            _buildProcessNumber(processNumber, isTablet),
          if (mainData['start_time'] != null || mainData['end_time'] != null)
            _buildTimeSection(mainData, isTablet),
          if (processKey != 'packing')
            _buildQuantitySection(mainData, isTablet, processKey),
          if (processKey == 'dyeing') _buildDyeingSection(mainData, isTablet),
          if (['dyeing', 'press', 'tumbler'].contains(processKey))
            _buildReworkFromAllData(allData, isTablet, processKey),
          if (processKey == 'sorting') _buildSortingSection(mainData, isTablet),
          if (processKey == 'packing') _buildPackingSection(mainData, isTablet),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

  Widget _buildProcessNumber(String value, bool isTablet) {
    return Container(
      padding: CustomTheme().padding('process-content'),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            size: isTablet ? 16 : 14,
            color: Colors.grey[700],
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: CustomTheme().fontSize('md'),
                fontWeight: CustomTheme().fontWeight('bold'),
                color: Colors.grey[800],
              ),
            ),
          ),
        ].separatedBy(CustomTheme().hGap('md')),
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

  Widget _buildQuantitySection(
    Map<String, dynamic> data,
    bool isTablet,
    String processKey,
  ) {
    if (processKey == 'long_hemming') {
      return Row(
        children: [
          if (data['good_weight'] != null)
            Expanded(
              child: _buildInfoCard(
                icon: Icons.check_circle_outline,
                label: 'Good Weight',
                value: formatNumber(data['good_weight']),
                unit: data['good_weight_unit']?['code']?.toString(),
                color: Colors.green,
                isTablet: isTablet,
              ),
            ),
          if (data['bs_weight'] != null)
            Expanded(
              child: _buildInfoCard(
                icon: Icons.cancel_outlined,
                label: 'BS Weight',
                value: formatNumber(data['bs_weight']),
                unit: data['bs_weight_unit']?['code']?.toString(),
                color: Colors.red,
                isTablet: isTablet,
              ),
            ),
        ].separatedBy(CustomTheme().hGap('lg')),
      );
    }

    // 🔹 DEFAULT (existing logic)
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
                  : data['unit']?['code']?.toString(),
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
              unit: data['weight_unit']?['code']?.toString(),
              color: Colors.orange,
              isTablet: isTablet,
            ),
          ),
      ].separatedBy(CustomTheme().hGap('lg')),
    );
  }

  Widget _buildDyeingSection(Map<String, dynamic> data, bool isTablet) {
    final lot = data['lot_celup_no'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 LOT CELUP
        if (lot != null) ...[
          _buildSectionTitle(
            icon: Icons.confirmation_number_outlined,
            title: 'Lot Celup',
            isTablet: isTablet,
          ),
          Container(
            padding: CustomTheme().padding('process-content'),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
            ),
            child: Text(
              lot.toString(),
              style: TextStyle(
                fontSize: CustomTheme().fontSize('md'),
                fontWeight: CustomTheme().fontWeight('bold'),
                color: Colors.blue[700],
              ),
            ),
          ),
        ],

        // 🔹 REWORK
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }

  Widget _buildReworkFromAllData(
      List allData, bool isTablet, String processKey) {
    List reworks = [];

    if (processKey == 'dyeing') {
      for (var item in allData) {
        if (item['reworks'] != null) {
          reworks.addAll(item['reworks']);
        }
      }
    } else if (['press', 'tumbler'].contains(processKey)) {
      for (var item in allData) {
        if ((item['cycle_no'] ?? 1) > 1) {
          reworks.add(item);
        }
      }
    }

    if (reworks.isEmpty) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          icon: Icons.refresh,
          title: 'Rework',
          isTablet: isTablet,
        ),
        Column(
          children: reworks.map<Widget>((rw) {
            return _buildReworkItem(rw, isTablet, processKey);
          }).toList(),
        ),
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }

  Widget _buildReworkItem(
      Map<String, dynamic> item, bool isTablet, String processKey) {
    final no =
        item['dyeing_no'] ?? item['press_no'] ?? item['tumbler_no'] ?? '-';

    final qty = item['qty'] ?? item['weight'];

    final unit = item['unit']?['code'] ?? item['weight_unit']?['code'] ?? '';

    return Container(
      padding: CustomTheme().padding('process-content'),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 NO
          Text(
            no,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          // 🔹 TIME
          if (item['start_time'] != null)
            Text('Mulai: ${_formatTime(item['start_time'])}'),

          if (item['end_time'] != null)
            Text('Selesai: ${_formatTime(item['end_time'])}'),

          // 🔹 QTY / WEIGHT
          if (qty != null) Text('Qty: ${formatNumber(qty)} $unit'),
        ].separatedBy(CustomTheme().vGap('sm')),
      ),
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

  Widget _buildSortingSection(Map<String, dynamic> data, bool isTablet) {
    final int rework = data['rework_long_hemming'] ?? 0;
    final int spraying = data['spraying'] ?? 0;
    final int combing = data['combing'] ?? 0;

    final int totalPerbaikan = rework + spraying + combing;

    final List grades = data['grades'] ?? [];

    final int totalGrade = grades.fold(
      0,
      (sum, g) => sum + ((g['qty'] ?? 0) as int),
    );

    final int totalSortir = totalPerbaikan + totalGrade;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 PERBAIKAN
        _buildSectionTitle(
          icon: Icons.build_outlined,
          title: 'Perbaikan',
          isTablet: isTablet,
        ),

        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.refresh,
                label: 'Rework LH',
                value: formatNumber(rework),
                unit: 'PCS',
                color: Colors.orange,
                isTablet: isTablet,
              ),
            ),
            Expanded(
              child: _buildInfoCard(
                icon: Icons.water_drop_outlined,
                label: 'Spraying',
                value: formatNumber(spraying),
                unit: 'PCS',
                color: Colors.blue,
                isTablet: isTablet,
              ),
            ),
            Expanded(
              child: _buildInfoCard(
                icon: Icons.cleaning_services_outlined,
                label: 'Combing',
                value: formatNumber(combing),
                unit: 'PCS',
                color: Colors.green,
                isTablet: isTablet,
              ),
            ),
          ].separatedBy(CustomTheme().hGap('lg')),
        ),

        _buildInfoCard(
          icon: Icons.calculate_outlined,
          label: 'Total Perbaikan',
          value: formatNumber(totalPerbaikan),
          unit: 'PCS',
          color: Colors.deepOrange,
          isTablet: isTablet,
        ),

        // 🔹 GRADES
        if (grades.isNotEmpty) ...[
          _buildSectionTitle(
            icon: Icons.grade_outlined,
            title: 'Grades',
            isTablet: isTablet,
          ),
          _buildGradesSection(grades, isTablet),
          _buildInfoCard(
            icon: Icons.summarize_outlined,
            label: 'Total Grades',
            value: formatNumber(totalGrade),
            unit: 'PCS',
            color: Colors.purple,
            isTablet: isTablet,
          ),
        ],

        // 🔹 TOTAL SORTIR
        _buildSectionTitle(
          icon: Icons.analytics_outlined,
          title: 'Total Sortir',
          isTablet: isTablet,
        ),

        _buildInfoCard(
          icon: Icons.check_circle,
          label: 'Total',
          value: formatNumber(totalSortir),
          unit: 'PCS',
          color: Colors.teal,
          isTablet: isTablet,
        ),
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }

  Widget _buildPackingSection(Map<String, dynamic> data, bool isTablet) {
    final qty = data['qty'] ?? 0;
    final unit = data['unit']?['code'] ?? '';

    final weightPerDozen = data['weight_per_dozen'];
    final gsm = data['gsm'];
    final weightGradeA = data['weight_grade_a'];
    final totalWeight = data['total_weight'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 TOTAL PACKING
        _buildSectionTitle(
          icon: Icons.inventory_2_outlined,
          title: 'Total Packing',
          isTablet: isTablet,
        ),

        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.numbers,
                label: 'Qty',
                value: formatNumber(qty),
                unit: unit,
                color: Colors.blue,
                isTablet: isTablet,
              ),
            ),
            if (weightPerDozen != null)
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.scale_outlined,
                  label: 'Berat / Lusin',
                  value: formatNumber(weightPerDozen),
                  unit: 'KG',
                  color: Colors.orange,
                  isTablet: isTablet,
                ),
              ),
          ].separatedBy(CustomTheme().hGap('lg')),
        ),

        Row(
          children: [
            if (gsm != null)
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.texture_outlined,
                  label: 'Gramasi',
                  value: formatNumber(gsm),
                  unit: 'GSM',
                  color: Colors.purple,
                  isTablet: isTablet,
                ),
              ),
            if (weightGradeA != null)
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.verified_outlined,
                  label: 'Berat Grade A',
                  value: formatNumber(weightGradeA),
                  unit: 'KG',
                  color: Colors.green,
                  isTablet: isTablet,
                ),
              ),
          ].separatedBy(CustomTheme().hGap('lg')),
        ),

        // 🔹 TOTAL BERAT
        if (totalWeight != null) ...[
          _buildSectionTitle(
            icon: Icons.summarize_outlined,
            title: 'Total Berat',
            isTablet: isTablet,
          ),
          _buildInfoCard(
            icon: Icons.scale,
            label: 'Total',
            value: formatNumber(totalWeight),
            unit: 'KG',
            color: Colors.teal,
            isTablet: isTablet,
          ),
        ],
      ].separatedBy(CustomTheme().vGap('lg')),
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

  String? getProcessNumber(Map<String, dynamic> data, String processKey) {
    switch (processKey) {
      case 'dyeing':
        return data['dyeing_no'];
      case 'press':
        return data['press_no'];
      case 'tumbler':
        return data['tumbler_no'];
      case 'stenter':
        return data['stenter_no'];
      case 'long_slitting':
        return data['ls_no'];
      case 'long_hemming':
        return data['lh_no'];
      case 'cross_cutting':
        return data['cc_no'];
      case 'sewing':
        return data['sewing_no'];
      case 'sorting':
        return data['sorting_no'];
      case 'packing':
        return data['packing_no'];
      default:
        return null;
    }
  }
}
