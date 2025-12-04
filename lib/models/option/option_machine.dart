// ignore_for_file: annotate_overrides, prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
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
      OptionMachine item, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> updateItem(
      String id, OptionMachine item, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> deleteItem(String id, ValueNotifier<bool> isSubmitting) async {}

  Future<void> _fetchOptionsGeneric({
    String? process,
    String searchQuery = '',
    bool clearBeforeFetch = true,
  }) async {
    if (_isLoading || !_hasMoreData) return;

    _isLoading = true;
    if (clearBeforeFetch) _dataListOption.clear();
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) throw Exception('Access token is missing');

      final uri = Uri.parse('${dotenv.env['API_URL']}/machine/option')
          .replace(queryParameters: {
        if (process != null && process.isNotEmpty) 'process': process,
        if (searchQuery.isNotEmpty) 'search': searchQuery,
      });

      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['data'] != null) {
          _dataListOption = decoded['data'];
        }

        notifyListeners();
      } else {
        throw Exception('Failed to load machines: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text("$e")),
      );
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOptions() async {
    await _fetchOptionsGeneric();
  }

  Future<void> fetchOptionsDyeing() async {
    await _fetchOptionsGeneric(process: 'dyeing');
  }

  Future<void> fetchOptionsPressTumbler() async {
    await _fetchOptionsGeneric(process: 'press_tumbler');
  }

  Future<void> fetchOptionsStenter() async {
    await _fetchOptionsGeneric(process: 'stenter');
  }

  Future<void> fetchOptionsLongSitting() async {
    await _fetchOptionsGeneric(process: 'long_sitting');
  }

  Future<void> fetchOptionsLongHemming() async {
    await _fetchOptionsGeneric(process: 'long_hemming');
  }

  Future<void> fetchOptionsCrossCutting() async {
    await _fetchOptionsGeneric(process: 'cross_cutting');
  }

  Future<void> fetchOptionsSewing() async {
    await _fetchOptionsGeneric(process: 'sewing');
  }
}
