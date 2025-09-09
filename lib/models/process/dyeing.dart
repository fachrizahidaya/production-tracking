import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:production_tracking/helpers/service/base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Dyeing {
  final int? id;
  final String? dyeing_no;
  final String? start_time;
  final String? end_time;
  final String? qty;
  final String? width;
  final String? length;
  final String? notes;
  final String? status;
  final bool? rework;

  Dyeing({
    this.id,
    this.dyeing_no,
    this.start_time,
    this.end_time,
    this.qty,
    this.width,
    this.length,
    this.notes,
    this.status,
    this.rework,
  });

  factory Dyeing.fromJson(Map<String, dynamic> json) {
    return Dyeing(
      id: json['id'] as int,
      dyeing_no: json['dyeing_no'] ?? '',
      start_time: json['start_time'] ?? '',
      end_time: json['end_time'] ?? '',
      qty: json['qty'] ?? '',
      width: json['width'] ?? '',
      length: json['length'] ?? '',
      status: json['status'] ?? '',
      rework: json['rework'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dyeing_no': dyeing_no,
      'start_time': start_time,
      'end_time': end_time,
      'qty': qty,
      'width': width,
      'length': length,
      'status': status,
      'rework': rework,
    };
  }
}

class DyeingService extends BaseService<Dyeing> {
  final String baseUrl = '${dotenv.env['API_URL_DEV']}/dyeings';

  int _currentPage = 1;
  final int _itemsPerPage = 20;

  @override
  Future<void> fetchItems(
      {bool isInitialLoad = false, String? searchQuery = ''}) async {
    if (isLoading || (!hasMoreData && !isInitialLoad)) return;

    if (isInitialLoad) {
      _currentPage = 1;
      hasMoreData = true;
      items.clear();
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

        items.addAll(newItems);
        _currentPage++;
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

      if (response.statusCode == 200) {
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
