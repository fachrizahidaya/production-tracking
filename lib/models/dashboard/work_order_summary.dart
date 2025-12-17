import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:http/http.dart' as http;

class WorkOrderSummaryService extends BaseService {
  final String baseUrl = '${dotenv.env['API_URL']}/dashboard/wo-summary';

  bool _isLoading = false;
  List<dynamic> _dataList = [];
  List<dynamic> _dataSummary = [];
  bool get isLoading => _isLoading;
  List<dynamic> get dataList => _dataList;
  List<dynamic> get dataSummary => _dataSummary;

  @override
  Future<void> fetchItems(
      {bool isInitialLoad = false, String? searchQuery = ''}) async {}

  @override
  Future<void> refetchItems() async {
    hasMoreData = true;
    await fetchItems(isInitialLoad: true);
  }

  @override
  Future<void> addItem(item, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> updateItem(
      String id, item, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> deleteItem(String id, ValueNotifier<bool> isSubmitting) async {}

  Future<void> fetchWorkOrderSummary({
    bool isInitialLoad = false,
    String? searchQuery = '',
  }) async {}

  Future<void> refetchWOChart() async {
    await fetchWorkOrderSummary(isInitialLoad: true);
  }

  Future<void> getDataList(Map<String, String> params) async {
    final url = Uri.parse(baseUrl).replace(queryParameters: params);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      throw 'Token not found';
    }

    try {
      _dataList.clear();
      notifyListeners();

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          if (responseData['data'] != null) {
            _dataList = responseData['data'];
          }
          notifyListeners();
          break;

        default:
          throw responseData['message'] ?? 'Unknown error';
      }
    } catch (e) {
      rethrow;
    }
  }
}
