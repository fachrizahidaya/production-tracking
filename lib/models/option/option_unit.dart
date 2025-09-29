import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:production_tracking/helpers/service/base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OptionUnit {
  final int? value;
  final String? label;

  OptionUnit({this.value, this.label});

  factory OptionUnit.fromJson(Map<String, dynamic> json) {
    return OptionUnit(
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

class OptionUnitService extends BaseService<OptionUnit> {
  final String baseUrl = '${dotenv.env['API_URL_DEV']}/units';

  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _itemsPerPage = 20;
  final List<OptionUnit> _units = [];
  List<dynamic> _dataListOption = [];

  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;
  List<OptionUnit> get options => _units;
  List<dynamic> get dataListOption => _dataListOption;

  @override
  Future<void> fetchItems(
      {bool isInitialLoad = false, String? searchQuery = ''}) async {
    if (isLoading || (!hasMoreData && !isInitialLoad)) return;

    if (isInitialLoad) {
      _currentPage = 1;
      hasMoreData = true;
      items.clear();
      notifyListeners();
    }

    isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final response = await http.get(
        Uri.parse('$baseUrl?page=$_currentPage&search=$searchQuery'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> dataList = responseData['data'];

        List<OptionUnit> newItems =
            dataList.map((item) => OptionUnit.fromJson(item)).toList();

        if (newItems.length < _itemsPerPage || newItems.isEmpty) {
          hasMoreData = false;
        }

        if (newItems.isNotEmpty) {
          items.addAll(newItems);
          _currentPage++;
        }
      } else {
        throw Exception('Failed to load units');
      }
    } catch (e) {
      throw Exception("Error fetching units: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> refetchItems() async {
    hasMoreData = true;
    await fetchItems(isInitialLoad: true);
  }

  @override
  Future<void> addItem(
      OptionUnit newUnit, ValueNotifier<bool> isSubmitting) async {
    try {
      isSubmitting.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(newUnit.toJson()),
      );

      if (response.statusCode == 200) {
        await refetchItems();
        notifyListeners();
        final responseData = jsonDecode(response.body);
        return responseData['message'];
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to add units');
      }
    } catch (e) {
      throw Exception('Error adding units: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  Future<void> updateItem(String id, OptionUnit updatedUnit,
      ValueNotifier<bool> isSubmitting) async {
    try {
      isSubmitting.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final response = await http.patch(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedUnit.toJson()),
      );

      if (response.statusCode == 200) {
        await refetchItems();
        notifyListeners();
        final responseData = jsonDecode(response.body);
        return responseData['message'];
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update unit');
      }
    } catch (e) {
      throw Exception("Error updating unit: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  Future<void> deleteItem(String id, ValueNotifier<bool> isSubmitting) async {
    try {
      isSubmitting.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await refetchItems();
        notifyListeners();
        final responseData = jsonDecode(response.body);
        return responseData['message'];
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to delete unit');
      }
    } catch (e) {
      throw Exception("Error deleting unit: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> fetchOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    if (_isLoading || (!_hasMoreData && !isInitialLoad)) return;

    if (isInitialLoad) {
      _currentPage = 1;
      _hasMoreData = true;
      _units.clear();
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
          .get(Uri.parse('${dotenv.env['API_URL_DEV']}/unit/option'), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
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

        List<OptionUnit> newUnits =
            dataList.map((item) => OptionUnit.fromJson(item)).toList();

        _units.clear();
        _units.addAll(newUnits);
        _hasMoreData = false;
      } else {
        throw Exception('Failed to load units');
      }
    } catch (e) {
      throw Exception('Error fetching units: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDataListOption({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    if (_isLoading || (!_hasMoreData && !isInitialLoad)) return;

    if (isInitialLoad) {
      _currentPage = 1;
      _hasMoreData = true;
      _units.clear();
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
          .get(Uri.parse('${dotenv.env['API_URL_DEV']}/unit/option'), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
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
        throw Exception('Failed to load units');
      }
    } catch (e) {
      throw Exception('Error fetching units: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
