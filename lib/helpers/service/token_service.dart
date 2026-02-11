import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:http/http.dart' as http;

class TokenService {
  static final TokenService instance = TokenService._();
  TokenService._();

  Future<String?> getValidToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) return null;

    // token still valid
    if (!JwtDecoder.isExpired(token)) {
      return token;
    }

    // token expired → try refresh
    return await _refreshToken(context);
  }

  Future<String?> _refreshToken(BuildContext context) async {
    try {
      final url = '${dotenv.env['API_URL_DEV']}/refresh-token';

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final oldToken = prefs.getString('access_token');

      final res = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $oldToken',
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final newToken = body['access_token'];

        // save new token
        await prefs.setString('access_token', newToken);

        // update provider
        Provider.of<UserProvider>(context, listen: false).setToken(newToken);

        return newToken;
      } else {
        await _forceLogout(context);
        return null;
      }
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
}
