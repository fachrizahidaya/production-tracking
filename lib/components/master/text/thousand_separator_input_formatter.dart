// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _intFormatter = NumberFormat.decimalPattern('en_US');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    String sanitized = text.replaceAll(RegExp(r'[^0-9.]'), '');

    if ('.'.allMatches(sanitized).length > 1) {
      return oldValue;
    }

    if (sanitized.endsWith('.') &&
        double.tryParse(sanitized.substring(0, sanitized.length - 1)) != null) {
      return newValue;
    }

    if (double.tryParse(sanitized) == null) {
      return oldValue;
    }

    final parts = sanitized.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';

    String formattedInt = integerPart.isEmpty
        ? '0'
        : _intFormatter.format(int.parse(integerPart));

    final formattedText =
        decimalPart.isNotEmpty ? '$formattedInt.$decimalPart' : formattedInt;

    int offset =
        formattedText.length - (oldValue.text.length - oldValue.selection.end);

    if (offset < 0) offset = 0;
    if (offset > formattedText.length) offset = formattedText.length;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
