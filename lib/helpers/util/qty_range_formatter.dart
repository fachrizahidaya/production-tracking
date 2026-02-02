import 'package:flutter/services.dart';

class QtyRangeFormatter extends TextInputFormatter {
  final double Function() getBaseQty;

  QtyRangeFormatter({required this.getBaseQty});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final value = double.tryParse(newValue.text.replaceAll(',', ''));

    if (value == null) return newValue;

    final baseQty = getBaseQty();

    if (baseQty <= 0) return newValue;

    final min = baseQty * 0.9;
    final max = baseQty * 1.1;

    if (value < min || value > max) {
      return oldValue;
    }

    return newValue;
  }
}
