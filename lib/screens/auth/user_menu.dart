import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/helpers/auth/storage.dart';
import 'package:textile_tracking/providers/api_client.dart';

class MenuService {
  MenuService();

  Future<List<dynamic>> handleFetchMenu(BuildContext context) async {
    try {
      final url = Uri.parse('${dotenv.env['API_URL_DEV']}/menus');

      final response = await ApiClient.instance.get(
        context,
        url,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> menus = data['data'] ?? [];

        await Storage.instance.insertMenus(menus);
        return menus;
      } else {
        throw Exception('Failed to fetch menus: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching menus: $e');
    }
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

  bool _searchMenu(List<dynamic> menuList, String name, String action) {
    for (var menu in menuList) {
      if (menu['name'] == name) {
        final List<dynamic> actions = menu['actions'] ?? [];
        return actions.contains(action);
      }

      if (menu['children'] != null && menu['children'].isNotEmpty) {
        bool found = _searchMenu(menu['children'], name, action);
        if (found) return true;
      }
    }
    return false;
  }
}
