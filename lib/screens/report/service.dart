import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/models/report/production_summary.dart';
import 'package:http/http.dart' as http;
import 'package:textile_tracking/models/report/production_trend.dart';
import 'package:textile_tracking/models/report/rework_comparison.dart';
import 'package:textile_tracking/models/report/sorting_result.dart';
import 'package:textile_tracking/models/report/spk_list.dart';
import 'package:textile_tracking/models/report/spk_summary.dart';
import 'package:textile_tracking/models/report/top_bs.dart';
import 'package:textile_tracking/models/report/wo_list.dart';

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

    throw Exception('Failed to load sorting result : '
        '${response.statusCode} ${response.body}');
  }

  Future<TopBs> getTopBs(
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
      '$baseUrl/report/production/top-bs-wo',
    ).replace(
      queryParameters: {
        'start_date': startDateString,
        'end_date': endDateString,
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
      return TopBs.fromJson(data);
    }

    throw Exception('Failed to load top BS : '
        '${response.statusCode} ${response.body}');
  }

  Future<SpkSummary> getSpkSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final startDateString = _formatDate(startDate!);
    final endDateString = _formatDate(endDate!);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final uri = Uri.parse(
      '$baseUrl/report/production/spk-summary',
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
      return SpkSummary.fromJson(data);
    }

    throw Exception('Failed to load spk summary : '
        '${response.statusCode} ${response.body}');
  }

  Future<ProductionTrend> getProductionTrend(
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
      '$baseUrl/report/production/production-trend',
    ).replace(
      queryParameters: {
        'start_date': startDateString,
        'end_date': endDateString,
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
      return ProductionTrend.fromJson(data);
    }

    throw Exception('Failed to load production trend : '
        '${response.statusCode} ${response.body}');
  }

  Future<ReworkComparison> getReworkComparison(
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
      '$baseUrl/report/production/rework-comparison',
    ).replace(
      queryParameters: {
        'start_date': startDateString,
        'end_date': endDateString,
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
      return ReworkComparison.fromJson(data);
    }

    throw Exception('Failed to load rework comparison : '
        '${response.statusCode} ${response.body}');
  }

  Future<WoList> getWoList(
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
      '$baseUrl/report/production/list',
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
      return WoList.fromJson(data);
    }

    throw Exception('Failed to load sorting result : '
        '${response.statusCode} ${response.body}');
  }

  Future<SpkList> getSpkList(
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
      '$baseUrl/report/production/spk-list',
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
      return SpkList.fromJson(data);
    }

    throw Exception('Failed to load sorting result : '
        '${response.statusCode} ${response.body}');
  }
}
