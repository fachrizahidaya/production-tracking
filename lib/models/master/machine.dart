// ignore_for_file: annotate_overrides

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:http/http.dart' as http;

class Machine {
  final int? id;
  final String? code;
  final String? name;
  final String? status;

  Machine({
    this.id,
    required this.name,
    this.code,
    this.status,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'] as int?,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'status': status,
    };
  }

  /// 🔥 Special payload for PATCH status only
  Map<String, dynamic> toStatusJson() {
    return {
      'status': status,
    };
  }
}

class MachineMasterService extends BaseService<Machine> {
  final String baseUrl = '${dotenv.env['API_URL']}/machine';

  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _itemsPerPage = 20;

  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;

  @override
  Future<void> fetchItems({
    bool isInitialLoad = false,
    String? searchQuery = '',
  }) async {
    if (_isLoading || (!_hasMoreData && !isInitialLoad)) return;

    if (isInitialLoad) {
      _currentPage = 1;
      _hasMoreData = true;
      items.clear();
      notifyListeners();
    }

    _isLoading = true;
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
        final responseData = jsonDecode(response.body);
        final List<dynamic> dataList = responseData['data'];

        List<Machine> newItems =
            dataList.map((item) => Machine.fromJson(item)).toList();

        if (newItems.length < _itemsPerPage || newItems.isEmpty) {
          _hasMoreData = false;
        }

        if (newItems.isNotEmpty) {
          items.addAll(newItems);
          _currentPage++;
        }
      } else {
        throw Exception('Failed to load machines');
      }
    } catch (e) {
      throw Exception("Error fetching machines: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> refetchItems() async {
    hasMoreData = true;
    await fetchItems(isInitialLoad: true);
  }

  @override
  Future<void> addItem(Machine item, ValueNotifier<bool> isSubmitting) async {
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
        body: jsonEncode(item.toJson()),
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

  Future<void> updateStatus(
    String id,
    String status,
    ValueNotifier<bool> isSubmitting,
  ) async {
    try {
      isSubmitting.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final response = await http.patch(
        /// ✅ FIXED ENDPOINT
        Uri.parse('$baseUrl/$id/status'),

        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        await refetchItems();
        notifyListeners();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update status');
      }
    } catch (e) {
      throw Exception("Error updating status: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  Future<void> updateItem(
      String id, Machine item, ValueNotifier<bool> isSubmitting) async {
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
        body: jsonEncode(item.toJson()),
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
}
