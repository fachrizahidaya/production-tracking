import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';
  static const String _legacyTokenKey = 'access_token';
  static const String _usernameKey = 'username';
  static const String _nameKey = 'name';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _roleMenuKey = 'role_menu_data';
  static const String _userModulesKey = 'user_module';
  static const String _activeModuleKey = 'active_module';

  // Save user data
  static Future<bool> saveUser(Map<String, dynamic> user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user);
      await prefs.setString(_userKey, userJson);

      if (user['access_token'] != null) {
        final token = user['access_token'].toString();
        await prefs.setString(_tokenKey, token);
        await prefs.setString(_legacyTokenKey, token);
      }

      if (user['refresh_token'] != null) {
        await prefs.setString(
            _refreshTokenKey, user['refresh_token'].toString());
      }

      if (user['username'] != null) {
        await prefs.setString(_usernameKey, user['username'].toString());
      }

      if (user['name'] != null) {
        await prefs.setString(_nameKey, user['name'].toString());
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    try {
      if (userJson != null) {
        final Map<String, dynamic> userMap = jsonDecode(userJson);
        return userMap;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Get token
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey) ?? prefs.getString(_legacyTokenKey);
    } catch (e) {
      return null;
    }
  }

  // Get dbc

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Clear all data (logout)
  static Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_tokenKey);
      await prefs.remove(_legacyTokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove(_usernameKey);
      await prefs.remove(_nameKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    } catch (e) {
      return null;
    }
  }

  // Check if token is expired using JWT
  static Future<bool> isTokenExpired() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return true;
      }

      // Decode JWT and check expiration
      final jwt = JWT.decode(token);
      final payload = jwt.payload as Map<String, dynamic>;

      if (payload.containsKey('exp')) {
        final exp = payload['exp'] as int;
        final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        return DateTime.now().isAfter(expiryDate);
      }

      return true;
    } catch (e) {
      return true;
    }
  }

  // clear module data
  static Future<bool> clearModuleData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_roleMenuKey);
      await prefs.remove(_userModulesKey);
      await prefs.remove(_activeModuleKey);

      return true;
    } catch (e) {
      return false;
    }
  }

// Save user modules
  static Future<bool> saveUserModules(userModules) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modulesJson = jsonEncode(userModules);
      await prefs.setString(_userModulesKey, modulesJson);
      await prefs.setString(_activeModuleKey, jsonEncode(userModules[0]));

      return true;
    } catch (e) {
      return false;
    }
  }

  // Save role menu
  static Future<bool> saveRoleMenu(roleMenu) async {
    try {
      // looping roleMenu
      final List<dynamic> result = [];

      if (roleMenu.containsKey('menu')) {
        final List<dynamic> menuList = roleMenu['menu'];
        for (var item in menuList) {
          if (item['sub'] != null && item['sub'].isNotEmpty) {
            for (var subItem in item['sub']) {
              if (subItem['is_mobile'] == true) {
                result.add(subItem);
              }
            }
          } else {
            if (item['is_mobile'] == true) {
              result.add(item);
            }
          }
        }
      }

      final prefs = await SharedPreferences.getInstance();
      final roleMenuJson = jsonEncode(result);
      await prefs.setString(_roleMenuKey, roleMenuJson);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> saveKssCredential({
    required String token,
    required String dbc,
  }) async {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }
}
