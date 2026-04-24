import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TextFormNumberID extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String initialValue;
  final Function(String raw) onChanged;
  final bool isDisabled;
  final bool allowDecimal;

  const TextFormNumberID({
    super.key,
    required this.label,
    required this.controller,
    required this.initialValue,
    required this.onChanged,
    this.isDisabled = false,
    this.allowDecimal = false,
  });

  @override
  State<TextFormNumberID> createState() => _TextFormNumberIDState();
}

class _TextFormNumberIDState extends State<TextFormNumberID> {
  late FocusNode _focusNode;
  bool _isFormatting = false;

  String format(String value) {
    if (value.isEmpty) return '0';

    final parts = value.split(',');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? parts[1] : '';

    final formattedInt =
        NumberFormat.decimalPattern('id_ID').format(int.tryParse(intPart) ?? 0);

    if (decPart.isNotEmpty) {
      return '$formattedInt,$decPart';
    }

    return formattedInt;
  }

  String toRaw(String value) {
    return value.replaceAll('.', '');
  }

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    // set initial
    widget.controller.text = format(widget.initialValue);

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        final raw = toRaw(widget.controller.text);
        widget.controller.text = format(raw);
      }
    });
  }

  void _onChanged(String value) {
    if (_isFormatting) return;

    _isFormatting = true;

    // ambil hanya angka & koma
    String clean = value.replaceAll(RegExp(r'[^0-9,]'), '');

    // hanya boleh 1 koma
    if (clean.contains(',')) {
      final parts = clean.split(',');
      clean = parts[0] + ',' + parts.sublist(1).join();
    }

    // kalau tidak allow decimal → buang koma
    if (!widget.allowDecimal) {
      clean = clean.replaceAll(',', '');
    }

    final raw = toRaw(clean);

    final formatted = format(clean);

    widget.controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );

    widget.onChanged(raw);

    _isFormatting = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      enabled: !widget.isDisabled,
      keyboardType: TextInputType.numberWithOptions(
        decimal: widget.allowDecimal,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: '0',
      ),
      onChanged: _onChanged,
    );
  }
}
