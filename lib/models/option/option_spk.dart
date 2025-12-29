// ignore_for_file: annotate_overrides, prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OptionSpk {
  final int? value;
  final String? label;

  OptionSpk({this.value, this.label});

  factory OptionSpk.fromJson(Map<String, dynamic> json) {
    return OptionSpk(
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

class OptionSpkService extends BaseService<OptionSpk> {
  bool _isLoading = false;
  bool _hasMoreData = true;
  final List<dynamic> _listOption = [];
  List<dynamic> _dataListOption = [];
  final List<OptionSpk> _spk = [];

  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;
  List<dynamic> get listOption => _listOption;
  List<dynamic> get dataListOption => _dataListOption;
  List<OptionSpk> get options => _spk;

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
      OptionSpk item, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> updateItem(
      String id, OptionSpk item, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> deleteItem(String id, ValueNotifier<bool> isSubmitting) async {}

  Future<void> fetchOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    if (_isLoading || (!_hasMoreData && !isInitialLoad)) return;

    if (isInitialLoad) {
      _hasMoreData = true;
      _spk.clear();
    }

    _isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('Access token is missing');
      }

      final response = await http
          .get(Uri.parse('${dotenv.env['API_URL']}/spk/option'), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> dataList;
        if (decoded is List) {
          dataList = decoded;
        } else if (decoded is Map<String, dynamic> &&
            decoded.containsKey('data')) {
          dataList = decoded['data'];
        } else {
          throw Exception("Unexpected response format: $decoded");
        }

        List<OptionSpk> newSpk =
            dataList.map((item) => OptionSpk.fromJson(item)).toList();

        _spk.clear();
        _spk.addAll(newSpk);
        _hasMoreData = false;
      } else {
        throw Exception('Failed to load spk');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
