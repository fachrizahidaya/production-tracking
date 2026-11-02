import 'dart:convert';

import 'package:textile_tracking/screens/env_config.dart';
import 'package:textile_tracking/screens/http_client.dart';

class BaseService {
  static Uri _buildUri(String endpoint, [Map<String, dynamic>? params]) {
    final cleanEndpoint =
        endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    final queryParameters = params
        ?.map((key, value) => MapEntry(key, value?.toString()))
      ?..removeWhere((key, value) => value == null || value.isEmpty);

    return Uri.parse('${EnvConfig.apiUrl}/$cleanEndpoint').replace(
      queryParameters: queryParameters == null || queryParameters.isEmpty
          ? null
          : queryParameters,
    );
  }

  static dynamic _decode(String body) {
    if (body.isEmpty) return null;
    return jsonDecode(body);
  }

  static Map<String, dynamic> _success(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      return {
        'success': true,
        'data': decoded['data'] ?? decoded,
        'message': decoded['message'],
        'meta': decoded['meta'],
      };
    }

    return {
      'success': true,
      'data': decoded,
    };
  }

  static Map<String, dynamic> _failure(dynamic decoded, [String? fallback]) {
    if (decoded is Map<String, dynamic>) {
      return {
        'success': false,
        'message': decoded['message'] ?? fallback ?? 'Network error',
        'errors': decoded['errors'],
      };
    }

    return {
      'success': false,
      'message': fallback ?? 'Network error',
    };
  }

  static Map<String, dynamic> _handleResponse(response) {
    final decoded = _decode(response.body);
    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;
    return isSuccess ? _success(decoded) : _failure(decoded);
  }

  static Future<Map<String, dynamic>> getPagination(
    String endpoint,
    Map<String, dynamic>? params,
  ) async {
    try {
      final url = _buildUri(endpoint, params);
      final response = await HttpClient.get(url);

      final result = _handleResponse(response);
      if (result['success'] == true) {
        final data = result['data'];
        if (data is Map<String, dynamic> && data['data'] != null) {
          return {
            ...result,
            'data': data['data'],
            'pagination': {
              'current_page': data['current_page'],
              'last_page': data['last_page'],
              'per_page': data['per_page'],
              'total': data['total'],
            },
          };
        }
      }

      return result;
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getMethod(
    String endpoint,
    Map<String, dynamic>? params,
  ) async {
    try {
      final url = _buildUri(endpoint, params);
      final response = await HttpClient.get(url);
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> showMethod(
    String endpoint,
    dynamic id,
  ) async {
    return getMethod('$endpoint/${id.toString()}', null);
  }

  static Future<Map<String, dynamic>> postMethod(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final url = _buildUri(endpoint);
      final response = await HttpClient.post(url, body: jsonEncode(data));
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> updateMethod(
    String endpoint,
    dynamic id,
    Map<String, dynamic> data,
  ) async {
    try {
      final url = _buildUri('$endpoint/${id.toString()}');
      final response = await HttpClient.patch(url, body: jsonEncode(data));
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> putMethod(
    String endpoint,
    dynamic id,
    Map<String, dynamic> data,
  ) async {
    try {
      final url = _buildUri('$endpoint/${id.toString()}');
      final response = await HttpClient.put(url, body: jsonEncode(data));
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> deleteMethod(
    String endpoint,
    dynamic id,
  ) async {
    try {
      final url = _buildUri('$endpoint/${id.toString()}');
      final response = await HttpClient.delete(url);
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
