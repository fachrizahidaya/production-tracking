import 'dart:convert';

import 'package:textile_tracking/screens/base_service.dart';
import 'package:textile_tracking/screens/env_config.dart';
import 'package:textile_tracking/screens/http_client.dart';

class WarpingService {
  static const String endpoint = 'warping';

  static Future<Map<String, dynamic>> getOrder(
    String orderId,
  ) async {
    try {
      final url = Uri.parse(
        '${EnvConfig.apiUrl}/$endpoint/items/$orderId',
      );

      final response = await HttpClient.get(
        url,
        headers: await EnvConfig.apiHeader(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return {
          'success': true,
          'data': data['data'],
        };
      }

      final errorData = jsonDecode(response.body);

      return {
        'success': false,
        'message': errorData['message'] ?? 'Failed get order',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> retrieve({
    Map<String, dynamic>? params,
  }) {
    return BaseService.getPagination(endpoint, params);
  }

  static Future<Map<String, dynamic>> detail(dynamic id) {
    return BaseService.showMethod(endpoint, id);
  }

  static Future<Map<String, dynamic>> create(Map<String, dynamic> data) {
    return BaseService.postMethod(endpoint, data);
  }

  static Future<Map<String, dynamic>> update(
    dynamic id,
    Map<String, dynamic> data,
  ) {
    return BaseService.updateMethod(endpoint, id, data);
  }

  static Future<Map<String, dynamic>> delete(dynamic id) {
    return BaseService.deleteMethod(endpoint, id);
  }
}
