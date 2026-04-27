import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CuttingSewingQtySection extends StatefulWidget {
  final String label;
  final Map<String, dynamic> form;
  final TextEditingController controller;
  final Function(String key, dynamic value) onChange;

  const CuttingSewingQtySection({
    super.key,
    required this.label,
    required this.form,
    required this.controller,
    required this.onChange,
  });

  @override
  State<CuttingSewingQtySection> createState() =>
      _CuttingSewingQtySectionState();
}

class _CuttingSewingQtySectionState extends State<CuttingSewingQtySection> {
  String? _warning;

  void _handleChange(String value) {
    final safeValue =
        (value.toString().trim().isEmpty) ? '0' : value.toString();

    widget.onChange('item_qty', safeValue);

    /// 🔥 contoh local validation (opsional)
    setState(() {
      final parsed = int.tryParse(safeValue) ?? 0;
      if (parsed < 0) {
        _warning = 'Qty tidak boleh minus';
      } else {
        _warning = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TemplateCard(
          title: 'Qty',
          icon: Icons.numbers_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextForm(
                label: 'Qty Hasil ${widget.label} (PCS)',
                req: false,
                isNumber: true,
                isSorting: true,
                initialValue: widget.form['item_qty']?.toString() ?? '0',
                controller: widget.controller,
                handleChange: _handleChange,
              ),

              /// 🔥 Warning UI (optional tapi sering kepake)
              if (_warning != null)
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _warning!,
                        style: TextStyle(
                          color: CustomTheme().colors('warning'),
                          fontSize: CustomTheme().fontSize('sm'),
                        ),
                      ),
                    ),
                  ],
                ),
            ].separatedBy(CustomTheme().vGap('lg')),
          ),
        ),
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }
}
