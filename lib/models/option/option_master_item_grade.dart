// ignore_for_file: annotate_overrides

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:http/http.dart' as http;

class OptionMasterItemGrade {
  final int? value;
  final String? label;

  OptionMasterItemGrade({this.value, this.label});

  factory OptionMasterItemGrade.fromJson(Map<String, dynamic> json) {
    return OptionMasterItemGrade(
      value: json['id'],
      label: '${json['code']} - ${json['description']}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': value,
      'label': label,
    };
  }
}

class OptionMasterItemGradeService extends BaseService<OptionMasterItemGrade> {
  final String baseUrl = '${dotenv.env['API_URL_DEV']}/item-grades';

  bool _isLoading = false;
  bool _hasMoreData = true;

  final List<OptionMasterItemGrade> _items = [];
  List<dynamic> _dataListOption = [];

  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;

  List<OptionMasterItemGrade> get options => _items;
  List<dynamic> get dataListOption => _dataListOption;

  @override
  Future<void> fetchItems({
    bool isInitialLoad = false,
    String? searchQuery = '',
  }) async {
    await fetchOptions(
      isInitialLoad: isInitialLoad,
      searchQuery: searchQuery ?? '',
    );
  }

  @override
  Future<void> refetchItems() async {
    _hasMoreData = true;
    await fetchItems(isInitialLoad: true);
  }

  @override
  Future<void> addItem(
      OptionMasterItemGrade item, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> updateItem(String id, OptionMasterItemGrade item,
      ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> deleteItem(String id, ValueNotifier<bool> isSubmitting) async {}

  Future<void> fetchOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    if (_isLoading) return;

    if (isInitialLoad) {
      _items.clear();
      _dataListOption.clear();
      _hasMoreData = true;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) throw Exception('Access token is missing');

      final uri = Uri.parse(baseUrl);

      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final List data = decoded['data'] ?? [];

        /// ✅ MAP TO MODEL
        final List<OptionMasterItemGrade> fetched =
            data.map((e) => OptionMasterItemGrade.fromJson(e)).toList();

        /// OPTIONAL SEARCH (frontend filter)
        if (searchQuery.isNotEmpty) {
          final filtered = fetched
              .where((e) =>
                  e.label!.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          _items.addAll(filtered);
        } else {
          _items.addAll(fetched);
        }

        /// ✅ ALSO PROVIDE GENERIC FORMAT (for your dialog)
        _dataListOption = _items
            .map((e) => {
                  'id': e.value,
                  'name': e.label,
                })
            .toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load item grades: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
