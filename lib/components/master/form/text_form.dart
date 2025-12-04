import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/thousand_separator_input_formatter.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class TextForm extends StatelessWidget {
  final label;
  final bool req;
  final formControl;
  final controller;
  final handleChange;
  final isNumber;
  final isDisabled;

  const TextForm(
      {super.key,
      this.label,
      this.req = false,
      this.formControl,
      this.controller,
      this.handleChange,
      this.isNumber,
      this.isDisabled = false});

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
                fontSize: 14,
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
          enabled: isDisabled == true ? false : true,
          controller: controller,
          style: TextStyle(fontSize: 14),
          decoration:
              CustomTheme().inputDecoration().copyWith(hintText: 'Isi $label'),
          keyboardType:
              isNumber == true ? TextInputType.number : TextInputType.text,
          inputFormatters:
              isNumber == true ? [ThousandsSeparatorInputFormatter()] : [],
          onChanged: (value) {
            String rawValue = value.replaceAll(',', '');
            handleChange(rawValue);
          },
        )
      ].separatedBy(SizedBox(
        height: 8,
      )),
    );
  }
}
