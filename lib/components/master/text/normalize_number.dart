String normalizeNumber(String value) {
  if (value.isEmpty) return '0';

  return value
      .replaceAll('.', '') // hapus ribuan
      .replaceAll(',', '.'); // ubah desimal
}
