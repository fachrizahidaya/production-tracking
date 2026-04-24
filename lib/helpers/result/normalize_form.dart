dynamic normalizeForm(dynamic data) {
  if (data is Map) {
    return data.map((key, value) {
      return MapEntry(key, normalizeForm(value));
    });
  } else if (data is List) {
    return data.map((e) => normalizeForm(e)).toList();
  } else if (data is String) {
    // hanya convert jika angka
    final cleaned = data.replaceAll('.', '').replaceAll(',', '.');
    final parsed = double.tryParse(cleaned);
    return parsed ?? data;
  } else {
    return data;
  }
}
