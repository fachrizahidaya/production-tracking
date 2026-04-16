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
    List<dynamic>? currentMachineIds,
  }) async {
    if (_isLoading || !_hasMoreData) return;

    _isLoading = true;
    if (clearBeforeFetch) _dataListOption.clear();
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) throw Exception('Access token is missing');

      // Build query parameters with support for multiple current_machine_ids
      final queryParams = <String, dynamic>{};
      if (process != null && process.isNotEmpty)
        queryParams['process'] = process;
      if (searchQuery.isNotEmpty) queryParams['search'] = searchQuery;

      queryParams['status'] = 'Tersedia';

      // Add current machine IDs as array parameter
      if (currentMachineIds != null && currentMachineIds.isNotEmpty) {
        queryParams['current_machine_ids[]'] =
            currentMachineIds.map((id) => id.toString()).toList();
      }

      final uri = Uri.parse('${dotenv.env['API_URL_DEV']}/machine/option')
          .replace(queryParameters: queryParams);

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
    await _fetchOptionsGeneric(process: 'dyeing', currentMachineIds: null);
  }

  Future<void> fetchOptionsPressTumbler(
      {List<dynamic>? currentMachineIds}) async {
    await _fetchOptionsGeneric(process: 'press', currentMachineIds: null);
  }

  Future<void> fetchOptionsTumbler({List<dynamic>? currentMachineIds}) async {
    await _fetchOptionsGeneric(process: 'tumbler', currentMachineIds: null);
  }

  Future<void> fetchOptionsStenter({List<dynamic>? currentMachineIds}) async {
    await _fetchOptionsGeneric(process: 'stenter', currentMachineIds: null);
  }

  Future<void> fetchOptionsLongSitting(
      {List<dynamic>? currentMachineIds}) async {
    await _fetchOptionsGeneric(
        process: 'long_slitting', currentMachineIds: null);
  }

  Future<void> fetchOptionsLongHemming(
      {List<dynamic>? currentMachineIds}) async {
    await _fetchOptionsGeneric(
        process: 'long_hemming', currentMachineIds: currentMachineIds);
  }

  Future<void> fetchOptionsCrossCutting(
      {List<dynamic>? currentMachineIds}) async {
    await _fetchOptionsGeneric(
        process: 'cross_cutting', currentMachineIds: currentMachineIds);
  }

  Future<void> fetchOptionsSewing({List<dynamic>? currentMachineIds}) async {
    await _fetchOptionsGeneric(
        process: 'sewing', currentMachineIds: currentMachineIds);
  }
}
