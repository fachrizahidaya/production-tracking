import 'package:easy_localization/easy_localization.dart';

final indoFormat = NumberFormat('#,##0.##', 'id_ID');

String formatIndo(dynamic value) {
  if (value == null || value.toString().isEmpty) return '0';

  final parsed = double.tryParse(
        value.toString().replaceAll('.', '').replaceAll(',', '.'),
      ) ??
      0;

  return indoFormat.format(parsed);
}
