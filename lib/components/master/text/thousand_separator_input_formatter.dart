// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.decimalPattern('en_US');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) {
      return TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Format with comma
    String newFormatted = _formatter.format(int.parse(digitsOnly));

    // Calculate cursor position
    int selectionIndex =
        newFormatted.length - (oldValue.text.length - oldValue.selection.end);

    if (selectionIndex < 0) selectionIndex = 0;
    if (selectionIndex > newFormatted.length) {
      selectionIndex = newFormatted.length;
    }

    return TextEditingValue(
      text: newFormatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
