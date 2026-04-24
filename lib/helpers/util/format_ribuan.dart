import 'package:easy_localization/easy_localization.dart';

final NumberFormat formatter = NumberFormat("#,##0.00", "en_US");

String formatNumber(String value) {
  if (value.isEmpty) return '';

  // Bersihkan semua kecuali angka & titik
  String clean = value.replaceAll(RegExp(r'[^0-9.]'), '');

  // Handle multiple dots (biar tidak error)
  int dotCount = '.'.allMatches(clean).length;
  if (dotCount > 1) {
    clean = clean.replaceFirst('.', '');
  }

  final number = double.tryParse(clean);
  if (number == null) return '';

  return formatter.format(number);
}

String cleanNumber(String value) {
  return value.replaceAll(',', '');
}
