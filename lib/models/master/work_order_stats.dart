import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:textile_tracking/helpers/service/base_service.dart';

class WorkOrderStatsService extends BaseService {
  final String baseUrl = '${dotenv.env['API_URL_DEV']}/dashboard/wo-stats';

  bool _isLoading = false;
  List<dynamic> _dataList = [];
  bool get isLoading => _isLoading;
  List<dynamic> get dataList => _dataList;

  @override
  Future<void> fetchItems(
      {bool isInitialLoad = false, String? searchQuery = ''}) async {}

  @override
  Future<void> refetchItems() async {
    hasMoreData = true;
    await fetchItems(isInitialLoad: true);
  }

  @override
  Future<void> addItem(newDyeing, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> updateItem(
      String id, updatedDyeing, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> deleteItem(String id, ValueNotifier<bool> isSubmitting) async {}

  Future<void> fetchWorkOrderStats({
    bool isInitialLoad = false,
    String? searchQuery = '',
  }) async {}

  Future<void> refetchWOStats() async {
    await fetchWorkOrderStats(isInitialLoad: true);
  }

  Future<void> getDataList() async {
    final url = Uri.parse(baseUrl);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token').toString();

    try {
      _dataList.clear();
      notifyListeners();

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });
      final responseData = jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          if (responseData['data'] != null) {
            _dataList = responseData['data']['stats'];
          }
          notifyListeners();
          break;
        default:
          throw responseData['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
