import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/helpers/auth/storage.dart';
import 'package:textile_tracking/providers/api_client.dart';

class MenuService {
  MenuService();

  Future<List<dynamic>> handleFetchMenu(BuildContext context) async {
    try {
      final url = Uri.parse('${dotenv.env['API_URL']}/user-menus');

      final response = await ApiClient.instance.get(context, url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> menus = _normalizeMenus(decoded);

        await Storage.instance.insertMenus(menus);
        return menus;
      } else {
        throw Exception('Failed to fetch menus: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching menus: $e');
    }
  }

  List<dynamic> _normalizeMenus(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is! Map) return [];

    final data = decoded['data'];
    if (data is List) return data;
    if (data is Map) return [data];

    // /user-menus may return a single root menu object.
    if (decoded['name'] != null) return [decoded];
    return [];
  }
}

class UserMenu {
  List<dynamic> menus = [];

  UserMenu();

  Future<void> handleLoadMenu() async {
    menus = await Storage.instance.getMenus();
  }

  bool checkMenu(String name, String action) {
    try {
      return _searchMenu(menus, name, action);
    } catch (e) {
      throw Exception('Error checking action: $e');
    }
  }

  bool _searchMenu(dynamic menuList, String name, String action) {
    if (menuList is Map) {
      return _searchMenu([menuList], name, action);
    }
    if (menuList is! List) return false;

    for (final menu in menuList) {
      if (menu is! Map) continue;

      if (menu['name'] == name) {
        return _hasAction(menu['actions'], action);
      }

      final children = menu['children'];
      if (_searchMenu(children, name, action)) return true;
    }
    return false;
  }

  bool _hasAction(dynamic actions, String action) {
    if (actions is Map) return actions[action] == true;
    if (actions is List) return actions.contains(action);
    return false;
  }
}
