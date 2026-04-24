import 'package:intl/intl.dart';

class NumberUtil {
  static final _formatter = NumberFormat("#,##0.##", "id_ID");

  static String format(num value) {
    return _formatter.format(value);
  }

  static double parse(String value) {
    return double.tryParse(
          value.replaceAll('.', '').replaceAll(',', '.'),
        ) ??
        0;
  }

  static int parseInt(String value) {
    return int.tryParse(
          value.replaceAll('.', '').replaceAll(',', ''),
        ) ??
        0;
  }
}
