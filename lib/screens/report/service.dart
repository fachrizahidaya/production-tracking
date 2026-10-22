import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/models/report/production_summary.dart';
import 'package:http/http.dart' as http;
import 'package:textile_tracking/models/report/production_trend.dart';
import 'package:textile_tracking/models/report/bs.dart';
import 'package:textile_tracking/models/report/gsm.dart';
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

    final uri = Uri.parse('$baseUrl/report/production/summary').replace(
      queryParameters: {
        'start_date': startDateString,
        'end_date': endDateString,
      },
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProductionSummary.fromJson(data);
    }

    throw Exception(
      'Failed to load production summary : '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<SortingResult> getSortingResult({
    DateTime? startDate,
    DateTime? endDate,
    String? sort,
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    final startDateString = _formatDate(startDate!);
    final endDateString = _formatDate(endDate!);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final uri = Uri.parse('$baseUrl/report/production/sorting-result').replace(
      queryParameters: {
        'start_date': startDateString,
        'end_date': endDateString,
        'sort': sort,
        'page': page.toString(),
        'per_page': perPage.toString(),
        'search': search,
      },
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SortingResult.fromJson(data);
    }

    throw Exception(
      'Failed to load sorting result : '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<TopBs> getTopBs({
    DateTime? startDate,
    DateTime? endDate,
    String? sort,
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    final startDateString = _formatDate(startDate!);
    final endDateString = _formatDate(endDate!);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final uri = Uri.parse('$baseUrl/report/production/top-bs-wo').replace(
      queryParameters: {
        'start_date': startDateString,
        'end_date': endDateString,
      },
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return TopBs.fromJson(data);
    }

    throw Exception(
      'Failed to load top BS : '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<SpkSummary> getSpkSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final startDateString = _formatDate(startDate!);
    final endDateString = _formatDate(endDate!);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final uri = Uri.parse('$baseUrl/report/production/spk-summary').replace(
      queryParameters: {
        'start_date': startDateString,
        'end_date': endDateString,
      },
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SpkSummary.fromJson(data);
    }

    throw Exception(
      'Failed to load spk summary : '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<ProductionTrend> getProductionTrend({
    DateTime? startDate,
    DateTime? endDate,
    String? sort,
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    final startDateString = _formatDate(startDate!);
    final endDateString = _formatDate(endDate!);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final uri =
        Uri.parse('$baseUrl/report/production/production-trend').replace(
      queryParameters: {
        'start_date': startDateString,
        'end_date': endDateString,
      },
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProductionTrend.fromJson(data);
    }

    throw Exception(
      'Failed to load production trend : '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<ReworkComparison> getReworkComparison({
    DateTime? startDate,
    DateTime? endDate,
    String? sort,
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    final startDateString = _formatDate(startDate!);
    final endDateString = _formatDate(endDate!);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final uri =
        Uri.parse('$baseUrl/report/production/rework-comparison').replace(
      queryParameters: {
        'start_date': startDateString,
        'end_date': endDateString,
      },
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ReworkComparison.fromJson(data);
    }

    throw Exception(
      'Failed to load rework comparison : '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<WoList> getWoList({
    DateTime? startDate,
    DateTime? endDate,
    String? sort,
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    final startDateString = _formatDate(startDate!);
    final endDateString = _formatDate(endDate!);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final uri = Uri.parse('$baseUrl/report/production/list').replace(
      queryParameters: {
        'start_date': startDateString,
        'end_date': endDateString,
        'sort': sort,
        'page': page.toString(),
        'per_page': perPage.toString(),
        'search': search,
      },
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WoList.fromJson(data);
    }

    throw Exception(
      'Failed to load sorting result : '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<SpkList> getSpkList({
    DateTime? startDate,
    DateTime? endDate,
    String? sort,
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    final startDateString = _formatDate(startDate!);
    final endDateString = _formatDate(endDate!);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final uri = Uri.parse('$baseUrl/report/production/spk-list').replace(
      queryParameters: {
        'start_date': startDateString,
        'end_date': endDateString,
        'sort': sort,
        'page': page.toString(),
        'per_page': perPage.toString(),
        'search': search,
      },
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SpkList.fromJson(data);
    }

    throw Exception(
      'Failed to load sorting result : '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<ReworkList> getReworkList({
    DateTime? startDate,
    DateTime? endDate,
    String? sort,
    int page = 1,
    int perPage = 20,
    String? search,
    String? status,
  }) async {
    final startDateString = _formatDate(startDate!);
    final endDateString = _formatDate(endDate!);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final queryParameters = <String, String>{
      'start_date': startDateString,
      'end_date': endDateString,
      'sort': sort ?? '',
      'page': page.toString(),
      'per_page': perPage.toString(),
      'search': search ?? '',
    };
    if (status != null && status.trim().isNotEmpty) {
      queryParameters['status'] = status;
    }

    final uri = Uri.parse('$baseUrl/dyeing-rework-evaluations')
        .replace(queryParameters: queryParameters);

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ReworkList.fromJson(data);
    }

    throw Exception(
      'Failed to load sorting result : '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<int> getReworkPendingCount() async {
    final counts = await getReworkStatusCounts();
    return counts['pending'] ?? 0;
  }

  Future<Map<String, int>> getReworkStatusCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/dyeing-rework-evaluations/summary');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final pending = int.tryParse(data?['pending']?.toString() ?? '') ?? 0;
      final reviewed = int.tryParse(data?['reviewed']?.toString() ?? '') ?? 0;
      final total =
          int.tryParse(data?['total']?.toString() ?? '') ?? pending + reviewed;

      return {'pending': pending, 'reviewed': reviewed, 'all': total};
    }

    throw Exception(
      'Failed to load rework summary: '
      '${response.statusCode} ${response.body}',
    );
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
      throw Exception(
        'Failed to load rework detail: '
        '${response.statusCode} ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);
    final data = decoded is Map && decoded['data'] is Map
        ? Map<String, dynamic>.from(decoded['data'])
        : Map<String, dynamic>.from(decoded as Map);
    final workOrder = _asMap(data['work_order']);
    final dyeing = _asMap(data['dyeing']);
    final item = _resolveMaterialItem(
      data: data,
      workOrder: workOrder,
      fallbackItem: _asMap(data['item']).isNotEmpty
          ? _asMap(data['item'])
          : _asMap(dyeing['item']),
    );
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
      'topMaterialCode':
          _first(item, ['code']) ?? _first(data, ['top_material_code']) ?? '-',
      'topMaterialName':
          _first(item, ['name']) ?? _first(data, ['top_material_name']) ?? '-',
      'startedAt': _first(data, ['started_at', 'created_at']) ?? '-',
      'completedAt': _first(data, ['completed_at', 'finished_at']) ?? '-',
      'qty': _first(data, ['qty', 'quantity']) ??
          _first(dyeing, ['qty', 'quantity']) ??
          '-',
      'semiFinishedProduct':
          _first(data, ['semi_finished_product', 'semiFinishedProduct']) ??
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

  Future<String> updateReworkDetail({
    required dynamic id,
    required List<String> reasons,
    required String actionPlan,
    required String preventivePlan,
    List<Map<String, dynamic>>? attachments,
  }) async {
    if (id == null || id.toString().trim().isEmpty) {
      throw Exception('ID rework tidak ditemukan');
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/dyeing-rework-evaluations/$id');
    final keptIds = (attachments ?? const <Map<String, dynamic>>[])
        .where((item) => item['isNew'] != true && item['id'] != null)
        .map((item) => item['id'])
        .toList();
    final newFiles = (attachments ?? const <Map<String, dynamic>>[])
        .where(
          (item) =>
              item['isNew'] == true &&
              item['path']?.toString().trim().isNotEmpty == true,
        )
        .toList();

    late final http.Response response;
    if (newFiles.isEmpty) {
      final body = <String, dynamic>{
        'reasons': reasons,
        'action_plan': actionPlan,
        'preventive_plan': preventivePlan,
      };
      if (attachments != null) body['attachment_ids'] = keptIds;
      response = await http.patch(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
    } else {
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      request.fields['_method'] = 'PATCH';
      request.fields['action_plan'] = actionPlan;
      request.fields['preventive_plan'] = preventivePlan;
      for (var i = 0; i < reasons.length; i++) {
        request.fields['reasons[$i]'] = reasons[i];
      }
      for (final keptId in keptIds) {
        request.files.add(
          http.MultipartFile.fromString(
            'attachment_ids[]',
            keptId.toString(),
          ),
        );
      }
      for (final file in newFiles) {
        final path = file['path'].toString();
        await _ensurePhotoAttachment(path);
        request.files.add(
          await http.MultipartFile.fromPath(
            'attachments[]',
            path,
            filename: file['name']?.toString() ?? 'foto.jpg',
          ),
        );
      }
      final streamed = await request.send();
      response = await http.Response.fromStream(streamed);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        _apiErrorMessage(response.body, 'Gagal memperbarui evaluasi rework'),
      );
    }

    return _apiSuccessMessage(
      response.body,
      'Perubahan evaluasi rework sudah tersimpan.',
    );
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
      throw Exception(
        'Failed to update rework reasons: '
        '${response.statusCode} ${response.body}',
      );
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
      throw Exception(
        'Failed to load rework reason options: '
        '${response.statusCode} ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);
    final items = decoded is Map ? decoded['data'] : null;
    if (items is! List) return [];

    return items
        .whereType<Map>()
        .map(_mapReworkReasonOption)
        .where((item) => item['value']!.toString().isNotEmpty)
        .toList();
  }

  Future<Map<String, dynamic>> createReworkReasonOption(String label) async {
    final trimmedLabel = label.trim();
    if (trimmedLabel.isEmpty) throw Exception('Alasan tidak boleh kosong');
    if (trimmedLabel.length < 8) {
      throw Exception('Alasan minimal 8 karakter');
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/dyeing-rework-reason-options');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'label': trimmedLabel}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        _apiErrorMessage(response.body, 'Gagal menambah alasan'),
      );
    }

    Map<String, dynamic> data = {};
    final body = response.body.trim();
    if (body.isNotEmpty) {
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map && decoded['data'] is Map) {
          data = Map<String, dynamic>.from(decoded['data']);
        } else if (decoded is Map) {
          data = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }

    if (data['label']?.toString().trim().isEmpty ?? true) {
      data['label'] = trimmedLabel;
    }
    if (data['value']?.toString().trim().isEmpty ?? true) {
      data['value'] = trimmedLabel;
    }
    return _mapReworkReasonOption(data);
  }

  Future<void> deleteReworkReasonOption(dynamic id) async {
    if (id == null || id.toString().trim().isEmpty) {
      throw Exception('ID alasan tidak ditemukan');
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/dyeing-rework-reason-options/$id');
    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        _apiErrorMessage(response.body, 'Gagal menghapus alasan'),
      );
    }
  }

  Map<String, dynamic> _mapReworkReasonOption(Map item) {
    final id = item['id']?.toString().trim() ?? '';
    final value = item['value']?.toString().trim() ?? '';
    final label = item['label']?.toString().trim() ??
        item['name']?.toString().trim() ??
        value;

    return {
      'id': id.isNotEmpty ? id : value,
      'value': value.isNotEmpty ? value : (id.isNotEmpty ? id : label),
      'label': label.isNotEmpty ? label : value,
    };
  }

  Future<BsList> getBsList({
    DateTime? startDate,
    DateTime? endDate,
    String? sort,
    int page = 1,
    int perPage = 20,
    String? search,
    String? status,
  }) async {
    final startDateString = _formatDate(startDate!);
    final endDateString = _formatDate(endDate!);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final queryParameters = <String, String>{
      'start_date': startDateString,
      'end_date': endDateString,
      'sort': sort ?? '',
      'page': page.toString(),
      'per_page': perPage.toString(),
      'search': search ?? '',
    };
    if (status != null && status.trim().isNotEmpty) {
      queryParameters['status'] = status;
    }

    final uri = Uri.parse('$baseUrl/bs-evaluations')
        .replace(queryParameters: queryParameters);

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return BsList.fromJson(data);
    }

    throw Exception(
      'Failed to load BS list : '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<Map<String, int>> getBsStatusCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/bs-evaluations/summary');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final pending = int.tryParse(data?['pending']?.toString() ?? '') ?? 0;
      final reviewed = int.tryParse(data?['reviewed']?.toString() ?? '') ?? 0;
      final total =
          int.tryParse(data?['total']?.toString() ?? '') ?? pending + reviewed;

      return {'pending': pending, 'reviewed': reviewed, 'all': total};
    }

    throw Exception(
      'Failed to load BS summary: '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<Map<String, dynamic>> getBsDetail(dynamic id) async {
    if (id == null || id.toString().trim().isEmpty) {
      throw Exception('ID BS tidak ditemukan');
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/bs-evaluations/$id');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load BS detail: '
        '${response.statusCode} ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);
    final data = decoded is Map && decoded['data'] is Map
        ? Map<String, dynamic>.from(decoded['data'])
        : Map<String, dynamic>.from(decoded as Map);
    final workOrder = _asMap(data['work_order']);
    final sorting = _asMap(data['sorting']);
    final materialItem = _resolveMaterialItem(
      data: data,
      workOrder: workOrder,
    );
    final topMaterialCode = _first(materialItem, ['code']) ??
        _first(data, ['top_material_code']) ??
        '-';
    final topMaterialName = _first(materialItem, ['name']) ??
        _first(data, ['top_material_name']) ??
        '-';

    return {
      ...data,
      'id': data['id'] ?? id,
      'status': _first(data, ['status']) ?? '-',
      'woNo': _first(workOrder, ['wo_no', 'number', 'no']) ?? '-',
      'sortingNo': _first(data, ['sorting_no', 'no_sorting']) ??
          _first(sorting, ['sorting_no', 'no', 'number']) ??
          '-',
      'qtyBs': _first(data, ['qty_bs', 'bs_qty', 'qty']) ??
          _first(sorting, ['qty_bs', 'bs_qty', 'qty']) ??
          '-',
      'bsRate': _first(data, ['bs_rate']) ?? _first(sorting, ['bs_rate']) ?? '',
      'material': topMaterialCode != '-'
          ? (topMaterialName != '-'
              ? '$topMaterialCode - $topMaterialName'
              : topMaterialCode)
          : _formatBsMaterial(data),
      'topMaterialCode': topMaterialCode,
      'topMaterialName': topMaterialName,
      'defects': data['defects'] is List ? data['defects'] : [],
      'startedAt': _first(data, ['started_at', 'created_at']) ?? '-',
      'completedAt': _first(data, ['completed_at', 'finished_at']) ?? '-',
      'submittedBy': _formatSubmittedBy(data['submitted_by']),
      'reason': _formatDetailValue(data['reason'] ?? data['reasons']),
      'actionPlan': _formatDetailValue(data['action_plan']),
      'preventivePlan': _formatDetailValue(data['preventive_plan']),
    };
  }

  Future<String> updateBsDetail({
    required dynamic id,
    required String reason,
    required String actionPlan,
    required String preventivePlan,
    List<Map<String, dynamic>>? attachments,
  }) async {
    return _patchEvaluation(
      id: id,
      missingIdMessage: 'ID BS tidak ditemukan',
      path: 'bs-evaluations',
      body: {
        'reason': reason,
        'action_plan': actionPlan,
        'preventive_plan': preventivePlan,
      },
      attachments: attachments,
      fallbackMessage: 'Gagal memperbarui evaluasi BS',
      successMessage: 'Perubahan evaluasi BS sudah tersimpan.',
    );
  }

  Future<GsmList> getGsmList({
    DateTime? startDate,
    DateTime? endDate,
    String? sort,
    int page = 1,
    int perPage = 20,
    String? search,
    String? status,
  }) async {
    final startDateString = _formatDate(startDate!);
    final endDateString = _formatDate(endDate!);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final queryParameters = <String, String>{
      'start_date': startDateString,
      'end_date': endDateString,
      'sort': sort ?? '',
      'page': page.toString(),
      'per_page': perPage.toString(),
      'search': search ?? '',
    };
    if (status != null && status.trim().isNotEmpty) {
      queryParameters['status'] = status;
    }

    final uri = Uri.parse('$baseUrl/gsm-evaluations')
        .replace(queryParameters: queryParameters);

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return GsmList.fromJson(data);
    }

    throw Exception(
      'Failed to load GSM list : '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<Map<String, int>> getGsmStatusCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/gsm-evaluations/summary');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final pending = int.tryParse(data?['pending']?.toString() ?? '') ?? 0;
      final reviewed = int.tryParse(data?['reviewed']?.toString() ?? '') ?? 0;
      final total =
          int.tryParse(data?['total']?.toString() ?? '') ?? pending + reviewed;

      return {'pending': pending, 'reviewed': reviewed, 'all': total};
    }

    throw Exception(
      'Failed to load GSM summary: '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<Map<String, dynamic>> getGsmDetail(dynamic id) async {
    if (id == null || id.toString().trim().isEmpty) {
      throw Exception('ID GSM tidak ditemukan');
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/gsm-evaluations/$id');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load GSM detail: '
        '${response.statusCode} ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);
    final data = decoded is Map && decoded['data'] is Map
        ? Map<String, dynamic>.from(decoded['data'])
        : Map<String, dynamic>.from(decoded as Map);
    final workOrder = _asMap(data['work_order']);
    final packing = _asMap(data['packing']);
    final packingItem = _asMap(data['packing_item']);
    final packingItemMaterial = _asMap(packingItem['item']);
    final materialItem = _resolveMaterialItem(
      data: data,
      workOrder: workOrder,
      fallbackItem: packingItemMaterial,
    );
    final topMaterialCode = _first(materialItem, ['code']) ??
        _first(data, ['top_material_code']) ??
        '-';
    final topMaterialName = _first(materialItem, ['name']) ??
        _first(data, ['top_material_name']) ??
        '-';

    return {
      ...data,
      'id': data['id'] ?? id,
      'status': _first(data, ['status']) ?? '-',
      'woNo': _first(workOrder, ['wo_no', 'number', 'no']) ?? '-',
      'packingNo': _first(data, ['packing_no', 'no_packing']) ??
          _first(packing, ['packing_no', 'no', 'number']) ??
          '-',
      'packingGsm': _first(data, ['packing_gsm']) ??
          _first(packing, ['packing_gsm']) ??
          _first(packingItem, ['gsm']) ??
          '-',
      'materialGsm': _first(data, ['material_gsm']) ??
          _first(packing, ['material_gsm']) ??
          '-',
      'qtyBs': _first(data, ['qty_bs', 'bs_qty', 'qty']) ?? '-',
      'material':
          topMaterialCode != '-' ? topMaterialCode : _formatBsMaterial(data),
      'topMaterialCode': topMaterialCode,
      'topMaterialName': topMaterialName,
      'startedAt': _first(data, ['started_at', 'created_at']) ?? '-',
      'completedAt': _first(data, ['completed_at', 'finished_at']) ?? '-',
      'submittedBy': _formatSubmittedBy(data['submitted_by']),
      'reason': _formatDetailValue(data['reason'] ?? data['reasons']),
      'actionPlan': _formatDetailValue(data['action_plan']),
      'preventivePlan': _formatDetailValue(data['preventive_plan']),
    };
  }

  Future<String> updateGsmDetail({
    required dynamic id,
    required String reason,
    required String actionPlan,
    required String preventivePlan,
    List<Map<String, dynamic>>? attachments,
  }) async {
    return _patchEvaluation(
      id: id,
      missingIdMessage: 'ID GSM tidak ditemukan',
      path: 'gsm-evaluations',
      body: {
        'reason': reason,
        'action_plan': actionPlan,
        'preventive_plan': preventivePlan,
      },
      attachments: attachments,
      fallbackMessage: 'Gagal memperbarui evaluasi GSM',
      successMessage: 'Perubahan evaluasi GSM sudah tersimpan.',
    );
  }

  Future<String> _patchEvaluation({
    required dynamic id,
    required String missingIdMessage,
    required String path,
    required Map<String, dynamic> body,
    List<Map<String, dynamic>>? attachments,
    required String fallbackMessage,
    required String successMessage,
  }) async {
    if (id == null || id.toString().trim().isEmpty) {
      throw Exception(missingIdMessage);
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/$path/$id');
    final keptIds = (attachments ?? const <Map<String, dynamic>>[])
        .where((item) => item['isNew'] != true && item['id'] != null)
        .map((item) => item['id'])
        .toList();
    final newFiles = (attachments ?? const <Map<String, dynamic>>[])
        .where(
          (item) =>
              item['isNew'] == true &&
              item['path']?.toString().trim().isNotEmpty == true,
        )
        .toList();

    late final http.Response response;
    if (newFiles.isEmpty) {
      final payload = Map<String, dynamic>.from(body);
      if (attachments != null) payload['attachment_ids'] = keptIds;
      response = await http.patch(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );
    } else {
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      request.fields['_method'] = 'PATCH';
      body.forEach((key, value) {
        if (value == null) return;
        if (value is List) {
          for (var i = 0; i < value.length; i++) {
            request.fields['$key[$i]'] = value[i].toString();
          }
          return;
        }
        request.fields[key] = value.toString();
      });
      for (final keptId in keptIds) {
        request.files.add(
          http.MultipartFile.fromString(
            'attachment_ids[]',
            keptId.toString(),
          ),
        );
      }
      for (final file in newFiles) {
        final path = file['path'].toString();
        await _ensurePhotoAttachment(path);
        request.files.add(
          await http.MultipartFile.fromPath(
            'attachments[]',
            path,
            filename: file['name']?.toString() ?? 'foto.jpg',
          ),
        );
      }
      final streamed = await request.send();
      response = await http.Response.fromStream(streamed);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_apiErrorMessage(response.body, fallbackMessage));
    }

    return _apiSuccessMessage(response.body, successMessage);
  }

  static const _photoExtensions = {'jpg', 'jpeg', 'png', 'gif', 'webp'};
  static const _maxPhotoBytes = 10 * 1024 * 1024;

  Future<void> _ensurePhotoAttachment(String path) async {
    final fileExtension = path.split('.').last.toLowerCase();
    if (!_photoExtensions.contains(fileExtension)) {
      throw Exception('Lampiran hanya boleh jpg, jpeg, png, gif, atau webp.');
    }
    if (await File(path).length() > _maxPhotoBytes) {
      throw Exception('Ukuran foto maksimal 10MB.');
    }
  }

  String _apiSuccessMessage(String body, String fallback) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) {
        final message = decoded['message']?.toString().trim();
        if (message != null && message.isNotEmpty) return message;
      }
    } catch (_) {}
    return fallback;
  }

  String _apiErrorMessage(String body, String fallback) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) {
        final message = decoded['message']?.toString().trim();
        if (message != null && message.isNotEmpty) return message;
      }
    } catch (_) {}
    return fallback;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    return value is Map ? Map<String, dynamic>.from(value) : {};
  }

  Map<String, dynamic> _resolveMaterialItem({
    required Map<String, dynamic> data,
    required Map<String, dynamic> workOrder,
    Map<String, dynamic>? fallbackItem,
  }) {
    final woItems = workOrder['items'];
    if (woItems is List && woItems.isNotEmpty) {
      return _asMap(woItems.first);
    }
    if (fallbackItem != null && fallbackItem.isNotEmpty) {
      return fallbackItem;
    }
    return _asMap(data['item']);
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
    final repairTypes = {'perbaikan_warna', 'perbaikan_noda', 'pelemas_ulang'};
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
        methodLabels.isEmpty ? label : '$label: ${methodLabels.join(', ')}',
      );
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

  String _formatBsMaterial(Map<String, dynamic> data) {
    final code = data['top_material_code']?.toString().trim() ?? '';
    final name = data['top_material_name']?.toString().trim() ?? '';
    if (code.isNotEmpty && name.isNotEmpty) return '$code - $name';
    if (code.isNotEmpty) return code;
    if (name.isNotEmpty) return name;
    return _first(data, [
          'material',
          'semi_finished_product',
          'semiFinishedProduct',
        ])?.toString() ??
        '-';
  }
}
