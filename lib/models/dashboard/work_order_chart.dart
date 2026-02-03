// ignore_for_file: prefer_final_fields, annotate_overrides

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:textile_tracking/helpers/service/base_service.dart';

class WorkOrderChartService extends BaseService {
  final String baseUrl = '${dotenv.env['API_URL_DEV']}/dashboard/wo-charts';

  bool _isLoading = false;
  List<dynamic> _dataList = [];
  List<dynamic> _dataPie = [];
  bool get isLoading => _isLoading;
  List<dynamic> get dataList => _dataList;
  List<dynamic> get dataPie => _dataPie;

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

  Future<void> fetchWorkOrderChart({
    bool isInitialLoad = false,
    String? searchQuery = '',
  }) async {}

  Future<void> refetchWOChart() async {
    await fetchWorkOrderChart(isInitialLoad: true);
  }

  Future<void> getDataList(Map<String, String> params) async {
    final url = Uri.parse(baseUrl).replace(queryParameters: params);

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
            _dataList = responseData['data']['wo_process_stats']['stats'];
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

  Future<void> getDataPie() async {
    final url = Uri.parse(baseUrl);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token').toString();

    try {
      _dataPie.clear();
      notifyListeners();

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });
      final responseData = jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          if (responseData['data'] != null) {
            _dataPie = responseData['data']['wo_status_summary']['summary'];
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
