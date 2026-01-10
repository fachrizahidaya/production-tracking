import 'package:easy_localization/easy_localization.dart';

String formatDateSafe(String? dateString) {
  if (dateString == null || dateString.isEmpty) return "-";

  try {
    // Try normal ISO 8601
    final parsed = DateTime.tryParse(dateString);
    if (parsed != null) {
      return DateFormat("dd MMM yyyy HH:mm").format(parsed);
    }

    // Try common alternate formats (e.g. "2025-10-07 09:00:00")
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

    // If all parsing fails, just return the raw string
    return dateString;
  } catch (_) {
    return "-";
  }
}
