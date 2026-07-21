// ignore_for_file: annotate_overrides

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OptionGreigeOrder {
  final int? value;
  final String? label;

  OptionGreigeOrder({this.value, this.label});

  factory OptionGreigeOrder.fromJson(Map<String, dynamic> json) {
    return OptionGreigeOrder(
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

class OptionGreigeOrderService extends BaseService<OptionGreigeOrder> {
  final String baseUrl = '${dotenv.env['API_URL']}/order-greiges/option';

  bool _isLoading = false;
  bool _hasMoreData = true;
  final List<dynamic> _listOption = [];
  List<dynamic> _dataListOption = [];

  final List<OptionGreigeOrder> _wo = [];

  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;
  List<dynamic> get listOption => _listOption;
  List<dynamic> get dataListOption => _dataListOption;

  List<OptionGreigeOrder> get options => _wo;

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
      OptionGreigeOrder item, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> updateItem(String id, OptionGreigeOrder item,
      ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> deleteItem(String id, ValueNotifier<bool> isSubmitting) async {}

  Future<void> _fetchOptionsGeneric(
      {bool isInitialLoad = false,
      String searchQuery = '',
      required String endpoint}) async {
    if (_isLoading || (!_hasMoreData && !isInitialLoad)) return;

    if (isInitialLoad) {
      _hasMoreData = true;
      _wo.clear();
    }

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) throw Exception('Access token is missing');

      final uri = Uri.parse(
        '${dotenv.env['API_URL']}/order-greiges/$endpoint',
      ).replace(
        queryParameters: {
          'per_page': '100',
          if (searchQuery.isNotEmpty) 'search': searchQuery,
        },
      );

      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final responseData = decoded['data'];

        if (responseData is List) {
          _dataListOption = responseData;
        } else if (responseData is Map<String, dynamic>) {
          _dataListOption = List<dynamic>.from(responseData['data'] ?? []);
        } else {
          _dataListOption = [];
        }

        notifyListeners();
      } else {
        throw Exception('Failed to load work order: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWarpingOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) =>
      _fetchOptionsGeneric(
        isInitialLoad: isInitialLoad,
        searchQuery: searchQuery,
        endpoint: 'warping-option',
      );

  Future<void> fetchWeavingOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) =>
      _fetchOptionsGeneric(
        isInitialLoad: isInitialLoad,
        searchQuery: searchQuery,
        endpoint: 'weaving-option',
      );

  Future<void> fetchShearingOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) =>
      _fetchOptionsGeneric(
        isInitialLoad: isInitialLoad,
        searchQuery: searchQuery,
        endpoint: 'shearing-option',
      );
}
