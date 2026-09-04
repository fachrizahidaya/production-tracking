import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/models/report/production_summary.dart';
import 'package:http/http.dart' as http;
import 'package:textile_tracking/models/report/sorting_result.dart';

class ReportService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<ProductionSummary> getProductionSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final startDateString = _formatDate(startDate!);
    final endDateString = _formatDate(endDate!);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final uri = Uri.parse(
      '$baseUrl/report/production/summary',
    ).replace(
      queryParameters: {
        'start_date': startDateString,
        'end_date': endDateString
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProductionSummary.fromJson(data);
    }

    throw Exception('Failed to load production summary : '
        '${response.statusCode} ${response.body}');
  }

  Future<SortingResult> getSortingResult(
      {DateTime? startDate,
      DateTime? endDate,
      String? sort,
      int page = 1,
      int perPage = 20,
      String? search}) async {
    final startDateString = _formatDate(startDate!);
    final endDateString = _formatDate(endDate!);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final uri = Uri.parse(
      '$baseUrl/report/production/sorting-result',
    ).replace(
      queryParameters: {
        'start_date': startDateString,
        'end_date': endDateString,
        'sort': sort,
        'page': page.toString(),
        'per_page': perPage.toString(),
        'search': search
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SortingResult.fromJson(data);
    }

    throw Exception('Failed to load production summary : '
        '${response.statusCode} ${response.body}');
  }
}
