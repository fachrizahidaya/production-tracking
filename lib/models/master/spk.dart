import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SpkService extends ChangeNotifier {
  final String baseUrl = '${dotenv.env['API_URL']}/spk';

  Map<String, dynamic> _dataView = {};

  Map<String, dynamic> get dataView => _dataView;

  Future<void> getDataView(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token').toString();
    final url = Uri.parse('$baseUrl/$id');

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

  Future<Map<String, dynamic>> getDocuments(String id) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/$id/documents'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        responseData['data'] ?? {},
      );
    }

    throw responseData['message'];
  }
}
