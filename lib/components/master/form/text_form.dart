import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class TextForm extends StatelessWidget {
  final label;
  final bool req;
  final formControl;
  final controller;
  final handleChange;

  const TextForm(
      {super.key,
      this.label,
      this.req = false,
      this.formControl,
      this.controller,
      this.handleChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            if (req)
              Text(
                '*',
                style: TextStyle(
                  color: CustomTheme().colors('danger'),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ].separatedBy(SizedBox(
            width: 8,
          )),
        ),
        TextFormField(
          controller: controller,
          style: TextStyle(fontSize: 16),
          decoration:
              CustomTheme().inputDecoration().copyWith(hintText: 'Isi $label'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            handleChange(value);
          },
        )
      ].separatedBy(SizedBox(
        height: 8,
      )),
    );
  }
}
