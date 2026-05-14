// ignore_for_file: annotate_overrides

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:http/http.dart' as http;

class OptionItemSemiFinished {
  final int? value;
  final String? label;

  OptionItemSemiFinished({this.value, this.label});

  factory OptionItemSemiFinished.fromJson(Map<String, dynamic> json) {
    return OptionItemSemiFinished(
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

class OptionItemSemiFinishedService
    extends BaseService<OptionItemSemiFinished> {
  final String baseUrl =
      '${dotenv.env['API_URL_DEV']}/semifinished-product/item-option';

  bool _isLoading = false;
  bool _hasMoreData = true;

  List<dynamic> _dataListOption = [];
  final List<OptionItemSemiFinished> _item = [];

  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;

  List<dynamic> get dataListOption => _dataListOption;
  List<OptionItemSemiFinished> get options => _item;

  @override
  Future<void> fetchItems({
    bool isInitialLoad = false,
    String? searchQuery = '',
  }) async {}

  @override
  Future<void> refetchItems() async {
    _hasMoreData = true;

    await fetchItems(isInitialLoad: true);
  }

  @override
  Future<void> addItem(
    OptionItemSemiFinished item,
    ValueNotifier<bool> isSubmitting,
  ) async {}

  @override
  Future<void> updateItem(
    String id,
    OptionItemSemiFinished item,
    ValueNotifier<bool> isSubmitting,
  ) async {}

  @override
  Future<void> deleteItem(
    String id,
    ValueNotifier<bool> isSubmitting,
  ) async {}

  Future<void> _fetchOptionsGeneric({
    bool isInitialLoad = false,
    String? process,
    List<String>? baseCodes,
    List<String>? colorCodes,
    String searchQuery = '',
  }) async {
    if (_isLoading || (!_hasMoreData && !isInitialLoad)) return;

    if (isInitialLoad) {
      _hasMoreData = true;
      _item.clear();
      _dataListOption.clear();
    }

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('Access token is missing');
      }

      final uri = Uri.parse(baseUrl).replace(
        queryParameters: {
          if (process != null && process.isNotEmpty) 'process': process,

          // MPN337GX,MPN337M0
          if (baseCodes != null && baseCodes.isNotEmpty)
            'base_code': baseCodes.join(','),

          // LBU,LBU
          if (colorCodes != null && colorCodes.isNotEmpty)
            'color_code': colorCodes.join(','),

          if (searchQuery.isNotEmpty) 'search': searchQuery,
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['data'] != null) {
          _dataListOption = decoded['data'];
        }

        notifyListeners();
      } else {
        throw Exception(
          'Failed to load semifinished item: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
    String process = 'dyeing',
    List<String> baseCodes = const [],
    List<String> colorCodes = const [],
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      process: process,
      baseCodes: baseCodes,
      colorCodes: colorCodes,
      searchQuery: searchQuery,
    );
  }
}
