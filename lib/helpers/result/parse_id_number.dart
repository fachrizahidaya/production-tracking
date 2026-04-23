double parseIdNumber(String value) {
  if (value.isEmpty) return 0;

  // detect apakah pakai format indo (ada koma)
  if (value.contains(',')) {
    return double.tryParse(
          value.replaceAll('.', '').replaceAll(',', '.'),
        ) ??
        0;
  }

  // kalau tidak ada koma, anggap sudah standard
  return double.tryParse(value) ?? 0;
}
