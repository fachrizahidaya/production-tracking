import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:production_tracking/helpers/auth/storage.dart';
import 'package:http/http.dart' as http;

class MenuService {
  MenuService();

  Future<List<dynamic>> handleFetchMenu() async {
    try {
      String? token = await Storage.instance.getAccessToken();

      final url = Uri.parse('${dotenv.env['API_URL_DEV']}/menus');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> menus = data ?? [];

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
      final menu = menus.firstWhere(
        (m) => m['name'] == name,
        orElse: () => null,
      );

      if (menu == null) return false;

      final List<dynamic> actions = menu['actions'] ?? [];

      return actions.contains(action);
    } catch (e) {
      throw Exception('Error checking action: $e');
    }
  }
}
