import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class PackingSection extends StatefulWidget {
  final Map<String, dynamic> form;
  final Map<String, dynamic> processData;

  final TextEditingController packingQty;
  final TextEditingController weightDozen;
  final TextEditingController gsm;
  final TextEditingController weightGradeA;
  final TextEditingController totalWeight;

  final String? qtyWarning;

  final Function(String key, String value) onChange;
  final Function(String value) validateQty;
  final Function(double value) calculateGsm;
  final Function(double value) calculateBeratA;
  final Function(double value) calculateTotalBerat;

  final Widget Function()? buildSortingQty;

  const PackingSection({
    super.key,
    required this.form,
    required this.processData,
    required this.packingQty,
    required this.weightDozen,
    required this.gsm,
    required this.weightGradeA,
    required this.totalWeight,
    required this.onChange,
    required this.validateQty,
    required this.calculateGsm,
    required this.calculateBeratA,
    required this.calculateTotalBerat,
    this.qtyWarning,
    this.buildSortingQty,
  });

  @override
  State<PackingSection> createState() => _PackingSectionState();
}

class _PackingSectionState extends State<PackingSection> {
  double _parseInput(String value) {
    return double.tryParse(
          value.replaceAll('.', '').replaceAll(',', '.'),
        ) ??
        0;
  }

  void _handleQtyChange(String value) {
    final safeValue = value.trim().isEmpty ? '0' : value;

    widget.onChange('qty', safeValue);

    final input = _parseInput(widget.weightDozen.text);

    if (input > 0) {
      widget.calculateBeratA(input);
    }

    widget.validateQty(safeValue);

    setState(() {});
  }

  void _handleWeightDozenChange(String value) {
    final safeValue = value.trim().isEmpty ? '0' : value;

    widget.onChange('weight_per_dozen', safeValue);

    final input = _parseInput(value);

    widget.calculateGsm(input);
    widget.calculateBeratA(input);
    widget.calculateTotalBerat(input);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// =========================
        /// RINCIAN HASIL SORTIR
        /// =========================
        TemplateCard(
          title: 'Rincian Hasil Sortir',
          icon: Icons.sort_outlined,
          child: _buildSortingQty(),
        ),

        /// =========================
        /// INFORMASI PACKING
        /// =========================
        TemplateCard(
          title: 'Informasi Packing',
          icon: Icons.layers_outlined,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOTAL PACKING
              Expanded(
                child: Column(
                  children: [
                    TextForm(
                      label: 'Total Packing (PCS)',
                      req: true,
                      isNumber: true,
                      initialValue:
                          widget.processData['qty']?.toString() ?? '0',
                      controller: widget.packingQty,
                      handleChange: _handleQtyChange,
                    ),
                    if (widget.qtyWarning != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          widget.qtyWarning!,
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              /// BERAT LUSIN
              Expanded(
                child: TextForm(
                  label: 'Berat 1 Lusin (KG)',
                  req: true,
                  isNumber: true,
                  isSorting: true,
                  initialValue:
                      widget.form['weight_per_dozen']?.toString() ?? '0',
                  controller: widget.weightDozen,
                  handleChange: _handleWeightDozenChange,
                ),
              ),
            ].separatedBy(CustomTheme().hGap('xl')),
          ),
        ),

        /// =========================
        /// HASIL PERHITUNGAN
        /// =========================
        TemplateCard(
          title: 'Gramasi & Total Berat',
          icon: Icons.scale_outlined,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextForm(
                  label: 'Gramasi',
                  isDisabled: true,
                  controller: widget.gsm,
                ),
              ),
              Expanded(
                child: TextForm(
                  label: 'Berat Grade A (KG)',
                  isDisabled: true,
                  controller: widget.weightGradeA,
                ),
              ),
              Expanded(
                child: TextForm(
                  label: 'Total Berat Keseluruhan (KG)',
                  isDisabled: true,
                  controller: widget.totalWeight,
                ),
              ),
            ].separatedBy(CustomTheme().hGap('xl')),
          ),
        ),
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }

  Widget _buildSortingQty() {
    final gradesList = widget.processData['sorting']?['grades'] ?? [];

    double getTotalAdditionalProcess() {
      final data = widget.processData['sorting'];

      if (data == null) return 0;

      final rework = double.tryParse(
            data['rework_long_hemming']?.toString() ?? '0',
          ) ??
          0;

      final spraying = double.tryParse(
            data['spraying']?.toString() ?? '0',
          ) ??
          0;

      final combing = double.tryParse(
            data['combing']?.toString() ?? '0',
          ) ??
          0;

      return rework + spraying + combing;
    }

    final total = getTotalAdditionalProcess();

    // Calculate total quantity
    int totalQty = 0;
    for (var grade in gradesList) {
      final qty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
      totalQty += qty;
    }

    final grandTotal = totalQty + total;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Loop through grades
        ...gradesList.asMap().entries.map((entry) {
          final grade = entry.value;
          final gradeName = grade['item_grade']['code']?.toString() ?? '-';
          final gradeQty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
          final gradeUnit = grade['unit']?['code']?.toString() ?? '';

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8), // 👈 gap
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grade $gradeName',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: CustomTheme().fontWeight('semibold'),
                      ),
                    ),
                    Text(
                      '${formatNumber(gradeQty.toString())} $gradeUnit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: CustomTheme().fontWeight('bold'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perbaikan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: CustomTheme().fontWeight('semibold'),
                  ),
                ),
                Text(
                  '${formatNumber(total.toString())} PCS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: CustomTheme().fontWeight('bold'),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16),
        // Total
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: CustomTheme().fontWeight('bold'),
                  ),
                ),
                Text(
                  '${formatNumber(grandTotal.toStringAsFixed(0))} ${gradesList.isNotEmpty ? gradesList[0]['unit']['code']?.toString() ?? '' : ''}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: CustomTheme().fontWeight('bold'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
