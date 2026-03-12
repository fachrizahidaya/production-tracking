// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static final ApiClient instance = ApiClient._();
  ApiClient._();

  Future<String?> getValidToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) return null;

    if (!JwtDecoder.isExpired(token)) {
      return token;
    }

    return await _refreshToken(context);
  }

  Future<String?> _refreshToken(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final oldToken = prefs.getString('access_token');

      final url = Uri.parse('${dotenv.env['API_URL_DEV']}/refresh-token');

      final res = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $oldToken',
          'Accept': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final newToken = body['access_token'];

        await prefs.setString('access_token', newToken);

        Provider.of<UserProvider>(context, listen: false).setToken(newToken);

        return newToken;
      }

      await _forceLogout(context);
      return null;
    } catch (_) {
      await _forceLogout(context);
      return null;
    }
  }

  Future<void> _forceLogout(BuildContext context) async {
    await Provider.of<UserProvider>(context, listen: false).handleLogout();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (route) => false,
      );
    }
  }

  /* ---------------- HTTP METHODS ---------------- */

  Future<http.Response> get(
    BuildContext context,
    Uri url,
  ) async {
    final token = await getValidToken(context);
    if (token == null) throw Exception('Unauthenticated');

    return http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
  }

  Future<http.Response> post(
    BuildContext context,
    Uri url, {
    Object? body,
  }) async {
    final token = await getValidToken(context);
    if (token == null) throw Exception('Unauthenticated');

    return http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );
  }

  Future<http.Response> delete(
    BuildContext context,
    Uri url,
  ) async {
    final token = await getValidToken(context);
    if (token == null) throw Exception('Unauthenticated');

    return http.delete(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
  }

  Future<http.StreamedResponse> multipart(
    BuildContext context,
    http.MultipartRequest request,
  ) async {
    final token = await (context);
    if (token == null) throw Exception('Unauthenticated');

    request.headers['Authorization'] = 'Bearer $token';
    return request.send();
  }
}
