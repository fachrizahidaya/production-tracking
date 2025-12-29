class ItemField {
  static dynamic get(dynamic item, String key, {dynamic fallback = '-'}) {
    if (item == null) return fallback;

    try {
      return item.toJson()[key] ?? fallback;
    } catch (_) {
      try {
        return item[key] ?? fallback;
      } catch (_) {
        return fallback;
      }
    }
  }

  static dynamic nested(dynamic item, String key, String subKey,
      {dynamic fallback = '-'}) {
    final nested = get(item, key, fallback: null);

    if (nested is Map && nested[subKey] != null) {
      return nested[subKey];
    }

    return fallback;
  }
}
