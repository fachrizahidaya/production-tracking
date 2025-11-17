import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OptionOperator {
  final int? value;
  final String? label;

  OptionOperator({this.value, this.label});

  factory OptionOperator.fromJson(Map<String, dynamic> json) {
    return OptionOperator(
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

class OptionOperatorService extends BaseService<OptionOperator> {
  bool _isLoading = false;
  bool _hasMoreData = true;
  final List<dynamic> _listOption = [];
  List<dynamic> _dataListOption = [];

  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;
  List<dynamic> get listOption => _listOption;
  List<dynamic> get dataListOption => _dataListOption;

  @override
  Future<void> fetchItems(
      {bool isInitialLoad = false, String? searchQuery = ''}) async {}

  @override
  Future<void> refetchItems() async {}

  @override
  Future<void> addItem(
      OptionOperator newOperator, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> updateItem(String id, OptionOperator updatedOperator,
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
          Uri.parse('${dotenv.env['API_URL_DEV']}/operator/option'),
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
      } else {
        throw Exception('Failed to load operators');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
