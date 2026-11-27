import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WarpingSection extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController valueController;

  final Map<String, dynamic> form;

  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onValueChange;

  final String extraTitle;

  const WarpingSection({
    super.key,
    required this.controller,
    required this.valueController,
    required this.form,
    this.onChange,
    this.onValueChange,
    required this.extraTitle,
  });

  @override
  Widget build(BuildContext context) {
    return TemplateCard(
      title: 'Benang',
      icon: Icons.join_inner_outlined,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextForm(
              label: 'Qty Benang (KG)',
              controller: controller,
              req: false,
              isNumber: true,
              isSorting: true,
              handleChange: (value) {
                onChange?.call(value);
              },
            ),
          ),
          Expanded(
            child: TextForm(
              label: extraTitle,
              controller: valueController,
              req: false,
              isNumber: true,
              isSorting: true,
              handleChange: (value) {
                onValueChange?.call(value);
              },
            ),
          ),
        ].separatedBy(
          CustomTheme().hGap('xl'),
        ),
      ),
    );
  }
}
