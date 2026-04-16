import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Formatter untuk currency Indonesia dengan format: 1.234.567,89
/// Ribuan separator: . (titik)
/// Desimal separator: , (koma)
class IndonesianCurrencyInputFormatter extends TextInputFormatter {
  final int decimalPlaces;

  IndonesianCurrencyInputFormatter({this.decimalPlaces = 0});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    // Extract only digits
    String digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) {
      return TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Split into integer and decimal parts (if decimalPlaces > 0)
    String integerPart, decimalPart = '';

    if (decimalPlaces > 0 && digitsOnly.length > decimalPlaces) {
      integerPart = digitsOnly.substring(0, digitsOnly.length - decimalPlaces);
      decimalPart = digitsOnly.substring(digitsOnly.length - decimalPlaces);
    } else if (decimalPlaces > 0 && digitsOnly.length <= decimalPlaces) {
      integerPart = '0';
      decimalPart = digitsOnly.padLeft(decimalPlaces, '0');
    } else {
      integerPart = digitsOnly;
    }

    // Format integer part with thousand separator (.)
    final numberFormatter = NumberFormat('#,##0', 'id_ID');
    String formattedInteger =
        numberFormatter.format(int.parse(integerPart)).replaceAll(',', '.');

    // Combine formatted text
    String formattedText = formattedInteger;
    if (decimalPlaces > 0 && decimalPart.isNotEmpty) {
      formattedText = '$formattedInteger,$decimalPart';
    }

    // Calculate cursor position
    int offset = formattedText.length;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
