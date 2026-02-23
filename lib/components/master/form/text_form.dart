// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/text/thousand_separator_input_formatter.dart';
import 'package:textile_tracking/components/master/theme.dart';

class TextForm extends StatelessWidget {
  final label;
  final bool req;
  final formControl;
  final controller;
  final handleChange;
  final isNumber;
  final isDisabled;
  final validator;
  final inputFormatters;

  const TextForm(
      {super.key,
      this.label,
      this.req = false,
      this.formControl,
      this.controller,
      this.handleChange,
      this.isNumber,
      this.isDisabled = false,
      this.validator,
      this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: req == true ? validator : null,
      builder: (FormFieldState<String> field) {
        return GroupForm(
          label: label,
          req: req,
          errorText: field.errorText,
          disabled: isDisabled,
          formControl: TextFormField(
            enabled: !isDisabled,
            controller: controller,
            style: TextStyle(
              fontSize: CustomTheme().fontSize('md'),
              color: isDisabled ? Colors.black.withOpacity(0.85) : Colors.black,
            ),
            decoration: CustomTheme()
                .inputDecoration('Isi $label', null, null, isDisabled)
                .copyWith(
                  hintText: 'Isi $label',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18, // 👈 increase this
                    horizontal: 12,
                  ),
                ),
            keyboardType: isNumber == true
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            inputFormatters:
                isNumber == true ? [ThousandsSeparatorInputFormatter()] : [],
            onChanged: (value) {
              final rawValue = value.replaceAll(',', '');

              field.didChange(rawValue);

              handleChange(rawValue);
            },
          ),
        );
      },
    );
  }
}
