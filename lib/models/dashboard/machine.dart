// ignore_for_file: prefer_final_fields, annotate_overrides

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:http/http.dart' as http;

class Machine {
  final int? id;

  final available;
  final unavailable;

  Machine({this.id, this.available, this.unavailable});

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      available: json['available'] ?? {},
      unavailable: json['unavailable'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {'available': available, 'unavailable': unavailable};
  }
}

class MachineService extends BaseService {
  final String baseUrl =
      '${dotenv.env['API_URL_DEV']}/dashboard/machine-status';

  bool _isLoading = false;
  Map<String, dynamic> _dataList = {};

  bool get isLoading => _isLoading;
  get dataList => _dataList;

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

  Future<void> fetchWorkOrderProcess({
    bool isInitialLoad = false,
    String? searchQuery = '',
  }) async {}

  Future<void> refetchMachine() async {
    await fetchWorkOrderProcess(isInitialLoad: true);
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
            final data = responseData['data'];

            _dataList = {
              "available": data['available']['data'],
              "unavailable": data['unavailable']['data']
            };
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
