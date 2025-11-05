import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WorkOrder {
  final int? id;
  final String? wo_no;
  final String? greige_qty;
  final String? notes;
  final String? status;
  final int? greige_unit_id;

  WorkOrder(
      {this.id,
      this.wo_no,
      this.greige_qty,
      this.notes,
      this.status,
      this.greige_unit_id});

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    return WorkOrder(
        id: json['id'] as int,
        wo_no: json['wo_no'] ?? '',
        greige_qty: json['greige_qty'],
        notes: json['notes'] ?? '',
        status: json['status'] ?? '',
        greige_unit_id: json['greige_unit_id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wo_no': wo_no,
      'greige_qty': greige_qty,
      'notes': notes,
      'status': status,
      'greige_unit_id': greige_unit_id
    };
  }
}

class WorkOrderService extends BaseService<WorkOrder> {
  final String baseUrl = '${dotenv.env['API_URL_DEV']}/work-orders';

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

        List<WorkOrder> newItems =
            dataList.map((item) => WorkOrder.fromJson(item)).toList();

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
        throw Exception('Failed to load work orders');
      }
    } catch (e) {
      throw Exception("Error fetching work orders: $e");
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
  Future<void> addItem(
      WorkOrder newWorkOrder, ValueNotifier<bool> isSubmitting) async {
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
        body: jsonEncode(newWorkOrder.toJson()),
      );

      if (response.statusCode == 200) {
        await refetchItems();
        notifyListeners();
        final responseData = jsonDecode(response.body);
        return responseData['message'];
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to add work orders');
      }
    } catch (e) {
      throw Exception('Error adding work orders: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<Map<String, dynamic>?> getProcessData(
      Map<String, dynamic> woForm, ValueNotifier<bool> isSubmitting) async {
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
        body: jsonEncode(woForm),
      );

      if (response.statusCode == 201) {
        await refetchItems();
        notifyListeners();
        final responseData = jsonDecode(response.body);
        return responseData; // ✅ return full JSON
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to get data');
      }
    } catch (e) {
      throw Exception('Error get data: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  Future<void> updateItem(String id, WorkOrder updatedWorkOrder,
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
        body: jsonEncode(updatedWorkOrder.toJson()),
      );

      if (response.statusCode == 200) {
        await refetchItems();
        notifyListeners();
        final responseData = jsonDecode(response.body);
        return responseData['message'];
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update work order');
      }
    } catch (e) {
      throw Exception("Error updating work order: $e");
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
        throw Exception(errorData['message'] ?? 'Failed to delete work order');
      }
    } catch (e) {
      throw Exception("Error deleting work order: $e");
    } finally {
      isSubmitting.value = false;
    }
  }
}
