import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:production_tracking/helpers/service/base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OptionMachine {
  final int? value;
  final String? label;

  OptionMachine({this.value, this.label});

  factory OptionMachine.fromJson(Map<String, dynamic> json) {
    return OptionMachine(
      value: json['value'] as int,
      label: json['label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
    };
  }
}

class OptionMachineService extends BaseService<OptionMachine> {
  bool _isLoading = false;
  bool _hasMoreData = true;
  // final List<OptionMachine> _machines = [];
  final List<dynamic> _listOption = [];
  List<dynamic> _dataListOption = [];

  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;
  // List<OptionMachine> get options => _machines;
  List<dynamic> get listOption => _listOption;
  List<dynamic> get dataListOption => _dataListOption;

  @override
  Future<void> fetchItems(
      {bool isInitialLoad = false, String? searchQuery = ''}) async {}

  @override
  Future<void> refetchItems() async {
    hasMoreData = true;
    await fetchItems(isInitialLoad: true);
  }

  @override
  Future<void> addItem(
      OptionMachine newMachine, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> updateItem(String id, OptionMachine updatedMachine,
      ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> deleteItem(String id, ValueNotifier<bool> isSubmitting) async {}

  Future<void> fetchOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    if (_isLoading || (!_hasMoreData)) return;

    try {
      _dataListOption.clear();
      notifyListeners();

      if (token == null) {
        throw Exception('Access token is missing');
      }

      final response = await http.get(
          Uri.parse('${dotenv.env['API_URL_DEV']}/machine/option'),
          headers: {
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        switch (response.statusCode) {
          case 200:
            if (decoded['data'] != null) {
              _dataListOption = decoded['data'];
            }
            notifyListeners();
            break;
          default:
            throw decoded['message'];
        }
        // final List<dynamic> dataList;

        // if (decoded is List) {
        //   dataList = decoded;
        // } else if (decoded is Map<String, dynamic> &&
        //     decoded.containsKey('data')) {
        //   dataList = decoded['data'];
        // } else {
        //   throw Exception("Unexpected response format: $decoded");
        // }

        // List<OptionMachine> newUnits =
        //     dataList.map((item) => OptionMachine.fromJson(item)).toList();

        // _machines.clear();
        // _machines.addAll(newUnits);
        // _hasMoreData = false;
      } else {
        throw Exception('Failed to load machines');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
