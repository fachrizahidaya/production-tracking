// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CardContent extends StatefulWidget {
  final data;
  final isTablet;
  final processKey;

  const CardContent({super.key, this.data, this.isTablet, this.processKey});

  @override
  State<CardContent> createState() => _CardContentState();
}

class _CardContentState extends State<CardContent> {
  bool isExpandedRework = false;

  @override
  Widget build(BuildContext context) {
    final bool isList = widget.data is List;

    final Map<String, dynamic> mainData = isList
        ? widget.data.last
        : widget.data; // ambil latest (cycle terakhir)

    final List allData = isList ? widget.data : [widget.data];

    final processNumber = getProcessNumber(mainData, widget.processKey);

    return Container(
      padding: CustomTheme().padding('content'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (processNumber != null)
            _buildProcessNumber(processNumber, widget.isTablet),

          /// ✅ PROSES PRODUKSI
          if (_hasProductionItems(mainData) && widget.processKey != 'dyeing')
            _buildProductionItemsSection(mainData, widget.isTablet),

          if (mainData['start_time'] != null || mainData['end_time'] != null)
            _buildTimeSection(mainData, widget.isTablet),

          if (widget.processKey != 'packing')
            _buildQuantitySection(
              mainData,
              widget.isTablet,
              widget.processKey,
            ),

          if (widget.processKey == 'dyeing')
            _buildDyeingSection(mainData, widget.isTablet),

          if (['dyeing', 'press', 'tumbler'].contains(widget.processKey))
            _buildReworkFromAllData(
              allData,
              widget.isTablet,
              widget.processKey,
            ),

          if (widget.processKey == 'sorting')
            _buildSortingSection(mainData, widget.isTablet),

          // if (widget.processKey == 'packing')
          //   _buildPackingSection(mainData, widget.isTablet),
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
    // if (processKey == 'long_hemming') {
    //   final outputs = data['material_outputs'] as List? ?? [];

    //   double goodWeight = 0;
    //   double bsWeight = 0;

    //   for (final item in outputs) {
    //     goodWeight += ((item['good_weight'] ?? 0) as num).toDouble();
    //     bsWeight += ((item['bs_weight'] ?? 0) as num).toDouble();
    //   }

    //   return Row(
    //     children: [
    //       Expanded(
    //         child: _buildInfoCard(
    //           icon: Icons.check_circle_outline,
    //           label: 'Berat Bagus',
    //           value: formatNumber(goodWeight),
    //           unit: 'KG',
    //           color: Colors.green,
    //           isTablet: isTablet,
    //         ),
    //       ),
    //       Expanded(
    //         child: _buildInfoCard(
    //           icon: Icons.cancel_outlined,
    //           label: 'Berat BS',
    //           value: formatNumber(bsWeight),
    //           unit: 'KG',
    //           color: Colors.red,
    //           isTablet: isTablet,
    //         ),
    //       ),
    //     ].separatedBy(CustomTheme().hGap('lg')),
    //   );
    // }

    // 🔹 DEFAULT (existing logic)
    return Row(
      children: [
        if (data['qty'] != null || data['item_qty'] != null)
          Expanded(
            child: _buildInfoCard(
              icon: Icons.inventory_2_outlined,
              label: 'Qty',
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
    final List semifinishedProducts = data['semifinished_products'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 LOT & CYCLE

        /// 🔹 REWORK STATUS

        /// 🔹 SEMI FINISHED PRODUCTS
        if (semifinishedProducts.isNotEmpty) ...[
          _buildSectionTitle(
            icon: Icons.inventory_2_outlined,
            title: 'Semi Finished Products',
            isTablet: isTablet,
          ),
          ...semifinishedProducts
              .map((item) {
                return Container(
                  padding: CustomTheme().padding('process-content'),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.indigo.withOpacity(0.15),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        color: Colors.indigo,
                        size: isTablet ? 18 : 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['code'] ?? '-',
                              style: TextStyle(
                                fontWeight: CustomTheme().fontWeight('bold'),
                              ),
                            ),
                            Text(
                              item['name'] ?? '-',
                              style: TextStyle(
                                fontSize: CustomTheme().fontSize('sm'),
                                color: Colors.grey[700],
                              ),
                            ),
                          ].separatedBy(
                            CustomTheme().vGap('sm'),
                          ),
                        ),
                      ),
                    ].separatedBy(CustomTheme().hGap('lg')),
                  ),
                );
              })
              .toList()
              .separatedBy(CustomTheme().vGap('md')),
        ],

        /// 🔹 ATTACHMENTS

        /// 🔹 NOTES
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

    final preview = reworks.take(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 HEADER
        GestureDetector(
          onTap: () {
            setState(() {
              isExpandedRework = !isExpandedRework;
            });
          },
          child: Row(
            children: [
              Expanded(
                child: _buildSectionTitle(
                  icon: Icons.refresh,
                  title: 'Rework (${reworks.length})',
                  isTablet: isTablet,
                ),
              ),
              Icon(
                isExpandedRework ? Icons.expand_less : Icons.expand_more,
              ),
            ],
          ),
        ),

        /// 🔹 CONTENT
        AnimatedCrossFade(
          duration: Duration(milliseconds: 250),
          crossFadeState: isExpandedRework
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,

          /// COLLAPSE
          firstChild: Column(
            children: preview
                .map<Widget>((rw) {
                  return _buildReworkItem(rw, isTablet, processKey);
                })
                .toList()
                .separatedBy(CustomTheme().vGap('xl')),
          ),

          /// EXPAND (🔥 SCROLLABLE)
          secondChild: SizedBox(
            height: 300, // 🔥 batas tinggi
            child: ListView.builder(
              itemCount: reworks.length,
              itemBuilder: (context, i) {
                return _buildReworkItem(reworks[i], isTablet, processKey);
              },
            ),
          ),
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

  Widget _buildSortingSection(
    Map<String, dynamic> data,
    bool isTablet,
  ) {
    final List grades = data['grades'] ?? [];

    final int rework = data['rework_long_hemming'] ?? 0;
    final int spraying = data['spraying'] ?? 0;
    final int combing = data['combing'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          icon: Icons.sort_outlined,
          title: 'Hasil Sortir',
          isTablet: isTablet,
        ),
        SizedBox(
          height: 16,
        ),
        ...grades
            .map((item) {
              final List itemGrades = item['grades'] ?? [];

              num gradeA = 0;
              num gradeB = 0;
              num gradeBS = 0;

              for (final g in itemGrades) {
                final grade = g['grade'];

                if (grade == 'A') {
                  gradeA = (g['qty'] ?? 0) as num;
                } else if (grade == 'B') {
                  gradeB = (g['qty'] ?? 0) as num;
                } else if (grade == 'BS') {
                  final rawBs = (g['qty'] ?? 0) as num;

                  /// BS = qty / 10
                  gradeBS = rawBs;
                }
              }

              final totalItem =
                  rework + spraying + combing + gradeA + gradeB + gradeBS;

              return Container(
                padding: CustomTheme().padding('process-content'),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 ITEM HEADER
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.indigo,
                          size: isTablet ? 18 : 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['item_code'] ?? '-',
                                style: TextStyle(
                                  fontWeight: CustomTheme().fontWeight('bold'),
                                ),
                              ),
                              Text(
                                item['item_name'] ?? '-',
                                style: TextStyle(
                                  fontSize: CustomTheme().fontSize('sm'),
                                  color: Colors.grey[700],
                                ),
                              ),
                            ].separatedBy(
                              CustomTheme().vGap('sm'),
                            ),
                          ),
                        ),
                      ].separatedBy(CustomTheme().hGap('lg')),
                    ),

                    /// 🔹 SORTING RESULT
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildMiniGradeCard(
                          label: 'Permak Long Hemming',
                          value: rework,
                          color: Colors.orange,
                          icon: Icons.refresh,
                          isTablet: isTablet,
                        ),
                        _buildMiniGradeCard(
                          label: 'Semprotan',
                          value: spraying,
                          color: Colors.blue,
                          icon: Icons.water_drop_outlined,
                          isTablet: isTablet,
                        ),
                        _buildMiniGradeCard(
                          label: 'Sisiran',
                          value: combing,
                          color: Colors.teal,
                          icon: Icons.cleaning_services_outlined,
                          isTablet: isTablet,
                        ),
                        _buildMiniGradeCard(
                          label: 'Grade A',
                          value: gradeA,
                          color: Colors.green,
                          icon: Icons.grade,
                          isTablet: isTablet,
                        ),
                        _buildMiniGradeCard(
                          label: 'Grade B',
                          value: gradeB,
                          color: Colors.amber,
                          icon: Icons.grade_outlined,
                          isTablet: isTablet,
                        ),
                        _buildMiniGradeCard(
                          label: 'Tipe BS',
                          value: gradeBS,
                          color: Colors.red,
                          icon: Icons.cancel_outlined,
                          isTablet: isTablet,
                        ),
                      ],
                    ),

                    /// 🔹 TOTAL ITEM
                    _buildInfoCard(
                      icon: Icons.calculate_outlined,
                      label: 'Total',
                      value: formatNumber(totalItem),
                      unit: 'PCS',
                      color: Colors.indigo,
                      isTablet: isTablet,
                    ),
                  ].separatedBy(CustomTheme().vGap('lg')),
                ),
              );
            })
            .toList()
            .separatedBy(CustomTheme().vGap('lg')),
      ],
    );
  }

  Widget _buildPackingSection(Map<String, dynamic> data, bool isTablet) {
    final outputs = data['material_outputs'] as List? ?? [];

    if (outputs.isEmpty) {
      return const SizedBox.shrink();
    }

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

  bool _hasProductionItems(Map<String, dynamic> data) {
    return (data['items'] != null && (data['items'] as List).isNotEmpty) ||
        (data['semifinished_products'] != null &&
            (data['semifinished_products'] as List).isNotEmpty) ||
        (data['finished_products'] != null &&
            (data['finished_products'] as List).isNotEmpty);
  }

  Widget _buildProductionItemsSection(
    Map<String, dynamic> data,
    bool isTablet,
  ) {
    final List items = ['long_hemming', 'cross_cutting', 'sewing', 'packing']
            .contains(widget.processKey)
        ? (data['material_outputs'] ?? [])
        : (data['items'] ?? []);

    if (items.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          icon: Icons.precision_manufacturing_outlined,
          title: 'Material',
          isTablet: isTablet,
        ),
        ...items
            .map((item) {
              /// ✅ PACKING = finished product
              final productionItem = widget.processKey == 'packing'
                  ? item['finished_product']
                  : ['long_hemming', 'cross_cutting', 'sewing']
                          .contains(widget.processKey)
                      ? item['finished_product']
                      : item['semifinished_product'];

              final goodWeight = item['good_weight'];
              final bsWeight = item['bs_weight'];
              final qty = item['qty'];

              return Container(
                padding: CustomTheme().padding('process-content'),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.indigo.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ✅ ITEM
                    if (productionItem != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            widget.processKey == 'packing'
                                ? Icons.inventory_2_outlined
                                : Icons.precision_manufacturing_outlined,
                            color: widget.processKey == 'packing'
                                ? Colors.green
                                : Colors.orange,
                            size: isTablet ? 18 : 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.processKey == 'packing'
                                      ? 'Finished Product'
                                      : 'Semi Finished',
                                  style: TextStyle(
                                    fontSize: CustomTheme().fontSize('xs'),
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  productionItem['code'] ?? '-',
                                  style: TextStyle(
                                    fontWeight:
                                        CustomTheme().fontWeight('bold'),
                                  ),
                                ),
                                Text(
                                  productionItem['name'] ?? '-',
                                  style: TextStyle(
                                    fontSize: CustomTheme().fontSize('sm'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ].separatedBy(CustomTheme().hGap('md')),
                      ),

                    /// ✅ LONG HEMMING
                    if (widget.processKey == 'long_hemming')
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.check_circle_outline,
                              label: 'Berat Bagus',
                              value: formatNumber(goodWeight ?? 0),
                              unit: 'KG',
                              color: Colors.green,
                              isTablet: isTablet,
                            ),
                          ),
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.cancel_outlined,
                              label: 'Berat BS',
                              value: formatNumber(bsWeight ?? 0),
                              unit: 'KG',
                              color: Colors.red,
                              isTablet: isTablet,
                            ),
                          ),
                        ].separatedBy(CustomTheme().hGap('lg')),
                      ),

                    /// ✅ PACKING DETAIL
                    if (widget.processKey == 'packing')
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoCard(
                                  icon: Icons.inventory_2_outlined,
                                  label: 'Qty',
                                  value: formatNumber(qty ?? 0),
                                  unit: 'PCS',
                                  color: Colors.blue,
                                  isTablet: isTablet,
                                ),
                              ),
                              Expanded(
                                child: _buildInfoCard(
                                  icon: Icons.scale_outlined,
                                  label: 'Berat / Lusin',
                                  value: formatNumber(
                                    item['weight_per_dozen'] ?? 0,
                                  ),
                                  unit: 'KG',
                                  color: Colors.orange,
                                  isTablet: isTablet,
                                ),
                              ),
                            ].separatedBy(CustomTheme().hGap('lg')),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoCard(
                                  icon: Icons.texture_outlined,
                                  label: 'Gramasi',
                                  value: formatNumber(item['gsm'] ?? 0),
                                  unit: 'GSM',
                                  color: Colors.purple,
                                  isTablet: isTablet,
                                ),
                              ),
                              Expanded(
                                child: _buildInfoCard(
                                  icon: Icons.verified_outlined,
                                  label: 'Berat Grade A',
                                  value: formatNumber(
                                    item['weight_grade_a'] ?? 0,
                                  ),
                                  unit: 'KG',
                                  color: Colors.green,
                                  isTablet: isTablet,
                                ),
                              ),
                            ].separatedBy(CustomTheme().hGap('lg')),
                          ),
                          _buildInfoCard(
                            icon: Icons.scale,
                            label: 'Total Berat',
                            value: formatNumber(
                              item['total_weight'] ?? 0,
                            ),
                            unit: 'KG',
                            color: Colors.teal,
                            isTablet: isTablet,
                          ),
                        ].separatedBy(CustomTheme().vGap('lg')),
                      ),

                    /// ✅ CROSS CUTTING & SEWING
                    if ([
                      'cross_cutting',
                      'sewing',
                    ].contains(widget.processKey))
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${formatNumber(qty ?? 0)} PCS',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: CustomTheme().fontWeight('bold'),
                            ),
                          ),
                        ),
                      ),
                  ].separatedBy(CustomTheme().vGap('lg')),
                ),
              );
            })
            .toList()
            .separatedBy(CustomTheme().vGap('lg')),
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }

  Widget _buildMiniGradeCard({
    required String label,
    required num value,
    required Color color,
    required IconData icon,
    required bool isTablet,
  }) {
    return Container(
      width: isTablet ? 150 : 135,
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: isTablet ? 18 : 16,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: CustomTheme().fontSize('xs'),
              color: Colors.grey[700],
            ),
          ),
          Text(
            '${formatNumber(value)} PCS',
            style: TextStyle(
              fontSize: CustomTheme().fontSize('md'),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ].separatedBy(CustomTheme().vGap('sm')),
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
        'Mei',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Des',
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
      case 'embroidery':
        return data['emb_no'];
      case 'printing':
        return data['print_no'];
      case 'sorting':
        return data['sorting_no'];
      case 'packing':
        return data['packing_no'];
      default:
        return null;
    }
  }
}
