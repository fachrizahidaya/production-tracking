import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/thousand_separator_input_formatter.dart';

class TextFormGrade extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String initialValue;
  final Function(String) onChanged;
  final bool isDisabled;

  const TextFormGrade({
    super.key,
    required this.label,
    required this.controller,
    required this.initialValue,
    required this.onChanged,
    this.isDisabled = false,
  });

  @override
  State<TextFormGrade> createState() => _TextFormGradeState();
}

class _TextFormGradeState extends State<TextFormGrade> {
  late FocusNode _focusNode;

  String formatToId(String value) {
    final number = double.tryParse(value) ?? 0;
    return NumberFormat.decimalPattern('id_ID').format(number);
  }

  String toRaw(String value) {
    return value.replaceAll('.', '').replaceAll(',', '');
  }

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    // initial format
    widget.controller.text = formatToId(widget.initialValue);

    // 🔥 HANDLE BLUR (INI KUNCI UTAMA)
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        final raw = toRaw(widget.controller.text);
        final formatted = formatToId(raw);

        widget.controller.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: !widget.isDisabled,
      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: '0',
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 0.5, color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 0.5, color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 0.5, color: Colors.black),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 0.5,
            color: Colors.black,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 0.5, color: Colors.black),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 0.5, color: Colors.black),
        ),
        hintStyle: TextStyle(
          color: widget.isDisabled
              ? Colors.black.withOpacity(0.6)
              : Colors.black38,
          fontWeight: FontWeight.w400,
        ),
      ),
      inputFormatters: [
        ThousandsSeparatorInputFormatter(),
      ],
      onChanged: (value) {
        final raw = toRaw(value);

        widget.onChanged(raw);
      },
    );
  }
}
