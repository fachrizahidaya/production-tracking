// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:textile_tracking/helpers/service/token_service.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/auth/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _handleCheckLogin();
  }

  Future<void> _handleCheckLogin() async {
    final token = await TokenService.instance.getValidToken(context);

    if (mounted) {
      setState(() {
        _isAuthenticated = token != null;
      });
    }
  }

  bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      });
      return const SizedBox.shrink();
    } else {
      return const Login();
    }
  }
}
