// ignore_for_file: prefer_final_fields, non_constant_identifier_names, annotate_overrides

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:http/http.dart' as http;

class WorkOrderProcess {
  final int? id;
  final String? spk_no;
  final String? wo_no;
  final String? status;
  final String? wo_date;
  final int? wo_qty;
  final String? greige_qty;
  final processes;
  final grades;

  WorkOrderProcess(
      {this.id,
      this.spk_no,
      this.wo_no,
      this.status,
      this.wo_date,
      this.wo_qty,
      this.greige_qty,
      this.processes,
      this.grades});

  factory WorkOrderProcess.fromJson(Map<String, dynamic> json) {
    return WorkOrderProcess(
      id: json['id'] as int?,
      spk_no: json['spk_no'] ?? '',
      wo_no: json['wo_no'] ?? '',
      status: json['status'] ?? '',
      wo_date: json['wo_date'] ?? '',
      wo_qty: json['wo_qty'] as int?,
      greige_qty: json['greige_qty'] ?? '',
      processes: json['processes'] ?? {},
      grades: json['grades'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spk_no': spk_no,
      'wo_no': wo_no,
      'status': status,
      'wo_date': wo_date,
      'wo_qty': wo_qty,
      'greige_qty': greige_qty,
      'processes': processes,
      'grades': grades,
    };
  }
}

class WorkOrderProcessService extends BaseService {
  final String baseUrl = '${dotenv.env['API_URL']}/dashboard/wo-process';

  bool _isLoading = false;
  List<dynamic> _dataProcess = [];
  List<dynamic> _dataPie = [];
  bool get isLoading => _isLoading;
  List<dynamic> get dataProcess => _dataProcess;
  List<dynamic> get dataPie => _dataPie;

  @override
  Future<void> fetchItems(
      {bool isInitialLoad = false, String? searchQuery = ''}) async {}

  @override
  Future<void> refetchItems() async {
    hasMoreData = true;
    await fetchItems(isInitialLoad: true);
  }

  @override
  Future<void> addItem(item, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> updateItem(
      String id, item, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> deleteItem(String id, ValueNotifier<bool> isSubmitting) async {}

  Future<void> fetchWorkOrderProcess({
    bool isInitialLoad = false,
    String? searchQuery = '',
  }) async {}

  Future<void> refetchWOProcess() async {
    await fetchWorkOrderProcess(isInitialLoad: true);
  }

  Future<List<WorkOrderProcess>> getDataProcess(
      Map<String, String?> params) async {
    final cleanParams = Map<String, String>.fromEntries(
      params.entries
          .where((e) => e.value != null && e.value!.isNotEmpty)
          .map((e) => MapEntry(e.key, e.value!)),
    );

    final url = Uri.parse(baseUrl).replace(queryParameters: cleanParams);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token') ?? '';

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });
      final responseData = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          if (responseData['data'] != null) {
            return (responseData['data'] as List)
                .map((item) => WorkOrderProcess.fromJson(item))
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
}
