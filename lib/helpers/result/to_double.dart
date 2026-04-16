double toDouble(dynamic value) {
  if (value == null) return 0;

  final clean = value
      .toString()
      .replaceAll('.', '') // hapus ribuan
      .replaceAll(',', '.'); // decimal Indo → standard

  return double.tryParse(clean) ?? 0;
}
