import 'package:flutter/services.dart';

class RangeFormatter extends TextInputFormatter {
  final min;
  final max;

  RangeFormatter({
    required this.min,
    required this.max,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final value = double.tryParse(newValue.text);
    if (value == null) return oldValue;

    if (value < min || value > max) {
      // ❌ TOLAK INPUT → KEMBALIKAN VALUE LAMA
      return oldValue;
    }

    return newValue;
  }
}
