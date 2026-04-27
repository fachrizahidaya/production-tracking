import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class PackingEditSection extends StatefulWidget {
  final Map form;

  final TextEditingController packingQty;
  final TextEditingController weightPerDozen;
  final TextEditingController gsm;
  final TextEditingController weightGradeA;
  final TextEditingController totalWeight;

  final Function(String, dynamic) onChange;

  final Function calculateGsm;
  final Function calculateBeratA;
  final Function calculateTotalBerat;

  final buildSortingQty;

  final woData;

  const PackingEditSection(
      {super.key,
      required this.form,
      required this.packingQty,
      required this.weightPerDozen,
      required this.gsm,
      required this.weightGradeA,
      required this.totalWeight,
      required this.onChange,
      required this.calculateGsm,
      required this.calculateBeratA,
      required this.calculateTotalBerat,
      this.buildSortingQty,
      this.woData});

  @override
  State<PackingEditSection> createState() => _PackingEditSectionState();
}

class _PackingEditSectionState extends State<PackingEditSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// ✅ HASIL SORTIR
        TemplateCard(
          title: 'Rincian Hasil Sortir',
          icon: Icons.sort_outlined,
          child: _buildSortingQty(),
        ),

        /// ✅ PACKING INPUT
        TemplateCard(
          title: 'Packing',
          icon: Icons.layers_outlined,
          child: Row(
            children: [
              Expanded(
                child: TextForm(
                  label: 'Total Packing',
                  controller: widget.packingQty,
                  initialValue: widget.form['qty']?.toString() ?? '0',
                  handleChange: (val) {
                    widget.onChange('qty', val);
                    setState(() {
                      widget.calculateBeratA();
                    });
                  },
                ),
              ),
              Expanded(
                child: TextForm(
                  label: 'Berat / Lusin',
                  controller: widget.weightPerDozen,
                  initialValue:
                      widget.form['weight_per_dozen']?.toString() ?? '0',
                  handleChange: (val) {
                    widget.onChange('weight_per_dozen', val);

                    setState(() {
                      widget.calculateGsm();
                      widget.calculateBeratA();
                      widget.calculateTotalBerat();
                    });
                  },
                ),
              ),
            ].separatedBy(CustomTheme().hGap('xl')),
          ),
        ),

        /// ✅ RESULT
        TemplateCard(
          title: 'Gramasi & Total',
          icon: Icons.scale_outlined,
          child: Row(
            children: [
              _readonly('GSM', widget.gsm),
              _readonly('Berat A', widget.weightGradeA),
              _readonly('Total', widget.totalWeight),
            ].separatedBy(CustomTheme().hGap('xl')),
          ),
        ),
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }

  Widget _readonly(String label, TextEditingController controller) {
    return Expanded(
      child: TextForm(
        label: label,
        isDisabled: true,
        controller: controller,
      ),
    );
  }

  Widget _buildSortingQty() {
    final gradesList =
        widget.woData['processes'][10]['data'][0]['grades'] ?? [];

    double getTotalAdditionalProcess() {
      final data = widget.woData['processes']?[10]?['data']?[0];

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
          final gradeName = grade['grade']?.toString() ?? '-';
          final gradeQty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
          final gradeUnit = grade['unit_code']?.toString() ?? '';

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
                  'Total Perbaikan',
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
                  '${formatNumber(grandTotal.toStringAsFixed(0))} ${gradesList.isNotEmpty ? gradesList[0]['unit_code']?.toString() ?? '' : ''}',
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
