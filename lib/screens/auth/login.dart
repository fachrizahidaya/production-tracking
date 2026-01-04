// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:textile_tracking/components/master/form/login/login_form.dart';
import 'package:textile_tracking/helpers/auth/storage.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final username = prefs.getString('username');
    final id = prefs.getString('user_id');

    if (token != null && !JwtDecoder.isExpired(token)) {
      if (context.mounted) {
        Provider.of<UserProvider>(context, listen: false)
            .handleLogin(username ?? '', token, id ?? '');
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } else {
      await prefs.remove('access_token');
      await prefs.remove('username');
      await prefs.remove('user_id');
    }
  }

  Future<void> _handleSubmit(BuildContext context) async {
    final String username = _username.text;
    final String password = _password.text;

    String url = '${dotenv.env['API_URL']}/login';

    try {
      setState(() {
        _isLoading = true;
      });

      final res = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'username': username, 'password': password}));

      if (res.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(res.body);

        if (response['access_token'] != null) {
          final String username = response['username'] ?? '';
          final String token = response['access_token'] ?? '';
          final String id = response['user_id'].toString();

          // final String userId = response['user_id'].toString();
          // final String name = response['name'] ?? '';

          // StoreProvider.of<AppState>(context)
          //     .dispatch(LoginAction(username, token));

          // final menus = await MenuService().handleFetchMenu();

          await Storage.instance.insertUserData(response);
          await MenuService().handleFetchMenu();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', token);

          if (context.mounted) {
            Provider.of<UserProvider>(context, listen: false)
                .handleLogin(username, token, id);
            Navigator.pushReplacementNamed(context, '/dashboard');
            _username.clear();
            _password.clear();
          }
        } else {
          if (context.mounted) {
            showAlertDialog(
                context: context, title: 'Error', message: 'Login error');
          }
        }
      } else {
        if (context.mounted) {
          showAlertDialog(
              context: context,
              title: 'Error',
              message: 'Invalid username or password');
        }
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEBEBEB),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
        ));
  }
}
