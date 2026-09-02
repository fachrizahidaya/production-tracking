// ignore_for_file: use_build_context_synchronously, prefer_final_fields, control_flow_in_finally

import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/components/home/dashboard/filter/process_filter.dart';
import 'package:textile_tracking/components/home/dashboard/filter/summary_filter.dart';
import 'package:textile_tracking/components/home/dashboard/machine/active_machine.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/process/work_order_process.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/work_order_stats.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/summary/work_order_summary.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/dashboard/machine.dart';
import 'package:textile_tracking/models/dashboard/work_order_chart.dart';
import 'package:textile_tracking/models/dashboard/work_order_process.dart';
import 'package:textile_tracking/models/dashboard/work_order_stats.dart';
import 'package:textile_tracking/models/dashboard/work_order_summary.dart';
import 'package:textile_tracking/screens/auth/user_menu.dart';

class Dashboard extends StatefulWidget {
  final Future<void> Function()? onRefreshReworkNotifications;

  const Dashboard({
    super.key,
    this.onRefreshReworkNotifications,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static const Set<String> _supportedDashboardWidgets = {
    'process_summary',
    'machine_status',
    'wo_list',
  };

  final Map<String, bool> _dashboardWidgets = {
    'process_summary': false,
    'machine_status': false,
    'wo_list': false,
  };
  List<Map<String, dynamic>> _dashboardWidgetOptions = [];
  bool _isDashboardWidgetsLoading = true;
  bool _isDashboardWidgetsUpdating = false;

  List<dynamic> statsList = [];
  List<dynamic> chartList = [];
  List<dynamic> pieList = [];
  List<dynamic> summaryList = [];
  List<dynamic> greigeSummaryList = [];
  Map<String, dynamic> machineList = {};
  final List<dynamic> _dataList = [];
  List<dynamic> menus = [];
  Set<String> menuProcessNames = {};

  String dariTanggalSummary = '';
  String sampaiTanggalSummary = '';
  String _search = '';

  bool isLoading = false;
  bool _isLoadMore = false;
  bool _isFiltered = false;
  Timer? _debounce;
  Map<String, String> summaryParams = {'start_date': '', 'end_date': ''};
  Map<String, String> chartParams = {'start_date': '', 'end_date': ''};
  Map<String, String> params = {'search': '', 'page': '0'};
  bool _hasMore = true;
  bool _firstLoading = true;
  bool isStatsLoading = false;
  bool isChartLoading = false;
  bool isMachineLoading = false;
  bool isSummaryLoading = false;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    dariTanggalSummary = DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
    sampaiTanggalSummary = DateFormat('yyyy-MM-dd').format(now);

    params = {
      'search': _search,
      'page': '0',
    };

    summaryParams = {
      'start_date': dariTanggalSummary,
      'end_date': sampaiTanggalSummary,
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDashboardWidgets();
      if (mounted) {
        _loadDashboardData();
      }
    });
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) throw Exception('Unauthenticated');

    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  Future<void> _fetchDashboardWidgets() async {
    if (mounted) setState(() => _isDashboardWidgetsLoading = true);

    try {
      final baseUrl = dotenv.env['API_URL'] ?? '';
      final headers = await _getAuthHeaders();
      final keysResponse = await http.get(
        Uri.parse('$baseUrl/dashboard/widget-keys'),
        headers: headers,
      );
      final widgetsResponse = await http.get(
        Uri.parse('$baseUrl/dashboard/widgets'),
        headers: headers,
      );

      if (keysResponse.statusCode != 200 || widgetsResponse.statusCode != 200) {
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
          .where((widget) => _supportedDashboardWidgets.contains(
                widget['value']?.toString(),
              ))
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isDashboardWidgetsLoading = false);
    }
  }

  Future<void> _updateDashboardWidget(
      String widgetValue, bool isVisible) async {
    final baseUrl = dotenv.env['API_URL'] ?? '';
    final response = await http.patch(
      Uri.parse('$baseUrl/dashboard/widgets'),
      headers: await _getAuthHeaders(),
      body: jsonEncode({
        'widgets': [
          {'value': widgetValue, 'is_visible': isVisible},
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
      throw Exception(responseData is Map
          ? responseData['message'] ?? 'Gagal mengubah widget dashboard'
          : 'Gagal mengubah widget dashboard');
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
      builder: (modalContext) => StatefulBuilder(
        builder: (modalContext, setModalState) => SafeArea(
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
                            setModalState(() {});
                            try {
                              await _updateDashboardWidget(value, isVisible);
                            } catch (e) {
                              if (!mounted) return;
                              setState(() =>
                                  _dashboardWidgets[value] = previousValue);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            } finally {
                              if (mounted) {
                                setState(
                                    () => _isDashboardWidgetsUpdating = false);
                                if (modalContext.mounted) setModalState(() {});
                              }
                            }
                          },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get shouldHideActiveMachine {
    bool checkMenus(List<dynamic> menuList) {
      for (final menu in menuList) {
        final children = menu['children'];

        if (children != null && children is List && checkMenus(children)) {
          return true;
        }
      }

      return false;
    }

    return checkMenus(menus);
  }

  Future<void> _handleFetchMenu() async {
    try {
      final result = await MenuService().handleFetchMenu(context);

      if (!mounted) return;

      setState(() {
        menus = result;
        menuProcessNames = _getMenuProcessNames(result);
      });
    } catch (e) {
      throw ('Error fetch menu: $e');
    }
  }

  Set<String> _getMenuProcessNames(List<dynamic> menuList) {
    final processNames = <String>{};

    for (final menu in menuList) {
      if (menu is! Map) continue;

      final name = (menu['name'] ?? '').toString().trim();
      if (name.isNotEmpty) {
        processNames.add(name);
      }

      final children = menu['children'];
      if (children is List) {
        processNames.addAll(_getMenuProcessNames(children));
      }
    }

    return processNames;
  }

  bool _checkIsFiltered() {
    return params.keys.any(
        (key) => key != 'page' && key != 'search' && params[key]!.isNotEmpty);
  }

  Future<void> _loadDashboardData() async {
    if (!mounted) return;

    setState(() => isLoading = true);

    await _safeFetch(_handleFetchMenu);

    await Future.wait([
      _safeFetch(_handleFetchStats),
      _safeFetch(_handleFetchPie),
      _safeFetch(_handleFetchMachine),
      _safeFetch(_handleFetchSummary),
      _safeFetch(_loadMore),
    ]);

    if (!mounted) return;

    setState(() => isLoading = false);
  }

  Future<void> _safeFetch(Future<void> Function() callback) async {
    try {
      await callback();
    } catch (e) {
      if (mounted) {
        debugPrint('Dashboard request failed: $e');
      }
    }
  }

  Future<void> _handleFetchStats() async {
    final service = context.read<WorkOrderStatsService>();

    await service.getDataList();

    if (!mounted) return;

    setState(() {
      statsList = service.dataList;
    });
  }

  Future<void> _handleFetchMachine() async {
    if (!mounted) return;

    setState(() {
      isMachineLoading = true;
      machineList = {};
    });

    try {
      final service = context.read<MachineService>();

      await service.getDataList();

      if (!mounted) return;

      setState(() {
        machineList = service.dataList;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        machineList = {};
      });
    } finally {
      if (!mounted) return;

      setState(() {
        isMachineLoading = false;
      });
    }
  }

  Future<void> _handleFetchPie() async {
    final service = context.read<WorkOrderChartService>();

    await service.getDataPie();

    if (!mounted) return;

    setState(() {
      pieList = service.dataPie;
    });
  }

  Future<void> _handleFetchSummary() async {
    if (!mounted) return;

    setState(() {
      isSummaryLoading = true;
      summaryList = [];
      greigeSummaryList = [];
    });

    try {
      final service =
          Provider.of<WorkOrderSummaryService>(context, listen: false);

      await Future.wait([
        service.getDataList(context, summaryParams),
        service.getPreDataList(context, summaryParams),
      ]);
      service.filterByProcessNames(menuProcessNames);

      if (!mounted) return;

      setState(() {
        summaryList = service.dataList;
        greigeSummaryList = service.preDataList;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        summaryList = [];
        greigeSummaryList = [];
      });
    } finally {
      if (!mounted) return;

      setState(() {
        isSummaryLoading = false;
      });
    }
  }

  void _handleSummaryFilter(String key, String value) {
    setState(() {
      if (value.isEmpty) {
        summaryParams.remove(key);
      } else {
        summaryParams[key] = value;
      }
    });

    _handleFetchSummary();
  }

  void _handleProcessFilter(String key, dynamic value) {
    setState(() {
      params['page'] = '0';
      if (value.toString() != '') {
        params[key.toString()] = value.toString();
      } else {
        params.remove(key.toString());
      }
    });

    _isFiltered = _checkIsFiltered();

    _loadMore();
  }

  Future<void> _handleSearch(String value) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _search = value;
        params['search'] = value;
        params['page'] = '0';
      });
      _loadMore();
    });
  }

  Future<void> _loadMore() async {
    if (!mounted) return;

    setState(() {
      _isLoadMore = true;
    });

    if (params['page'] == '0') {
      setState(() {
        _dataList.clear();
        _firstLoading = true;
        _hasMore = true;
      });
    }

    final currentPage = int.tryParse(params['page'] ?? '0') ?? 0;
    params['page'] = (currentPage + 1).toString();

    try {
      final service =
          Provider.of<WorkOrderProcessService>(context, listen: false);

      await service.getDataList(context, params);

      if (!mounted) return;

      final loadData = service.items;

      setState(() {
        if (params['page'] == '1') {
          _dataList.clear();
        }

        _dataList.addAll(loadData);
        _hasMore = loadData.isNotEmpty;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _dataList.clear();
        _hasMore = false;
      });
    } finally {
      if (!mounted) return;

      setState(() {
        _firstLoading = false;
        _isLoadMore = false;
      });
    }
  }

  _refetch() {
    if (!mounted) return;
    setState(() {
      params = {
        'search': _search,
        'page': '0',
      };
    });
    _loadMore();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFf9fafc),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await _loadDashboardData();
              await widget.onRefreshReworkNotifications?.call();
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: CustomTheme().padding('content'),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate([
                    _buildDashboardSettingsButton(),
                    WorkOrderStats(data: statsList, isFetching: isStatsLoading),
                    if (_dashboardWidgets['process_summary'] ?? false)
                      WorkOrderSummary(
                        data: summaryList,
                        greigeData: greigeSummaryList,
                        handleRefetch: _handleFetchSummary,
                        isFetching: isSummaryLoading,
                        filterWidget: SummaryFilter(
                          dariTanggal: dariTanggalSummary,
                          sampaiTanggal: sampaiTanggalSummary,
                          onHandleFilter: _handleSummaryFilter,
                          params: summaryParams,
                        ),
                      ),
                    if ((_dashboardWidgets['machine_status'] ?? false) &&
                        !shouldHideActiveMachine)
                      ActiveMachine(
                        data: machineList,
                        available: machineList['available'],
                        unavailable: machineList['unavailable'],
                        handleRefetch: _handleFetchMachine,
                        isFetching: isMachineLoading,
                        processNames: menuProcessNames,
                      ),
                    if (_dashboardWidgets['wo_list'] ?? false)
                      WorkOrderProcessScreen(
                        data: _dataList,
                        search: _search,
                        handleSearch: _handleSearch,
                        firstLoading: _firstLoading,
                        hasMore: _hasMore,
                        handleLoadMore: _loadMore,
                        handleRefetch: _refetch,
                        isLoadMore: _isLoadMore,
                        filterWidget: ProcessFilter(
                          params: params,
                          onHandleFilter: _handleProcessFilter,
                        ),
                        handleFetchData: (params) async {
                          final service = Provider.of<WorkOrderProcessService>(
                              context,
                              listen: false);
                          await service.getDataList(context, params);
                          return service.items;
                        },
                        service: WorkOrderProcessService(),
                        isFiltered: _isFiltered,
                      ),
                  ].separatedBy(CustomTheme().vGap('2xl')))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardSettingsButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: _isDashboardWidgetsLoading ? null : _showDashboardWidgetSettings,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: CustomTheme().cardTheme(),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Widget Dashboard',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _isDashboardWidgetsLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.dashboard_customize_outlined),
          ],
        ),
      ),
    );
  }
}
