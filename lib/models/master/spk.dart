// ignore_for_file: prefer_final_fields, annotate_overrides, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Spk {
  final int? id;
  final String? spk_no;
  final String? status;
  final int? user_id;
  final int? customer_id;

  Spk({this.id, this.spk_no, this.status, this.user_id, this.customer_id});

  factory Spk.fromJson(Map<String, dynamic> json) {
    return Spk(
        id: json['id'] as int,
        spk_no: json['spk_no'] ?? '',
        status: json['status'] ?? '',
        user_id: json['user_id'] as int,
        customer_id: json['customer_id'] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spk_no': spk_no,
      'status': status,
      'user_id': user_id,
      'customer_id': customer_id
    };
  }
}

class SpkService extends BaseService<Spk> {
  final String baseUrl = '${dotenv.env['API_URL']}/spk';

  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _itemsPerPage = 20;
  List<dynamic> _dataList = [];
  Map<String, dynamic> _dataView = {};

  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;
  List<dynamic> get dataList => _dataList;
  Map<String, dynamic> get dataView => _dataView;

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

        List<Spk> newItems =
            dataList.map((item) => Spk.fromJson(item)).toList();

        if (newItems.length < _itemsPerPage) {
          hasMoreData = false;
        }

        final existingIds = items.map((e) => e.id).toSet();
        for (var newItem in newItems) {
          if (!existingIds.contains(newItem.id)) {
            items.add(newItem);
          }
        }
        // items.addAll(newItems);

        if (newItems.isNotEmpty) {
          _currentPage++;
        } else {
          hasMoreData = false;
        }
      } else {
        throw Exception('Failed to load spk');
      }
    } catch (e) {
      throw Exception("Error fetching spk: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDataView(id) async {
    final url = Uri.parse('$baseUrl/$id');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token').toString();

    try {
      _dataView = {};
      notifyListeners();

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      final responseData = json.decode(response.body);
      switch (response.statusCode) {
        case 200:
          if (responseData != null) {
            _dataView = responseData as Map<String, dynamic>;
          }
          notifyListeners();
          break;
        default:
          throw responseData['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getDataList(Map<String, dynamic> params) async {
    final url = Uri.parse(baseUrl).replace(queryParameters: params);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token').toString();

    try {
      _dataList.clear();
      notifyListeners();

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });
      final responseData = jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          if (responseData['data'] != null) {
            _dataList = responseData['data'];
          }
          notifyListeners();
          break;
        default:
          throw responseData['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> refetchItems() async {
    hasMoreData = true;
    await fetchItems(isInitialLoad: true);
  }

  @override
  Future<void> addItem(Spk item, ValueNotifier<bool> isSubmitting) async {
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
        throw Exception(errorData['message'] ?? 'Failed to add spk');
      }
    } catch (e) {
      throw Exception('Error adding spk: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  Future<void> updateItem(
      String id, Spk item, ValueNotifier<bool> isSubmitting) async {
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
        throw Exception(errorData['message'] ?? 'Failed to update spk');
      }
    } catch (e) {
      throw Exception("Error updating spk: $e");
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
        throw Exception(errorData['message'] ?? 'Failed to delete spk');
      }
    } catch (e) {
      throw Exception("Error deleting spk: $e");
    } finally {
      isSubmitting.value = false;
    }
  }
}
