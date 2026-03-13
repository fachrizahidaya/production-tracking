// ignore_for_file: annotate_overrides, prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OptionItem {
  final int? value;
  final String? label;

  OptionItem({this.value, this.label});

  factory OptionItem.fromJson(Map<String, dynamic> json) {
    return OptionItem(
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

class OptionItemService extends BaseService<OptionItem> {
  final String baseUrl = '${dotenv.env['API_URL']}/item/option';

  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;
  final List<dynamic> _listOption = [];
  List<dynamic> _dataListOption = [];
  String _activeSearch = '';

  final List<OptionItem> _item = [];

  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;
  List<dynamic> get listOption => _listOption;
  List<dynamic> get dataListOption => _dataListOption;

  List<OptionItem> get options => _item;

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
      OptionItem item, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> updateItem(
      String id, OptionItem item, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> deleteItem(String id, ValueNotifier<bool> isSubmitting) async {}

  Future<void> _fetchOptionsGeneric({
    bool isInitialLoad = false,
    String? type,
    String searchQuery = '',
  }) async {
    // if (_isLoading || (!_hasMoreData && !isInitialLoad)) return;

    // if (searchQuery != _lastSearch) {
    //   _currentPage = 1;
    //   _hasMoreData = true;
    //   _dataListOption.clear();
    //   _lastSearch = searchQuery;
    // }

    // _isLoading = true;
    // notifyListeners();

    if (isInitialLoad) {
      _activeSearch = searchQuery; // save search keyword
      _currentPage = 1;
      _hasMoreData = true;
      _dataListOption.clear();
    }

    if (_isLoading || !_hasMoreData) return;

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) throw Exception('Access token is missing');

      final uri = Uri.parse('${dotenv.env['API_URL']}/item/option')
          .replace(queryParameters: {
        'page': _currentPage.toString(),
        if (type != null && type.isNotEmpty) 'type': type,
        if (_activeSearch.isNotEmpty) 'search': _activeSearch,
      });

      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final data = decoded['data'];

        final List newItems = data['data'];
        final int currentPage = data['current_page'];
        final int lastPage = data['last_page'];

        _dataListOption.addAll(newItems);

        _currentPage = currentPage + 1;
        _hasMoreData = currentPage < lastPage;

        notifyListeners();
      } else {
        throw Exception('Failed to load item: ${response.statusCode}');
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
  }) async {
    await _fetchOptionsGeneric(
      isInitialLoad: isInitialLoad,
      type: 'finish_product',
      searchQuery: searchQuery,
    );
  }
}
