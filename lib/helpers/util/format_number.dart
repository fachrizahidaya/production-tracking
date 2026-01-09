import 'package:easy_localization/easy_localization.dart';

String formatNumber(dynamic value) {
  if (value == null) return '0';

  final number = value is num ? value : num.tryParse(value.toString()) ?? 0;

  final formatter = NumberFormat('#,##0', 'id_ID');
  return formatter.format(number);
}
