import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:production_tracking/components/auth/login_form.dart';
import 'package:production_tracking/helpers/result/show_alert_dialog.dart';
import 'package:production_tracking/providers/user_provider.dart';
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
    final token = prefs.getString('token');
    final username = prefs.getString('username');

    if (token != null) {
      if (context.mounted) {
        Provider.of<UserProvider>(context, listen: false)
            .handleLogin(username ?? '', token);
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    }
  }

  Future<void> _handleSubmit(BuildContext context) async {
    final String username = _username.text;
    final String password = _password.text;

    String url = '${dotenv.env['API_URL']}/login';

    Navigator.pushReplacementNamed(context, '/dashboard');

    // try {
    //   setState(() {
    //     _isLoading = true;
    //   });

    //   final res = await http.post(Uri.parse(url),
    //       headers: {'Content-Type': 'application/json'},
    //       body: jsonEncode({'username': username, 'password': password}));

    //   if (res.statusCode == 200) {
    //     final Map<String, dynamic> response = jsonDecode(res.body);

    //     if (response['token'] != null) {
    //       final String email = response['username'] ?? '';
    //       final String token = response['token'] ?? '';

    //       SharedPreferences prefs = await SharedPreferences.getInstance();
    //       await prefs.setString('token', token);

    //       if (context.mounted) {
    //         Provider.of<UserProvider>(context, listen: false)
    //             .handleLogin(email, token);
    //         Navigator.pushReplacementNamed(context, '/dashboard');
    //         _username.clear();
    //         _password.clear();
    //       }
    //     } else {
    //       if (context.mounted) {
    //         showAlertDialog(
    //             context: context, title: 'Error', message: 'Login failed');
    //       }
    //     }
    //   } else {
    //     if (context.mounted) {
    //       showAlertDialog(
    //           context: context,
    //           title: 'Error',
    //           message: 'Invalid username or password');
    //     }
    //   }
    // } catch (e) {
    //   throw Exception(e);
    // } finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoginForm(
      username: _username,
      password: _password,
      isDisabled: !_isFormValid,
      isLoading: _isLoading,
      handlePress: () {
        _handleSubmit(context);
        // if (!_isLoading && !_isFormValid) {
        //   null;
        // } else {
        //   if (_key.currentState!.validate()) {
        //     _handleSubmit(context);
        //   } else {
        //     null;
        //   }
        // }
      },
    );
  }
}
