import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/models/report/production_summary.dart';
import 'package:http/http.dart' as http;
import 'package:textile_tracking/models/report/production_trend.dart';
import 'package:textile_tracking/models/report/rework.dart';
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

  Future<ReworkList> getReworkList(
      {DateTime? startDate,
      DateTime? endDate,
      String? sort,
      int page = 1,
      int perPage = 20,
      String? search,
      String? status}) async {
    final startDateString = _formatDate(startDate!);
    final endDateString = _formatDate(endDate!);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final uri = Uri.parse(
      '$baseUrl/dyeing-rework-evaluations',
    ).replace(
      queryParameters: {
        'start_date': startDateString,
        'end_date': endDateString,
        'sort': sort,
        'page': page.toString(),
        'per_page': perPage.toString(),
        'search': search,
        'status': status,
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
      return ReworkList.fromJson(data);
    }

    throw Exception('Failed to load sorting result : '
        '${response.statusCode} ${response.body}');
  }

  Future<Map<String, dynamic>> getReworkDetail(dynamic id) async {
    if (id == null || id.toString().trim().isEmpty) {
      throw Exception('ID rework tidak ditemukan');
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/dyeing-rework-evaluations/$id');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load rework detail: '
          '${response.statusCode} ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    final data = decoded is Map && decoded['data'] is Map
        ? Map<String, dynamic>.from(decoded['data'])
        : Map<String, dynamic>.from(decoded as Map);
    final workOrder = _asMap(data['work_order']);
    final dyeing = _asMap(data['dyeing']);
    final categories = data['rework_categories'] ??
        dyeing['rework_categories'] ??
        data['rework_category'] ??
        '';

    return {
      ...data,
      'id': data['id'] ?? id,
      'reworkNo': _first(data, [
            'reworkNo',
            'rework_no',
            'evaluation_no',
            'rework_evaluation_no',
            'number',
          ]) ??
          id.toString(),
      'status': _first(data, ['status']) ?? '-',
      'woNo': _first(workOrder, ['wo_no', 'number', 'no']) ?? '-',
      'dyeingProcessNo': _first(dyeing, ['dyeing_no', 'no']) ?? '-',
      'startedAt': _first(data, ['started_at', 'created_at']) ?? '-',
      'completedAt': _first(data, ['completed_at', 'finished_at']) ?? '-',
      'qty': _first(data, ['qty', 'quantity']) ??
          _first(dyeing, ['qty', 'quantity']) ??
          '-',
      'semiFinishedProduct': _first(data, [
            'semi_finished_product',
            'semiFinishedProduct',
          ]) ??
          _first(dyeing, ['semi_finished_product', 'name']) ??
          '-',
      'category': _formatReworkCategories(categories),
      'submittedBy': _formatSubmittedBy(data['submitted_by']),
      'reasons': _formatReasons(data['reasons'] ?? data['reason']),
      'reason': _formatDetailValue(data['reasons'] ?? data['reason']),
      'actionPlan': _formatDetailValue(data['action_plan']),
      'preventivePlan': _formatDetailValue(data['preventive_plan']),
    };
  }

  Future<void> updateReworkDetail({
    required dynamic id,
    required List<String> reasons,
    required String actionPlan,
    required String preventivePlan,
  }) async {
    if (id == null || id.toString().trim().isEmpty) {
      throw Exception('ID rework tidak ditemukan');
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/dyeing-rework-evaluations/$id');
    final response = await http.patch(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'reasons': reasons,
        'action_plan': actionPlan,
        'preventive_plan': preventivePlan,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to update rework detail: '
          '${response.statusCode} ${response.body}');
    }
  }

  Future<void> updateReworkReasons({
    required dynamic id,
    required List<String> reasons,
  }) async {
    if (id == null || id.toString().trim().isEmpty) {
      throw Exception('ID rework tidak ditemukan');
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/dyeing-rework-evaluations/$id');
    final response = await http.patch(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'reasons': reasons}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to update rework reasons: '
          '${response.statusCode} ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getReworkReasonOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/dyeing-rework-reason-options');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load rework reason options: '
          '${response.statusCode} ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    final items = decoded is Map ? decoded['data'] : null;
    if (items is! List) return [];

    return items
        .whereType<Map>()
        .map((item) => {
              'value': item['value']?.toString() ?? '',
              'label':
                  item['label']?.toString() ?? item['value']?.toString() ?? '',
            })
        .where((item) => item['value']!.toString().isNotEmpty)
        .toList();
  }

  Future<Map<String, dynamic>> createReworkReasonOption(String label) async {
    final trimmedLabel = label.trim();
    if (trimmedLabel.isEmpty) throw Exception('Alasan tidak boleh kosong');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/dyeing-rework-reason-options');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'label': trimmedLabel}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to create rework reason option: '
          '${response.statusCode} ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    final data = decoded is Map && decoded['data'] is Map
        ? Map<String, dynamic>.from(decoded['data'])
        : <String, dynamic>{};
    return {
      'value': data['value']?.toString() ?? trimmedLabel,
      'label': data['label']?.toString() ?? trimmedLabel,
    };
  }

  Map<String, dynamic> _asMap(dynamic value) {
    return value is Map ? Map<String, dynamic>.from(value) : {};
  }

  dynamic _first(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value != null && value.toString().trim().isNotEmpty) return value;
    }
    return null;
  }

  String _formatReworkCategories(dynamic value) {
    if (value is! List || value.isEmpty) return value?.toString() ?? '-';

    final categories = value.whereType<Map>().toList();
    final repairTypes = {
      'perbaikan_warna',
      'perbaikan_noda',
      'pelemas_ulang',
    };
    final isRepair = categories.isNotEmpty &&
        categories.every(
          (item) => repairTypes.contains(item['type']?.toString()),
        );
    final lines = <String>[];

    if (isRepair) lines.add('Perbaikan');

    for (final item in categories) {
      final label = item['label']?.toString().trim();
      if (label == null || label.isEmpty) continue;

      final methods = item['methods'];
      final methodLabels = methods is List
          ? methods
              .whereType<Map>()
              .map((method) => method['label']?.toString().trim() ?? '')
              .where((method) => method.isNotEmpty)
              .toList()
          : <String>[];

      lines.add(
          methodLabels.isEmpty ? label : '$label: ${methodLabels.join(', ')}');
    }

    return lines.isEmpty ? '-' : lines.join('\n');
  }

  String _formatDetailValue(dynamic value) {
    if (value is List) return value.join(', ');
    return value?.toString() ?? '';
  }

  List<String> _formatReasons(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    if (value == null || value.toString().trim().isEmpty) return [];
    return [value.toString()];
  }

  String _formatSubmittedBy(dynamic value) {
    if (value is Map) {
      return (value['name'] ?? value['full_name'] ?? value['username'] ?? '-')
          .toString();
    }
    return value?.toString() ?? '-';
  }
}
