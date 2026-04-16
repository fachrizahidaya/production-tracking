// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _intFormatter = NumberFormat.decimalPattern('id_ID');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    if (text.isEmpty) return newValue;

    // ✅ Handle user lagi ngetik koma (desimal)
    if (text.endsWith(',')) {
      final numericPart = text
          .substring(0, text.length - 1)
          .replaceAll('.', '')
          .replaceAll(',', '.');

      if (numericPart.isEmpty) {
        return newValue;
      }

      if (double.tryParse(numericPart) != null) {
        final formattedInt =
            _intFormatter.format(int.parse(numericPart.split('.')[0]));

        final result = '$formattedInt,';

        return TextEditingValue(
          text: result,
          selection: TextSelection.collapsed(offset: result.length),
        );
      }
    }

    // Normalisasi
    String sanitized = text.replaceAll('.', '').replaceAll(',', '.');

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
        decimalPart.isNotEmpty ? '$formattedInt,$decimalPart' : formattedInt;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
