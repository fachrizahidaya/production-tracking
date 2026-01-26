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
    return FormField(
      validator: validator,
      builder: (FormFieldState<String> field) {
        return GroupForm(
          label: label,
          req: req,
          errorText: field.errorText,
          disabled: isDisabled,
          formControl: TextFormField(
            enabled: isDisabled == true ? false : true,
            controller: controller,
            style: TextStyle(fontSize: CustomTheme().fontSize('md')),
            decoration: CustomTheme().inputDecoration().copyWith(
                  hintText: 'Isi $label',
                ),
            keyboardType:
                isNumber == true ? TextInputType.number : TextInputType.text,
            inputFormatters:
                isNumber == true ? [ThousandsSeparatorInputFormatter()] : [],
            onChanged: (value) {
              String rawValue = value.replaceAll(',', '');
              handleChange(rawValue);
            },
            // validator: req ? validator : null,
          ),
        );
      },
    );
  }
}
