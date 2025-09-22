import 'package:flutter/material.dart';
import 'package:production_tracking/helpers/auth/storage.dart';
import 'package:production_tracking/models/master/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _user != null;

  UserProvider() {
    _handleLoadUserFromPrefs();
  }

  Future<void> _handleLoadUserFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('access_token');

    if (_token != null) {
      String? username = prefs.getString('username');

      if (username != null) {
        _user = User(username: username, token: token!);
      }
      notifyListeners();
    }
  }

  void handleLogin(String username, String token) async {
    _user = User(username: username, token: token);
    _token = token;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('access_token', token);

    notifyListeners();
  }

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  Future<void> handleLogout() async {
    _user = null;
    _token = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('access_token');

    await Storage.instance.clearUserData();
    await Storage.instance.clearMenus();
  }
}
