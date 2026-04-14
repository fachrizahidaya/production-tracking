// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/text/thousand_separator_input_formatter.dart';
import 'package:textile_tracking/components/master/theme.dart';

class TextForm extends StatefulWidget {
  final String? label;
  final bool req;
  final formControl;
  final TextEditingController? controller;
  final Function(String)? handleChange;
  final bool? isNumber;
  final bool isDisabled;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool isGrade;
  final String currencySymbol;

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
    this.currencySymbol = 'Rp',
  });

  @override
  State<TextForm> createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
  late TextEditingController _controller;
  final NumberFormat _formatter = NumberFormat('#,##0', 'id_ID');

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();

    if (widget.isNumber == true && _controller.text.isNotEmpty) {
      _controller.text = _formatCurrency(_controller.text);
    }
  }

  String _formatCurrency(String value) {
    String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) return '';

    final number = int.parse(digitsOnly);
    return _formatter.format(number);
  }

  String _getRawValue(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.req ? widget.validator : null,
      builder: (FormFieldState<String> field) {
        return GroupForm(
          label: widget.label,
          req: widget.req,
          errorText: field.errorText,
          disabled: widget.isDisabled,
          isGrade: widget.isGrade,
          formControl: TextFormField(
            enabled: !widget.isDisabled,
            controller: _controller,
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
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  prefixIcon: widget.isNumber == true
                      ? Padding(
                          padding: const EdgeInsets.only(left: 12, right: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.currencySymbol,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: widget.isDisabled
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
            keyboardType: widget.isNumber == true
                ? const TextInputType.numberWithOptions(decimal: false)
                : TextInputType.text,
            inputFormatters: widget.isNumber == true
                ? [FilteringTextInputFormatter.digitsOnly]
                : widget.inputFormatters,
            onChanged: (value) {
              if (widget.isNumber == true) {
                final formatted = _formatCurrency(value);

                _controller.value = TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );

                final rawValue = _getRawValue(formatted);

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
