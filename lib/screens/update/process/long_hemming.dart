import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class LongHemmingWeightSection extends StatefulWidget {
  final Map<String, dynamic> form;
  final TextEditingController goodWeightController;
  final TextEditingController defectWeightController;
  final Function(String key, dynamic value) onChange;
  final VoidCallback onRecalculate;

  const LongHemmingWeightSection({
    super.key,
    required this.form,
    required this.goodWeightController,
    required this.defectWeightController,
    required this.onChange,
    required this.onRecalculate,
  });

  @override
  State<LongHemmingWeightSection> createState() =>
      _LongHemmingWeightSectionState();
}

class _LongHemmingWeightSectionState extends State<LongHemmingWeightSection> {
  String? _warning;

  void _handleGoodWeight(String value) {
    final safeValue =
        (value.toString().trim().isEmpty) ? '0' : value.toString();

    widget.onChange('good_weight', safeValue);
    widget.onRecalculate();

    _validate();
  }

  void _handleDefectWeight(String value) {
    final safeValue =
        (value.toString().trim().isEmpty) ? '0' : value.toString();

    widget.onChange('bs_weight', safeValue);
    widget.onRecalculate();

    _validate();
  }

  void _validate() {
    final good = double.tryParse(widget.goodWeightController.text) ?? 0;
    final defect = double.tryParse(widget.defectWeightController.text) ?? 0;

    setState(() {
      if (good < 0 || defect < 0) {
        _warning = 'Berat tidak boleh minus';
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
          title: 'Berat',
          icon: Icons.scale_outlined,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextForm(
                      label: 'Berat Bagus (KG)',
                      initialValue:
                          widget.form['good_weight']?.toString() ?? '0',
                      req: false,
                      isNumber: true,
                      isSorting: true,
                      controller: widget.goodWeightController,
                      handleChange: _handleGoodWeight,
                    ),
                  ),
                  Expanded(
                    child: TextForm(
                      label: 'Berat BS (KG)',
                      req: false,
                      initialValue: widget.form['bs_weight']?.toString() ?? '0',
                      isNumber: true,
                      isSorting: true,
                      controller: widget.defectWeightController,
                      handleChange: _handleDefectWeight,
                    ),
                  ),
                ].separatedBy(CustomTheme().hGap('xl')),
              ),

              /// 🔥 Warning (optional)
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
