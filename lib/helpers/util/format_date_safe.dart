import 'package:easy_localization/easy_localization.dart';

String formatDateSafe(String? dateString) {
  if (dateString == null || dateString.isEmpty) return "-";

  try {
    final parsed = DateTime.tryParse(dateString);
    if (parsed != null) {
      return DateFormat("dd MMM yyyy HH:mm").format(parsed);
    }

    final possibleFormats = [
      DateFormat("yyyy-MM-dd HH.mm.ss"),
      DateFormat("yyyy/MM/dd HH.mm.ss"),
      DateFormat("dd-MM-yyyy HH.mm.ss"),
    ];

    for (var fmt in possibleFormats) {
      try {
        final parsedAlt = fmt.parse(dateString);
        return DateFormat("dd MMM yyyy HH.mm").format(parsedAlt);
      } catch (_) {}
    }

    return dateString;
  } catch (_) {
    return "-";
  }
}
