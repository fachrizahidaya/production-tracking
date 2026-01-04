import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/helpers/auth/storage.dart';
import 'package:http/http.dart' as http;

class MenuService {
  MenuService();

  Future<List<dynamic>> handleFetchMenu() async {
    try {
      String? token = await Storage.instance.getAccessToken();

      final url = Uri.parse('${dotenv.env['API_URL']}/menus');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> menus = data['data'] ?? [];

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
