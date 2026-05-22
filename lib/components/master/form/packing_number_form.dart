import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PackingNumberForm extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool enabled;

  const PackingNumberForm({
    super.key,
    required this.label,
    required this.controller,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<PackingNumberForm> createState() => _PackingNumberFormState();
}

class _PackingNumberFormState extends State<PackingNumberForm> {
  bool _isUpdating = false;

  String formatId(String value) {
    if (value.isEmpty) return '';

    // simpan hanya angka dan koma
    String clean = value.replaceAll(RegExp(r'[^0-9,]'), '');

    // split decimal
    List<String> parts = clean.split(',');

    // integer part
    String integerPart = parts[0];

    // remove leading zero
    integerPart = integerPart.replaceFirst(RegExp(r'^0+'), '');

    if (integerPart.isEmpty) {
      integerPart = '0';
    }

    // format ribuan
    final number = int.tryParse(integerPart) ?? 0;

    String formatted = NumberFormat(
      '#,###',
      'id_ID',
    ).format(number).replaceAll(',', '.');

    // decimal
    if (parts.length > 1) {
      formatted += ',${parts[1]}';
    }

    return formatted;
  }

  String toRaw(String value) {
    return value
        .replaceAll('.', '') // hapus ribuan
        .replaceAll(',', '.'); // decimal indonesia -> api
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration: InputDecoration(
            hintText: '0',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
          ),
          onChanged: (value) {
            if (_isUpdating) return;

            _isUpdating = true;

            final formatted = formatId(value);

            widget.controller.value = TextEditingValue(
              text: formatted,
              selection: TextSelection.collapsed(
                offset: formatted.length,
              ),
            );

            widget.onChanged?.call(
              toRaw(formatted),
            );

            _isUpdating = false;
          },
        ),
      ],
    );
  }
}
