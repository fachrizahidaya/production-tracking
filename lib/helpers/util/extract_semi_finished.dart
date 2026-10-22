String extractVariantCode(String itemCode) {
  final parts = itemCode.split('-');

  if (parts.length < 2) return '';

  final match = RegExp(r'^(\d{2})(?=[A-Za-z])').firstMatch(parts[1]);

  return match?.group(1) ?? '';
}

Map<String, List<String>> extractSemiFinishedParams(
  List<dynamic> items,
) {
  final List<String> baseCodes = [];
  final List<String> colorCodes = [];
  final List<String> variantCodes = [];

  for (final item in items) {
    final itemCode = item['item_code']?.toString() ?? '';

    if (itemCode.isEmpty) continue;

    final split = itemCode.split('-');

    if (split.length >= 3) {
      baseCodes.add(split.first);
      colorCodes.add(split.last);
      variantCodes.add(extractVariantCode(itemCode));
    }
  }

  return {
    'base_codes': baseCodes,
    'color_codes': colorCodes,
    'variant_codes': variantCodes,
  };
}
