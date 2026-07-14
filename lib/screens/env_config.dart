import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/screens/storage_service.dart';

class EnvConfig {
  static String get apiUrl {
    final configuredUrl = dotenv.env['API_URL'] ?? dotenv.env['API_URL'] ?? '';
    return configuredUrl.endsWith('/')
        ? configuredUrl.substring(0, configuredUrl.length - 1)
        : configuredUrl;
  }

  static Future<Map<String, String>> apiHeader({
    bool includeContentType = true,
  }) async {
    final token = await StorageService.getToken();
    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (includeContentType) {
      headers['Content-Type'] = 'application/json';
    }

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}
