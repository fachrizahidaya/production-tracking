import 'package:flutter/services.dart';

class RangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  RangeFormatter({
    required this.min,
    required this.max,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow clearing the field
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final value = double.tryParse(newValue.text);

    // Block non-numeric input
    if (value == null) {
      return oldValue;
    }

    // 🚫 Block immediately if out of range
    if (value < min || value > max) {
      return oldValue;
    }

    return newValue;
  }
}
