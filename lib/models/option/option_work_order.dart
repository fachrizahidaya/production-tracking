// ignore_for_file: annotate_overrides

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OptionWorkOrder {
  final int? value;
  final String? label;

  OptionWorkOrder({this.value, this.label});

  factory OptionWorkOrder.fromJson(Map<String, dynamic> json) {
    return OptionWorkOrder(
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

class OptionWorkOrderService extends BaseService<OptionWorkOrder> {
  final String baseUrl = '${dotenv.env['API_URL']}/wo/option';

  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final List<dynamic> _listOption = [];
  List<dynamic> _dataListOption = [];

  final List<OptionWorkOrder> _wo = [];

  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;
  List<dynamic> get listOption => _listOption;
  List<dynamic> get dataListOption => _dataListOption;

  List<OptionWorkOrder> get options => _wo;

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
      OptionWorkOrder item, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> updateItem(String id, OptionWorkOrder item,
      ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> deleteItem(String id, ValueNotifier<bool> isSubmitting) async {}

  Future<void> _fetchOptionsGeneric({
    bool isInitialLoad = false,
    String? type,
    String searchQuery = '',
  }) async {
    if (_isLoading || (!_hasMoreData && !isInitialLoad)) return;

    if (isInitialLoad) {
      _currentPage = 1;
      _hasMoreData = true;
      _wo.clear();
    }

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) throw Exception('Access token is missing');

      final uri = Uri.parse('${dotenv.env['API_URL']}/wo/option')
          .replace(queryParameters: {
        if (type != null && type.isNotEmpty) 'type': type,
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
        throw Exception('Failed to load work order: ${response.statusCode}');
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

  Future<void> fetchOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'dyeing',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchReworkOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'dyeing_rework',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchFinishOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'dyeing_finish',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchPressTumblerOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'press_tumbler',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchPressFinishOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'press_tumbler_finish',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchStenterOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'stenter',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchStenterFinishOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'stenter_finish',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchLongSittingOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'long_sitting',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchSittingFinishOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'long_sitting_finish',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchLongHemmingOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'long_hemming',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchHemmingFinishOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'long_hemming_finish',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchCrossCuttingOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'cross_cutting',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchCuttingFinishOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'cross_cutting_finish',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchSewingOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'sewing',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchSewingFinishOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'sewing_finish',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchEmbroideryOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'embroidery',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchEmbroideryFinishOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'embroidery_finish',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchPrintingOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'printing',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchPrintingFinishOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'printing_finish',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchSortingOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'sorting',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchSortingFinishOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'sorting_finish',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchPackingOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'packing',
      searchQuery: searchQuery,
    );
  }

  Future<void> fetchPackingFinishOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'packing_finish',
      searchQuery: searchQuery,
    );
  }
}
