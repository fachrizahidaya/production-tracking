// ignore_for_file: annotate_overrides

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:http/http.dart' as http;

class OptionItemGrade {
  final int? value;
  final String? label;

  OptionItemGrade({this.value, this.label});

  factory OptionItemGrade.fromJson(Map<String, dynamic> json) {
    return OptionItemGrade(
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

class OptionItemGradeService extends BaseService<OptionItemGrade> {
  final String baseUrl = '${dotenv.env['API_URL']}/item-grade/option';

  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final List<dynamic> _listOption = [];
  List<dynamic> _dataListOption = [];

  final List<OptionItemGrade> _ig = [];

  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;
  List<dynamic> get listOption => _listOption;
  List<dynamic> get dataListOption => _dataListOption;

  List<OptionItemGrade> get options => _ig;

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
      OptionItemGrade item, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> updateItem(String id, OptionItemGrade item,
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
      _ig.clear();
    }

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) throw Exception('Access token is missing');

      final uri = Uri.parse('${dotenv.env['API_URL']}/item-grade/option');

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
}
