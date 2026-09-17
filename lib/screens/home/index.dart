// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/components/master/drawer/app_drawer.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
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
  static const Set<String> _supportedDashboardWidgets = {
    'process_summary',
    'machine_status',
    'wo_list',
  };

  String user = '';
  String name = '';
  late Future<String?> _tokenFuture;
  final Map<String, bool> _dashboardWidgets = {
    'process_summary': false,
    'machine_status': false,
    'wo_list': false,
  };
  List<Map<String, dynamic>> _dashboardWidgetOptions = [];
  bool _isDashboardWidgetsLoading = true;
  bool _isDashboardWidgetsUpdating = false;

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
      _fetchDashboardWidgets();
    });
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('Unauthenticated');
    }

    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  Future<void> _fetchDashboardWidgets() async {
    if (mounted) {
      setState(() {
        _isDashboardWidgetsLoading = true;
      });
    }

    try {
      final baseUrl = dotenv.env['API_URL'] ?? '';
      final headers = await _getAuthHeaders();
      final keysResponse = await http.get(
        Uri.parse('$baseUrl/dashboard/widget-keys'),
        headers: headers,
      );

      if (keysResponse.statusCode != 200) {
        throw Exception('Gagal mengambil daftar widget dashboard');
      }

      final widgetsResponse = await http.get(
        Uri.parse('$baseUrl/dashboard/widgets'),
        headers: headers,
      );

      if (widgetsResponse.statusCode != 200) {
        throw Exception('Gagal mengambil pengaturan widget dashboard');
      }

      final keyData = List<Map<String, dynamic>>.from(
        jsonDecode(keysResponse.body)['data'] ?? [],
      );
      final widgetData = List<Map<String, dynamic>>.from(
        jsonDecode(widgetsResponse.body)['data'] ?? [],
      );
      final visibilityByValue = {
        for (final widget in widgetData)
          widget['value']?.toString() ?? '': widget['is_visible'] == true,
      };
      final supportedOptions = keyData
          .where(
            (widget) => _supportedDashboardWidgets.contains(
              widget['value']?.toString(),
            ),
          )
          .toList();

      if (!mounted) return;

      setState(() {
        _dashboardWidgetOptions = supportedOptions;

        for (final option in supportedOptions) {
          final value = option['value']?.toString();

          if (value != null) {
            _dashboardWidgets[value] = visibilityByValue[value] ?? false;
          }
        }
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDashboardWidgetsLoading = false;
        });
      }
    }
  }

  Future<void> _updateDashboardWidget(
    String widgetValue,
    bool isVisible,
  ) async {
    final baseUrl = dotenv.env['API_URL'] ?? '';
    final headers = await _getAuthHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/dashboard/widgets'),
      headers: headers,
      body: jsonEncode({
        'widgets': [
          {
            'value': widgetValue,
            'is_visible': isVisible,
          },
        ],
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      dynamic responseData;

      try {
        responseData = jsonDecode(response.body);
      } catch (_) {
        responseData = null;
      }

      throw Exception(
        responseData is Map
            ? responseData['message'] ?? 'Gagal mengubah widget dashboard'
            : 'Gagal mengubah widget dashboard',
      );
    }
  }

  void _showDashboardWidgetSettings() {
    if (_dashboardWidgetOptions.isEmpty) {
      _fetchDashboardWidgets();
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Widget Dashboard',
                        style: TextStyle(
                          fontSize: CustomTheme().fontSize('lg'),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._dashboardWidgetOptions.map((option) {
                      final value = option['value']?.toString() ?? '';

                      return SwitchListTile(
                        title: Text(option['label']?.toString() ?? ''),
                        value: _dashboardWidgets[value] ?? false,
                        onChanged: _isDashboardWidgetsUpdating
                            ? null
                            : (isVisible) async {
                                final previousValue =
                                    _dashboardWidgets[value] ?? false;

                                setState(() {
                                  _dashboardWidgets[value] = isVisible;
                                  _isDashboardWidgetsUpdating = true;
                                });
                                if (modalContext.mounted) {
                                  setModalState(() {});
                                }

                                try {
                                  await _updateDashboardWidget(
                                    value,
                                    isVisible,
                                  );
                                } catch (e) {
                                  if (!mounted) return;

                                  setState(() {
                                    _dashboardWidgets[value] = previousValue;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isDashboardWidgetsUpdating = false;
                                    });
                                    if (modalContext.mounted) {
                                      setModalState(() {});
                                    }
                                  }
                                }
                              },
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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

          return Scaffold(
            appBar: CustomAppBar(
              title: 'TexTrack',
              isWithNotification: true,
              handleLogout: () => _handleLogout(context),
              isWithAccount: true,
              user: user,
              name: name,
              showNameWithAvatar: true,
              onDashboardSettings: _showDashboardWidgetSettings,
              isDashboardSettingsLoading: _isDashboardWidgetsLoading,
            ),
            drawer: AppDrawer(
              handleLogout: () => _handleLogout(context),
              handleFetchMenu: () => _handleFetchMenu(),
            ),
            body: SafeArea(
              child: Dashboard(
                showProcessSummary:
                    _dashboardWidgets['process_summary'] ?? false,
                showMachineStatus: _dashboardWidgets['machine_status'] ?? false,
                showWorkOrderList: _dashboardWidgets['wo_list'] ?? false,
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
