// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/text/thousand_separator_input_formatter.dart';
import 'package:textile_tracking/components/master/theme.dart';

class TextForm extends StatefulWidget {
  final label;
  final bool req;
  final formControl;
  final TextEditingController? controller;
  final Function(String)? handleChange;
  final bool? isNumber;
  final bool isDisabled;
  final validator;
  final inputFormatters;
  final bool isGrade;
  final bool isSorting;
  final initialValue;

  const TextForm({
    super.key,
    this.label,
    this.req = false,
    this.formControl,
    this.controller,
    this.handleChange,
    this.isNumber,
    this.isDisabled = false,
    this.validator,
    this.inputFormatters,
    this.isGrade = false,
    this.isSorting = false,
    this.initialValue,
  });

  @override
  State<TextForm> createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
  bool _isInitialized = false;

  String formatToId(String value) {
    final number = double.tryParse(value.replaceAll(',', '.')) ?? 0;

    final parts = number.toString().split('.');
    final intPart = int.parse(parts[0]);

    final formattedInt = NumberFormat.decimalPattern('id_ID').format(intPart);

    return parts.length > 1 && parts[1] != '0'
        ? '$formattedInt,${parts[1]}'
        : formattedInt;
  }

  String toRaw(String value) {
    return value.replaceAll('.', '').replaceAll(',', '.');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized &&
        widget.controller != null &&
        widget.initialValue != null) {
      if (widget.isNumber == true) {
        widget.controller!.text = formatToId(widget.initialValue.toString());
      } else {
        widget.controller!.text = widget.initialValue.toString();
      }
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.req == true ? widget.validator : null,
      builder: (FormFieldState<String> field) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (field.value == null && widget.controller?.text != null) {
            final raw = widget.isNumber == true
                ? toRaw(widget.controller!.text)
                : widget.controller!.text;

            field.didChange(raw);
          }
        });

        return GroupForm(
          label: widget.label,
          req: widget.req,
          errorText: field.errorText,
          disabled: widget.isDisabled,
          isGrade: widget.isGrade,
          formControl: TextFormField(
            enabled: !widget.isDisabled,
            controller: widget.controller,
            style: TextStyle(
              fontSize: CustomTheme().fontSize('md'),
              color: widget.isDisabled
                  ? Colors.black.withOpacity(0.85)
                  : Colors.black,
            ),
            decoration: CustomTheme()
                .inputDecoration(
                    'Isi ${widget.label}', null, null, widget.isDisabled)
                .copyWith(
                  hintText:
                      widget.isNumber == true ? '0' : 'Isi ${widget.label}',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                ),
            keyboardType: widget.isNumber == true
                ? TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            inputFormatters: widget.isNumber == true
                ? [ThousandsSeparatorInputFormatter()]
                : [],
            onChanged: (value) {
              if (widget.isSorting == true) {
                final rawValue = widget.isNumber == true ? toRaw(value) : value;

                field.didChange(rawValue);
                widget.handleChange?.call(rawValue);
              } else {
                field.didChange(value);
                widget.handleChange?.call(value);
              }
            },
          ),
        );
      },
    );
  }
}
