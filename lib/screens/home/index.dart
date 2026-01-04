// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/components/master/layout/drawer/app_drawer.dart';
import 'package:textile_tracking/components/master/layout/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/auth/user_menu.dart';
import 'package:textile_tracking/screens/dashboard/index.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  String user = '';

  @override
  void initState() {
    final loggedInUser = Provider.of<UserProvider>(context, listen: false).user;
    super.initState();

    setState(() {
      user = loggedInUser?.username ?? '';
    });
  }

  Future<void> _handleExit(
      BuildContext context, ValueNotifier<bool> isLoading) async {
    String url = '${dotenv.env['API_URL']}/logout';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token != null) {
      try {
        isLoading.value = true;

        final res = await http.post(Uri.parse(url),
            headers: {'Authorization': 'Bearer $token'}, body: null);
        await prefs.remove('access_token');

        if (res.statusCode == 200) {
          if (context.mounted) {
            Provider.of<UserProvider>(context, listen: false).handleLogout();

            await Future.delayed(const Duration(milliseconds: 200));
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          } else {
            if (context.mounted) {
              showAlertDialog(
                  context: context, title: 'Error', message: 'Logout failed');
            }
          }
        }
      } catch (e) {
        throw Exception(e);
      } finally {
        isLoading.value = false;
      }
    } else {
      showAlertDialog(
          context: context, title: 'Error', message: 'Logout failed');
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    if (context.mounted) {
      showConfirmationDialog(
          context: context,
          isLoading: _isLoading,
          onConfirm: () {
            _handleExit(context, _isLoading);
          },
          title: 'Log Out',
          message: 'Anda yakin ingin keluar aplikasi?',
          buttonBackground: CustomTheme().buttonColor('danger'));
    }
  }

  Future<List<MenuItem>> _handleFetchMenu() async {
    UserMenu userMenu = UserMenu();
    await userMenu.handleLoadMenu();

    try {
      List<dynamic> menuData = userMenu.menus;

      final filteredData = menuData
          .where((menu) =>
              menu['name'] != 'SPK & Work Order' &&
              menu['name'] != 'Pelanggan' &&
              menu['name'] != 'Mesin' &&
              menu['name'] != 'Barang' &&
              menu['name'] != 'Satuan' &&
              menu['name'] != 'Grade Barang' &&
              menu['name'] != 'Material' &&
              menu['name'] != 'Grade Material' &&
              menu['name'] != 'Master Data' &&
              menu['name'] != 'User Management')
          .toList();

      return filteredData
          .map<MenuItem>((item) => MenuItem.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: SharedPreferences.getInstance()
            .then((prefs) => prefs.getString('access_token')),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text('Error fetch token'),
            );
          }

          return Scaffold(
            appBar: CustomAppBar(
              title: 'Textile Tracking',
              isWithNotification: true,
              handleLogout: () => _handleLogout(context),
              isWithAccount: true,
              user: user,
            ),
            drawer: AppDrawer(
              handleLogout: () => _handleLogout(context),
              handleFetchMenu: () => _handleFetchMenu(),
            ),
            body: Dashboard(),
          );
        });
  }
}

class MenuItem {
  final String title;
  final String? route;
  final List<SubMenuItem> subMenuItems;

  MenuItem({
    required this.title,
    this.route,
    this.subMenuItems = const [],
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    final children = json['children'] as List<dynamic>? ?? [];
    return MenuItem(
      title: json['name'] ?? '',
      route: json['url'], // can be null
      subMenuItems:
          children.map((child) => SubMenuItem.fromJson(child)).toList(),
    );
  }
}

class SubMenuItem {
  final String title;
  final String? route;

  SubMenuItem({
    required this.title,
    this.route,
  });

  factory SubMenuItem.fromJson(Map<String, dynamic> json) {
    return SubMenuItem(
      title: json['name'] ?? '',
      route: json['url'], // can be null
    );
  }
}
