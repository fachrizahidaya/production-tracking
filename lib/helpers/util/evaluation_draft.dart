import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class EvaluationDraft {
  static String _key(String type, dynamic id) =>
      'evaluation_draft_${type}_${id ?? ''}';

  static Future<Map<String, dynamic>?> load(String type, dynamic id) async {
    if (id == null || id.toString().trim().isEmpty) return null;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(type, id));
    if (raw == null || raw.trim().isEmpty) return null;
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return null;
    return Map<String, dynamic>.from(decoded);
  }

  static Future<void> save(
    String type,
    dynamic id,
    Map<String, dynamic> data,
  ) async {
    if (id == null || id.toString().trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(type, id), jsonEncode(data));
  }

  static Future<void> clear(String type, dynamic id) async {
    if (id == null || id.toString().trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(type, id));
  }
}
