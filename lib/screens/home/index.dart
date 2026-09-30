// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/components/master/drawer/app_drawer.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/auth/user_menu.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:textile_tracking/screens/dashboard/index.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  String user = '';
  String name = '';
  int _reworkNotificationCount = 0;
  int _bsNotificationCount = 0;
  bool _canViewReworkEvaluation = false;
  bool _canViewBsEvaluation = false;
  late Future<String?> _tokenFuture;

  @override
  void initState() {
    final loggedInUser = Provider.of<UserProvider>(context, listen: false).user;
    super.initState();
    _tokenFuture = SharedPreferences.getInstance()
        .then((prefs) => prefs.getString('access_token'));

    setState(() {
      user = loggedInUser?.username ?? '';
      name = loggedInUser?.name ?? '';
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMenuAccess();
    });
  }

  Future<void> _initializeMenuAccess() async {
    final userMenu = UserMenu();
    await userMenu.handleLoadMenu();

    final canViewReworkEvaluation = _hasMobileMenu(
      userMenu.menus,
      'Evaluasi Rework',
    );
    final canViewBsEvaluation = _hasMobileMenu(
      userMenu.menus,
      'Evaluasi BS',
    );

    if (!mounted) return;

    setState(() {
      _canViewReworkEvaluation = canViewReworkEvaluation;
      _canViewBsEvaluation = canViewBsEvaluation;
    });

    await _refreshEvaluationNotifications();
  }

  bool _hasMobileMenu(List<dynamic> menus, String targetName) {
    for (final menu in menus) {
      final name = menu['name']?.toString().toLowerCase();
      if (name == targetName.toLowerCase()) {
        return menu['allow_mobile'] == true;
      }

      final children = menu['children'];
      if (children is List && _hasMobileMenu(children, targetName)) {
        return true;
      }
    }

    return false;
  }

  Future<void> _fetchReworkNotificationCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final baseUrl = dotenv.env['API_URL'] ?? '';
      final response = await http.get(
        Uri.parse('$baseUrl/dyeing-rework-evaluations/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200 || !mounted) return;

      final responseData = jsonDecode(response.body);
      final count = responseData['data']?['count'];
      setState(() {
        _reworkNotificationCount = int.tryParse(count?.toString() ?? '') ?? 0;
      });
    } catch (_) {
      // Badge tetap tersembunyi jika endpoint notifikasi tidak tersedia.
    }
  }

  Future<void> _fetchBsNotificationCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final baseUrl = dotenv.env['API_URL'] ?? '';
      final response = await http.get(
        Uri.parse('$baseUrl/bs-evaluations/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200 || !mounted) return;

      final responseData = jsonDecode(response.body);
      final count = responseData['data']?['count'];
      setState(() {
        _bsNotificationCount = int.tryParse(count?.toString() ?? '') ?? 0;
      });
    } catch (_) {
      // Badge tetap tersembunyi jika endpoint notifikasi tidak tersedia.
    }
  }

  Future<void> _refreshEvaluationNotifications() async {
    final futures = <Future>[];
    if (_canViewReworkEvaluation) {
      futures.add(_fetchReworkNotificationCount());
    }
    if (_canViewBsEvaluation) {
      futures.add(_fetchBsNotificationCount());
    }
    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
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

        if (res.statusCode == 200) {
          if (context.mounted) {
            await Provider.of<UserProvider>(context, listen: false)
                .handleLogout();

            await Future.delayed(Duration(milliseconds: 200));
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
              menu['name'] != 'User Management' &&
              menu['name'] != 'Persiapan Dyeing')
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
        future: _tokenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text('Error fetch token'),
            );
          }

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                SystemNavigator.pop();
              }
            },
            child: Scaffold(
              appBar: CustomAppBar(
                title: 'TexTrack',
                isWithNotification: _canViewReworkEvaluation,
                reworkNotificationCount: _reworkNotificationCount,
                onReworkNotifications: () {
                  Navigator.pushNamed(context, '/dyeing-rework-evaluations');
                },
                isWithBsNotification: _canViewBsEvaluation,
                bsNotificationCount: _bsNotificationCount,
                onBsNotifications: () {
                  Navigator.pushNamed(context, '/bs-evaluations');
                },
                handleLogout: () => _handleLogout(context),
                isWithAccount: true,
                user: user,
                name: name,
                showAvatar: MediaQuery.sizeOf(context).shortestSide >= 600,
                showNameWithAvatar:
                    MediaQuery.sizeOf(context).shortestSide >= 600,
              ),
              drawer: AppDrawer(
                handleLogout: () => _handleLogout(context),
                handleFetchMenu: () => _handleFetchMenu(),
              ),
              body: SafeArea(
                child: Dashboard(
                  onRefreshReworkNotifications: _refreshEvaluationNotifications,
                ),
              ),
            ),
          );
        });
  }
}

class MenuItem {
  final String title;
  final String? route;
  final List<SubMenuItem> subMenuItems;
  final bool allowMobile;

  MenuItem({
    required this.title,
    this.route,
    this.subMenuItems = const [],
    required this.allowMobile,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    final children = json['children'] as List<dynamic>? ?? [];

    return MenuItem(
      title: json['name'] ?? '',
      route: json['url'],
      allowMobile: json['allow_mobile'] ?? false,
      subMenuItems:
          children.map((child) => SubMenuItem.fromJson(child)).toList(),
    );
  }
}

class SubMenuItem {
  final String title;
  final String? route;
  final bool allowMobile;

  SubMenuItem({
    required this.title,
    this.route,
    required this.allowMobile,
  });

  factory SubMenuItem.fromJson(Map<String, dynamic> json) {
    return SubMenuItem(
      title: json['name'] ?? '',
      route: json['url'],
      allowMobile: json['allow_mobile'] ?? false,
    );
  }
}
