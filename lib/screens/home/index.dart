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
<<<<<<< HEAD
import 'package:textile_tracking/helpers/layout/app_layout.dart';
import 'package:textile_tracking/screens/dashboard/index.dart';
import 'package:textile_tracking/services/fcm_service.dart';
<<<<<<< HEAD
=======
import 'package:textile_tracking/screens/dashboard/index.dart';
>>>>>>> 1155687b (fix: widget dashboard)
=======
>>>>>>> 38fd9bd2 (fix: logout)

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
<<<<<<< HEAD
<<<<<<< HEAD
=======
  static const Set<String> _supportedDashboardWidgets = {
    'process_summary',
    'machine_status',
    'wo_list',
  };

>>>>>>> 5e1b7ecb (fix: dashboard)
=======
>>>>>>> 1155687b (fix: widget dashboard)
  String user = '';
  String name = '';
<<<<<<< HEAD
<<<<<<< HEAD
  int _reworkNotificationCount = 0;
<<<<<<< HEAD
<<<<<<< HEAD
  int _bsNotificationCount = 0;
  int _gsmNotificationCount = 0;
  bool _canViewReworkEvaluation = false;
  bool _canViewBsEvaluation = false;
  bool _canViewGsmEvaluation = false;
=======
  int _reworkNotificationCount = 0;
>>>>>>> 9dacc402 (fix: responsive UI to mobile)
=======
  bool _canViewReworkEvaluation = false;
>>>>>>> e30538ab (fix: notification dan evaluasi rework)
=======
  int _bsNotificationCount = 0;
  int _gsmNotificationCount = 0;
  bool _canViewReworkEvaluation = false;
  bool _canViewBsEvaluation = false;
<<<<<<< HEAD
>>>>>>> 58857212 (feat: notifikasi evaluasi bs)
=======
  bool _canViewGsmEvaluation = false;
>>>>>>> e2884b8b (fix: notification all evaluasi)
  late Future<String?> _tokenFuture;
=======
  late Future<String?> _tokenFuture;
<<<<<<< HEAD
  final Map<String, bool> _dashboardWidgets = {
    'process_summary': false,
    'machine_status': false,
    'wo_list': false,
  };
<<<<<<< HEAD
>>>>>>> 5e1caa7c (feat: widget controller)
=======
  List<Map<String, dynamic>> _dashboardWidgetOptions = [];
  bool _isDashboardWidgetsLoading = true;
  bool _isDashboardWidgetsUpdating = false;
>>>>>>> 5e1b7ecb (fix: dashboard)
=======
>>>>>>> 1155687b (fix: widget dashboard)

  @override
  void initState() {
    final loggedInUser = Provider.of<UserProvider>(context, listen: false).user;
    super.initState();
<<<<<<< HEAD
<<<<<<< HEAD
    _tokenFuture = SharedPreferences.getInstance().then(
      (prefs) => prefs.getString('access_token'),
    );
=======
    _tokenFuture = SharedPreferences.getInstance()
        .then((prefs) => prefs.getString('access_token'));
>>>>>>> 5e1caa7c (feat: widget controller)
=======
    _tokenFuture = SharedPreferences.getInstance().then(
      (prefs) => prefs.getString('access_token'),
    );
>>>>>>> 99705a2c (fix: home, dashboard)

    setState(() {
      user = loggedInUser?.username ?? '';
      name = loggedInUser?.name ?? '';
    });
<<<<<<< HEAD
<<<<<<< HEAD

    WidgetsBinding.instance.addPostFrameCallback((_) {
<<<<<<< HEAD
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
    final canViewBsEvaluation = _hasMobileMenu(userMenu.menus, 'Evaluasi BS');
    final canViewGsmEvaluation = _hasMobileMenu(userMenu.menus, 'Evaluasi GSM');

    if (!mounted) return;

    setState(() {
      _canViewReworkEvaluation = canViewReworkEvaluation;
      _canViewBsEvaluation = canViewBsEvaluation;
      _canViewGsmEvaluation = canViewGsmEvaluation;
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

=======

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMenuAccess();
    });
  }

<<<<<<< HEAD
>>>>>>> 9dacc402 (fix: responsive UI to mobile)
=======
  Future<void> _initializeMenuAccess() async {
    final userMenu = UserMenu();
    await userMenu.handleLoadMenu();

    final canViewReworkEvaluation = _hasMobileMenu(
      userMenu.menus,
      'Evaluasi Rework',
    );
    final canViewBsEvaluation = _hasMobileMenu(userMenu.menus, 'Evaluasi BS');
    final canViewGsmEvaluation = _hasMobileMenu(userMenu.menus, 'Evaluasi GSM');

    if (!mounted) return;

    setState(() {
      _canViewReworkEvaluation = canViewReworkEvaluation;
      _canViewBsEvaluation = canViewBsEvaluation;
      _canViewGsmEvaluation = canViewGsmEvaluation;
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

>>>>>>> e30538ab (fix: notification dan evaluasi rework)
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
<<<<<<< HEAD
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

  Future<void> _fetchGsmNotificationCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final baseUrl = dotenv.env['API_URL'] ?? '';
      final response = await http.get(
        Uri.parse('$baseUrl/gsm-evaluations/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200 || !mounted) return;

      final responseData = jsonDecode(response.body);
      final count = responseData['data']?['count'];
      setState(() {
        _gsmNotificationCount = int.tryParse(count?.toString() ?? '') ?? 0;
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
    if (_canViewGsmEvaluation) {
      futures.add(_fetchGsmNotificationCount());
    }
    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  int get _authorizedEvaluationCount {
    var count = 0;
    if (_canViewReworkEvaluation) count++;
    if (_canViewBsEvaluation) count++;
    if (_canViewGsmEvaluation) count++;
    return count;
  }

  bool get _hasEvaluationAccess => _authorizedEvaluationCount > 0;

  bool get _hasMultipleEvaluationAccess => _authorizedEvaluationCount > 1;

  int get _evaluationNotificationCount {
    var total = 0;
    if (_canViewReworkEvaluation) total += _reworkNotificationCount;
    if (_canViewBsEvaluation) total += _bsNotificationCount;
    if (_canViewGsmEvaluation) total += _gsmNotificationCount;
    return total;
  }

  String get _singleEvaluationTooltip {
    if (_hasMultipleEvaluationAccess) return 'Evaluasi';
    if (_canViewReworkEvaluation) return 'Evaluasi Rework';
    if (_canViewBsEvaluation) return 'Evaluasi BS';
    if (_canViewGsmEvaluation) return 'Evaluasi GSM';
    return 'Evaluasi';
  }

  void _openSingleEvaluation() {
    if (_canViewReworkEvaluation) {
      Navigator.pushNamed(context, '/dyeing-rework-evaluations');
      return;
    }
    if (_canViewBsEvaluation) {
      Navigator.pushNamed(context, '/bs-evaluations');
      return;
    }
    if (_canViewGsmEvaluation) {
      Navigator.pushNamed(context, '/gsm-evaluations');
    }
  }

  Future<void> _onEvaluationNotificationsTap() async {
    if (_hasMultipleEvaluationAccess) {
      await _showEvaluationChooser();
      return;
    }
    _openSingleEvaluation();
  }

  Future<void> _showEvaluationChooser() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  'Pilih Evaluasi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              if (_canViewReworkEvaluation)
                ListTile(
                  leading: const Icon(Icons.restart_alt_outlined),
                  title: const Text('Evaluasi Rework'),
                  trailing: _buildWaitingCountBadge(_reworkNotificationCount),
                  onTap: () =>
                      Navigator.pop(sheetContext, '/dyeing-rework-evaluations'),
                ),
              if (_canViewBsEvaluation)
                ListTile(
                  leading: const Icon(Icons.report_gmailerrorred_outlined),
                  title: const Text('Evaluasi BS'),
                  trailing: _buildWaitingCountBadge(_bsNotificationCount),
                  onTap: () => Navigator.pop(sheetContext, '/bs-evaluations'),
                ),
              if (_canViewGsmEvaluation)
                ListTile(
                  leading: const Icon(Icons.straighten_outlined),
                  title: const Text('Evaluasi GSM'),
                  trailing: _buildWaitingCountBadge(_gsmNotificationCount),
                  onTap: () => Navigator.pop(sheetContext, '/gsm-evaluations'),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (!mounted || selected == null) return;
    Navigator.pushNamed(context, selected);
  }

  Widget? _buildWaitingCountBadge(int count) {
    if (count <= 0) return null;

    return UnconstrainedBox(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          count > 99 ? '99+' : count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
=======
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
>>>>>>> 5e1b7ecb (fix: dashboard)
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
=======
>>>>>>> 1155687b (fix: widget dashboard)
=======
>>>>>>> 9dacc402 (fix: responsive UI to mobile)
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

  Future<void> _fetchGsmNotificationCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final baseUrl = dotenv.env['API_URL'] ?? '';
      final response = await http.get(
        Uri.parse('$baseUrl/gsm-evaluations/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200 || !mounted) return;

      final responseData = jsonDecode(response.body);
      final count = responseData['data']?['count'];
      setState(() {
        _gsmNotificationCount = int.tryParse(count?.toString() ?? '') ?? 0;
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
    if (_canViewGsmEvaluation) {
      futures.add(_fetchGsmNotificationCount());
    }
    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  int get _authorizedEvaluationCount {
    var count = 0;
    if (_canViewReworkEvaluation) count++;
    if (_canViewBsEvaluation) count++;
    if (_canViewGsmEvaluation) count++;
    return count;
  }

  bool get _hasEvaluationAccess => _authorizedEvaluationCount > 0;

  bool get _hasMultipleEvaluationAccess => _authorizedEvaluationCount > 1;

  int get _evaluationNotificationCount {
    var total = 0;
    if (_canViewReworkEvaluation) total += _reworkNotificationCount;
    if (_canViewBsEvaluation) total += _bsNotificationCount;
    if (_canViewGsmEvaluation) total += _gsmNotificationCount;
    return total;
  }

  String get _singleEvaluationTooltip {
    if (_hasMultipleEvaluationAccess) return 'Evaluasi';
    if (_canViewReworkEvaluation) return 'Evaluasi Rework';
    if (_canViewBsEvaluation) return 'Evaluasi BS';
    if (_canViewGsmEvaluation) return 'Evaluasi GSM';
    return 'Evaluasi';
  }

  void _openSingleEvaluation() {
    if (_canViewReworkEvaluation) {
      Navigator.pushNamed(context, '/dyeing-rework-evaluations');
      return;
    }
    if (_canViewBsEvaluation) {
      Navigator.pushNamed(context, '/bs-evaluations');
      return;
    }
    if (_canViewGsmEvaluation) {
      Navigator.pushNamed(context, '/gsm-evaluations');
    }
  }

  Future<void> _onEvaluationNotificationsTap() async {
    if (_hasMultipleEvaluationAccess) {
      await _showEvaluationChooser();
      return;
    }
    _openSingleEvaluation();
  }

  Future<void> _showEvaluationChooser() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  'Pilih Evaluasi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              if (_canViewReworkEvaluation)
                ListTile(
                  leading: const Icon(Icons.restart_alt_outlined),
                  title: const Text('Evaluasi Rework'),
                  trailing: _buildWaitingCountBadge(_reworkNotificationCount),
                  onTap: () =>
                      Navigator.pop(sheetContext, '/dyeing-rework-evaluations'),
                ),
              if (_canViewBsEvaluation)
                ListTile(
                  leading: const Icon(Icons.report_gmailerrorred_outlined),
                  title: const Text('Evaluasi BS'),
                  trailing: _buildWaitingCountBadge(_bsNotificationCount),
                  onTap: () => Navigator.pop(sheetContext, '/bs-evaluations'),
                ),
              if (_canViewGsmEvaluation)
                ListTile(
                  leading: const Icon(Icons.straighten_outlined),
                  title: const Text('Evaluasi GSM'),
                  trailing: _buildWaitingCountBadge(_gsmNotificationCount),
                  onTap: () => Navigator.pop(sheetContext, '/gsm-evaluations'),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (!mounted || selected == null) return;
    Navigator.pushNamed(context, selected);
  }

  Widget? _buildWaitingCountBadge(int count) {
    if (count <= 0) return null;

    return UnconstrainedBox(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          count > 99 ? '99+' : count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Future<void> _handleExit(
    BuildContext context,
    ValueNotifier<bool> isLoading,
  ) async {
    String url = '${dotenv.env['API_URL']}/logout';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token != null) {
      try {
        isLoading.value = true;
        final deviceData = await FcmService.instance.getCurrentDeviceData();

<<<<<<< HEAD
<<<<<<< HEAD
        final res = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(deviceData),
        );
=======
        final res = await http.post(Uri.parse(url),
            headers: {'Authorization': 'Bearer $token'}, body: null);
>>>>>>> 264bcd0f (fix: evaluasi rework)
=======
        final res = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(deviceData),
        );
>>>>>>> 99705a2c (fix: home, dashboard)

        if (res.statusCode == 200) {
          await FcmService.instance.clearCurrentDeviceData();
          if (context.mounted) {
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 99705a2c (fix: home, dashboard)
            await Provider.of<UserProvider>(
              context,
              listen: false,
            ).handleLogout();
<<<<<<< HEAD
=======
            await Provider.of<UserProvider>(context, listen: false)
                .handleLogout();
>>>>>>> 264bcd0f (fix: evaluasi rework)
=======
>>>>>>> 99705a2c (fix: home, dashboard)

            await Future.delayed(Duration(milliseconds: 200));
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          } else {
            if (context.mounted) {
              showAlertDialog(
                context: context,
                title: 'Error',
                message: 'Logout failed',
              );
            }
          }
        }
      } catch (e) {
        if (context.mounted) {
          showAlertDialog(
            context: context,
            title: 'Error',
            message: 'Logout failed',
          );
        }
      } finally {
        isLoading.value = false;
      }
    } else {
      showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Logout failed',
      );
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
        buttonBackground: CustomTheme().buttonColor('danger'),
      );
    }
  }

  Future<List<MenuItem>> _handleFetchMenu() async {
    UserMenu userMenu = UserMenu();
    await userMenu.handleLoadMenu();

    try {
      List<dynamic> menuData = userMenu.menus;

      final filteredData = menuData
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 99705a2c (fix: home, dashboard)
          .where(
            (menu) =>
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
                menu['name'] != 'Persiapan Dyeing',
          )
<<<<<<< HEAD
=======
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
>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> 99705a2c (fix: home, dashboard)
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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 99705a2c (fix: home, dashboard)
      future: _tokenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text('Error fetch token'));
        }
<<<<<<< HEAD
=======
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
>>>>>>> 5e1caa7c (feat: widget controller)

<<<<<<< HEAD
<<<<<<< HEAD
        final isMobile = AppLayout.resolveIsMobile(context);

        return AppLayout(
          isMobile: isMobile,
          child: PopScope(
=======
          return PopScope(
>>>>>>> e30538ab (fix: notification dan evaluasi rework)
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                SystemNavigator.pop();
              }
            },
            child: Scaffold(
              appBar: CustomAppBar(
                title: 'TexTrack',
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> e2884b8b (fix: notification all evaluasi)
                isWithNotification: _hasEvaluationAccess,
                notificationCount: _evaluationNotificationCount,
                notificationTooltip: _singleEvaluationTooltip,
                onNotifications: _onEvaluationNotificationsTap,
<<<<<<< HEAD
=======
                isWithNotification: _canViewReworkEvaluation,
                reworkNotificationCount: _reworkNotificationCount,
                onReworkNotifications: () {
                  Navigator.pushNamed(context, '/dyeing-rework-evaluations');
                },
<<<<<<< HEAD
>>>>>>> e30538ab (fix: notification dan evaluasi rework)
=======
                isWithBsNotification: _canViewBsEvaluation,
                bsNotificationCount: _bsNotificationCount,
                onBsNotifications: () {
                  Navigator.pushNamed(context, '/bs-evaluations');
                },
>>>>>>> 58857212 (feat: notifikasi evaluasi bs)
=======
>>>>>>> e2884b8b (fix: notification all evaluasi)
                handleLogout: () => _handleLogout(context),
                isWithAccount: true,
                user: user,
                name: name,
<<<<<<< HEAD
                showAvatar: !isMobile,
                showNameWithAvatar: !isMobile,
=======
                showAvatar: MediaQuery.sizeOf(context).shortestSide >= 600,
                showNameWithAvatar:
                    MediaQuery.sizeOf(context).shortestSide >= 600,
>>>>>>> e30538ab (fix: notification dan evaluasi rework)
              ),
              drawer: AppDrawer(
                handleLogout: () => _handleLogout(context),
                handleFetchMenu: () => _handleFetchMenu(),
              ),
              body: SafeArea(
                child: Dashboard(
<<<<<<< HEAD
<<<<<<< HEAD
                  isMobile: isMobile,
                  onRefreshReworkNotifications: _refreshEvaluationNotifications,
                ),
=======

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
              isWithNotification: _hasEvaluationAccess,
              notificationCount: _evaluationNotificationCount,
              notificationTooltip: _singleEvaluationTooltip,
              onNotifications: _onEvaluationNotificationsTap,
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
>>>>>>> 99705a2c (fix: home, dashboard)
              ),
=======
          return Scaffold(
            appBar: CustomAppBar(
              title: 'TexTrack',
              isWithNotification: true,
              reworkNotificationCount: _reworkNotificationCount,
              onReworkNotifications: () {
                Navigator.pushNamed(context, '/dyeing-rework-evaluations');
              },
              handleLogout: () => _handleLogout(context),
              isWithAccount: true,
              user: user,
              name: name,
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> d8439a4 (fix: refactor code)
=======
              showNameWithAvatar: true,
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> 632c9e3 (fix: show logged in name di appbar)
=======
              showNameWithAvatar: true,
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
            ),
          ),
        );
      },
    );
=======
              onDashboardSettings: _showDashboardWidgetSettings,
              isDashboardSettingsLoading: _isDashboardWidgetsLoading,
=======
>>>>>>> 1155687b (fix: widget dashboard)
=======
              showAvatar: MediaQuery.sizeOf(context).shortestSide >= 600,
              showNameWithAvatar:
                  MediaQuery.sizeOf(context).shortestSide >= 600,
>>>>>>> 9dacc402 (fix: responsive UI to mobile)
            ),
            drawer: AppDrawer(
              handleLogout: () => _handleLogout(context),
              handleFetchMenu: () => _handleFetchMenu(),
            ),
            body: SafeArea(
              child: Dashboard(
                onRefreshReworkNotifications: _fetchReworkNotificationCount,
=======
                  onRefreshReworkNotifications: _fetchReworkNotificationCount,
=======
                  onRefreshReworkNotifications: _refreshEvaluationNotifications,
>>>>>>> 58857212 (feat: notifikasi evaluasi bs)
                ),
>>>>>>> e30538ab (fix: notification dan evaluasi rework)
              ),
            ),
<<<<<<< HEAD
          );
        });
>>>>>>> 5e1caa7c (feat: widget controller)
=======
          ),
        );
      },
    );
>>>>>>> 99705a2c (fix: home, dashboard)
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

  SubMenuItem({required this.title, this.route, required this.allowMobile});

  factory SubMenuItem.fromJson(Map<String, dynamic> json) {
    return SubMenuItem(
      title: json['name'] ?? '',
      route: json['url'],
      allowMobile: json['allow_mobile'] ?? false,
    );
  }
}
