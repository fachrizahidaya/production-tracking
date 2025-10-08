import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Dyeing {
  final int? id;
  final String? dyeing_no;
  final String? wo_no;
  final String? start_time;
  final int? start_by_id;
  final int? end_by_id;
  final String? end_time;
  final String? qty;
  final String? width;
  final String? length;
  final String? notes;
  final String? status;
  final bool? rework;
  final int? unit_id;
  final int? wo_id;
  final int? machine_id;
  final int? rework_reference_id;
  final attachments;
  final dynamic work_orders;
  final dynamic start_by;
  final dynamic end_by;

  Dyeing(
      {this.id,
      this.dyeing_no,
      this.start_time,
      this.end_time,
      this.qty,
      this.width,
      this.length,
      this.notes,
      this.status,
      this.rework,
      this.unit_id,
      this.wo_id,
      this.machine_id,
      this.rework_reference_id,
      this.start_by_id,
      this.end_by_id,
      this.attachments,
      this.wo_no,
      this.work_orders,
      this.start_by,
      this.end_by});

  factory Dyeing.fromJson(Map<String, dynamic> json) {
    return Dyeing(
      id: json['id'] as int?,
      unit_id: json['unit_id'] as int?,
      wo_id: json['wo_id'] as int?,
      machine_id: json['machine_id'] as int?,
      start_by_id: json['start_by_id'] as int?,
      end_by_id: json['end_by_id'] as int?,
      rework_reference_id: json['rework_reference_id'] as int?,
      dyeing_no: json['dyeing_no'] ?? '',
      start_time: json['start_time'] ?? '',
      end_time: json['end_time'] ?? '',
      qty: json['qty'] ?? '',
      width: json['width'] ?? '',
      length: json['length'] ?? '',
      status: json['status'] ?? '',
      rework: json['rework'] as bool?,
      notes: json['notes'] ?? '',
      attachments: json['attachments'] ?? [],
      work_orders: json['work_orders'],
      start_by: json['start_by'],
      end_by: json['end_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unit_id': unit_id,
      'wo_id': wo_id,
      'machine_id': machine_id,
      'start_by_id': start_by_id,
      'end_by_id': end_by_id,
      'rework_reference_id': rework_reference_id,
      'dyeing_no': dyeing_no,
      'start_time': start_time,
      'end_time': end_time,
      'qty': qty,
      'width': width,
      'length': length,
      'status': status,
      'rework': rework,
      'attachments': attachments,
      'work_orders': work_orders,
      'start_by': start_by,
      'end_by': end_by,
    };
  }
}

class DyeingService extends BaseService<Dyeing> {
  final String baseUrl = '${dotenv.env['API_URL_DEV']}/dyeings';

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

        List<Dyeing> newItems =
            dataList.map((item) => Dyeing.fromJson(item)).toList();

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
        throw Exception('Failed to load dyeings');
      }
    } catch (e) {
      throw Exception("Error fetching dyeings: $e");
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

  Future<List<Dyeing>> getDataList(Map<String, String> params) async {
    final url = Uri.parse(baseUrl).replace(queryParameters: params);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token').toString();

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      final responseData = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          if (responseData['data'] != null) {
            return (responseData['data'] as List)
                .map((item) => Dyeing.fromJson(item))
                .toList();
          }
          return [];
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
      Dyeing newDyeing, ValueNotifier<bool> isSubmitting) async {
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
        body: jsonEncode(newDyeing.toJson()),
      );

      if (response.statusCode == 201) {
        await refetchItems();
        notifyListeners();
        final responseData = jsonDecode(response.body);
        return responseData['message'];
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to add dyeings');
      }
    } catch (e) {
      throw Exception('Error adding dyeings: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  Future<void> updateItem(
      String id, Dyeing updatedDyeing, ValueNotifier<bool> isSubmitting) async {
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
        body: jsonEncode(updatedDyeing.toJson()),
      );

      if (response.statusCode == 200) {
        await refetchItems();
        notifyListeners();
        final responseData = jsonDecode(response.body);
        return responseData['message'];
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update dyeing');
      }
    } catch (e) {
      throw Exception("Error updating dyeing: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> finishItem(String id, Dyeing finishedDyeing,
      ValueNotifier<bool> isSubmitting) async {
    try {
      isSubmitting.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final response = await http.patch(
        Uri.parse('$baseUrl/$id/complete'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(finishedDyeing.toJson()),
      );

      if (response.statusCode == 200) {
        await refetchItems();
        notifyListeners();
        final responseData = jsonDecode(response.body);
        return responseData['message'];
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to finish dyeing');
      }
    } catch (e) {
      throw Exception("Error finishing dyeing: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> reworkItem(
      String id, Dyeing reworkDyeing, ValueNotifier<bool> isSubmitting) async {
    try {
      isSubmitting.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final response = await http.post(
        Uri.parse('$baseUrl/$id/rework'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(reworkDyeing.toJson()),
      );

      if (response.statusCode == 201) {
        await refetchItems();
        notifyListeners();
        final responseData = jsonDecode(response.body);
        return responseData['message'];
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to rework dyeing');
      }
    } catch (e) {
      throw Exception("Error rework dyeing: $e");
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
        throw Exception(errorData['message'] ?? 'Failed to delete dyeing');
      }
    } catch (e) {
      throw Exception("Error deleting dyeing: $e");
    } finally {
      isSubmitting.value = false;
    }
  }
}
