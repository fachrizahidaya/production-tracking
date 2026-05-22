Map<String, List<String>> extractSemiFinishedParams(
  List<dynamic> items,
) {
  final List<String> baseCodes = [];
  final List<String> colorCodes = [];

  for (final item in items) {
    final itemCode = item['item_code']?.toString() ?? '';

    if (itemCode.isEmpty) continue;

    final split = itemCode.split('-');

    if (split.length >= 3) {
      baseCodes.add(split.first);
      colorCodes.add(split.last);
    }
  }

  return {
    'base_codes': baseCodes,
    'color_codes': colorCodes,
  };
}
