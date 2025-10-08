import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  final String baseUrl = '${dotenv.env['API_URL_DEV']}/units';

  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final List<dynamic> _listOption = [];
  List<dynamic> _dataListOption = [];
  List<dynamic> _dataListRework = [];
  List<dynamic> _dataListFinish = [];
  final List<OptionWorkOrder> _wo = [];

  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;
  List<dynamic> get listOption => _listOption;
  List<dynamic> get dataListOption => _dataListOption;
  List<dynamic> get dataListRework => _dataListRework;
  List<dynamic> get dataListFinish => _dataListFinish;
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
      OptionWorkOrder newWo, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> updateItem(String id, OptionWorkOrder updatedWo,
      ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> deleteItem(String id, ValueNotifier<bool> isSubmitting) async {}

  Future<void> fetchOptions({
    bool isInitialLoad = false,
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('Access token is missing');
      }

      final response = await http.get(
          Uri.parse('${dotenv.env['API_URL_DEV']}/work-order/option'),
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
        throw Exception('Failed to load work order');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchReworkOptions({
    bool isInitialLoad = false,
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('Access token is missing');
      }

      final response = await http.get(
          Uri.parse('${dotenv.env['API_URL_DEV']}/work-order/option')
              .replace(queryParameters: {
            'wo_status': 'Diproses',
            'dyeing_status': 'Selesai',
            'include_dyeing': 'true',
          }),
          headers: {
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        switch (response.statusCode) {
          case 200:
            if (decoded['data'] != null) {
              _dataListRework = decoded['data'];
            }
            notifyListeners();
            break;
          default:
            throw decoded['message'];
        }
      } else {
        throw Exception('Failed to load work order');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFinishOptions({
    bool isInitialLoad = false,
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('Access token is missing');
      }

      final response = await http.get(
          Uri.parse('${dotenv.env['API_URL_DEV']}/work-order/option')
              .replace(queryParameters: {
            'wo_status': 'Diproses',
            'dyeing_status': 'Diproses',
            'include_dyeing': 'true',
          }),
          headers: {
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        switch (response.statusCode) {
          case 200:
            if (decoded['data'] != null) {
              _dataListFinish = decoded['data'];
            }
            notifyListeners();
            break;
          default:
            throw decoded['message'];
        }
      } else {
        throw Exception('Failed to load work order');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
