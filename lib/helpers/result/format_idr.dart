// ignore_for_file: deprecated_member_use

String formatIdr(double value) {
  final parts = value.toStringAsFixed(2).split('.');
  final integerPart = parts[0];
  final decimalPart = parts[1];

  final withSeparator = integerPart.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );

  return '$withSeparator,$decimalPart';
}
