// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/components/master/form/login/login_form.dart';
import 'package:textile_tracking/helpers/auth/storage.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/providers/api_client.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/auth/user_menu.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final _key = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _handleCheckLogin();

    _username.addListener(_handleValidateForm);
    _password.addListener(_handleValidateForm);
  }

  void _handleValidateForm() {
    final isValid = _username.text.isNotEmpty && _password.text.isNotEmpty;
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  Future<void> _handleCheckLogin() async {
    final token = await ApiClient.instance.getValidToken(context);

    if (!context.mounted) return;

    if (token != null) {
      final prefs = await SharedPreferences.getInstance();

      Provider.of<UserProvider>(context, listen: false).handleLogin(
        prefs.getString('username') ?? '',
        prefs.getString('name') ?? '',
        token,
        // prefs.getString('user_id') ?? '',
      );

      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  Future<void> _handleSubmit(BuildContext context) async {
    final username = _username.text.trim();
    final password = _password.text.trim();

    final url = Uri.parse('${dotenv.env['API_URL_DEV']}/login');

    try {
      setState(() => _isLoading = true);

      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (res.statusCode != 200) {
        _showError(context, 'Invalid username or password');
        return;
      }

      final response = jsonDecode(res.body);

      final token = response['access_token'];
      if (token == null) {
        _showError(context, 'Login failed');
        return;
      }

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('access_token', token);
      await prefs.setString('username', response['username'] ?? '');
      await prefs.setString('name', response['name'] ?? '');
      // await prefs.setString('user_id', response['user_id'].toString());

      // save to SQLite (optional but fine)
      await Storage.instance.insertUserData(response);

      // preload menus (optional)
      await MenuService().handleFetchMenu(context);

      if (!context.mounted) return;

      Provider.of<UserProvider>(context, listen: false).handleLogin(
        response['username'] ?? '',
        response['name'] ?? '',
        token,
        // response['user_id'].toString(),
      );

      Navigator.pushReplacementNamed(context, '/dashboard');
      _username.clear();
      _password.clear();
    } catch (e) {
      _showError(context, 'Something went wrong');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(BuildContext context, String message) {
    if (!context.mounted) return;
    showAlertDialog(
      context: context,
      title: 'Error',
      message: message,
    );
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          // 🔹 Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/login-bg.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // 🔹 Your existing UI
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: LoginForm(
                    key: _key,
                    username: _username,
                    password: _password,
                    isDisabled: !_isFormValid,
                    isLoading: _isLoading,
                    handlePress: () {
                      _handleSubmit(context);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
