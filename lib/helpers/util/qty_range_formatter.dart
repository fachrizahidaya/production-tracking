import 'package:flutter/services.dart';

class QtyRangeFormatter extends TextInputFormatter {
  final double Function() getBaseQty;

  QtyRangeFormatter({required this.getBaseQty});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // allow empty (backspace)
    if (newValue.text.isEmpty) return newValue;

    final value = double.tryParse(newValue.text.replaceAll(',', ''));

    // allow non-number while typing
    if (value == null) return newValue;

    final baseQty = getBaseQty();

    // 🔑 KEY FIX: do NOT restrict if base not ready
    if (baseQty <= 0) return newValue;

    final min = baseQty * 0.9;
    final max = baseQty * 1.1;

    if (value < min || value > max) {
      // reject change
      return oldValue;
    }

    return newValue;
  }
}
