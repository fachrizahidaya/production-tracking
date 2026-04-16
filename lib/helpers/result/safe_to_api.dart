String? safeToApi(String? value) {
  if (value == null || value.trim().isEmpty) return '0';
  return value.replaceAll('.', '').replaceAll(',', '.');
}
