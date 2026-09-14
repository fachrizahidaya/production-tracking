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
<<<<<<< HEAD
  final bool isMobile;
  final Future<void> Function()? onRefreshReworkNotifications;

  const Dashboard({
    super.key,
    required this.isMobile,
    this.onRefreshReworkNotifications,
=======
  final bool showWorkOrderSummary;
  final bool showActiveMachine;
  final bool showWorkOrderProcess;

  const Dashboard({
    super.key,
    this.showWorkOrderSummary = true,
    this.showActiveMachine = true,
    this.showWorkOrderProcess = true,
>>>>>>> 5e1caa7c (feat: widget controller)
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

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  bool get _isMobile => widget.isMobile;

  void _applyMobileProcessParams() {
    final now = DateTime.now();
    final processStartDate = DateTime(now.year, now.month - 2, now.day);
    params = {
      'search': _search,
      'page': '0',
      'per_page': '10',
      'start_date': params['start_date'] ??
          DateFormat('yyyy-MM-dd').format(processStartDate),
      'end_date': params['end_date'] ?? DateFormat('yyyy-MM-dd').format(now),
      if (params['status'] != null && params['status']!.isNotEmpty)
        'status': params['status']!,
    };
  }

  void _applyTabletProcessParams() {
    params = {
      'search': _search,
      'page': '0',
      if (params['status'] != null && params['status']!.isNotEmpty)
        'status': params['status']!,
    };
  }
=======
  bool get isMobile => MediaQuery.of(context).size.width < 600;

  bool get isTablet => MediaQuery.of(context).size.width >= 600;
>>>>>>> d86a31e7 (fix: UI mobile dashboard)

=======
>>>>>>> 46f4802b (fix: UI dashboard)
=======
=======
>>>>>>> 8d5fb5bc (fix: UI mobile dashboard)
=======
>>>>>>> 62cb1f4a (fix: UI mobile dashboard)
  bool get isMobile => MediaQuery.of(context).size.width < 600;

  bool get isTablet => MediaQuery.of(context).size.width >= 600;

<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> 73378bdd (fix: UI mobile dashboard)
=======
>>>>>>> 0f73a2e7 (fix: UI dashboard)
=======
>>>>>>> 8d5fb5bc (fix: UI mobile dashboard)
=======
>>>>>>> a6b1bf80 (fix: UI dashboard)
=======
>>>>>>> 62cb1f4a (fix: UI mobile dashboard)
=======
>>>>>>> e29a2ffd (fix: UI dashboard)
  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    dariTanggalSummary = DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
    sampaiTanggalSummary = DateFormat('yyyy-MM-dd').format(now);

    params = {'search': _search, 'page': '0'};

    summaryParams = {
      'start_date': dariTanggalSummary,
      'end_date': sampaiTanggalSummary,
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
<<<<<<< HEAD
<<<<<<< HEAD
      if (!mounted) return;

      setState(() {
        if (_isMobile) {
          _applyMobileProcessParams();
        } else {
          _applyTabletProcessParams();
        }
      });

      _fetchDashboardWidgets();
=======
>>>>>>> 632c9e3 (fix: show logged in name di appbar)
=======
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
      if (mounted) {
        _loadDashboardData();
      }
    });
<<<<<<< HEAD
<<<<<<< HEAD
  }

  @override
  void didUpdateWidget(covariant Dashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMobile == widget.isMobile) return;

    setState(() {
      if (_isMobile) {
        _applyMobileProcessParams();
      } else {
        _applyTabletProcessParams();
      }
    });
    _loadMore();
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
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isDashboardWidgetsLoading = false);
    }
  }

  Future<void> _updateDashboardWidget(
    String widgetValue,
    bool isVisible,
  ) async {
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
      builder: (modalContext) => StatefulBuilder(
        builder: (modalContext, setModalState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
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
                              setState(
                                () => _dashboardWidgets[value] = previousValue,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            } finally {
                              if (mounted) {
                                setState(
                                  () => _isDashboardWidgetsUpdating = false,
                                );
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
=======
>>>>>>> 632c9e3 (fix: show logged in name di appbar)
=======
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
  }

  bool get shouldHideActiveMachine {
    bool checkMenus(List<dynamic> menuList) {
      for (final menu in menuList) {
<<<<<<< HEAD
=======
        final name = (menu['name'] ?? '').toString().toLowerCase();

        // if (name == 'sorting' || name == 'packing') {
        //   return true;
        // }

>>>>>>> 6a9e309 (fix: show machine)
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
      (key) {
        if (key == 'page' || key == 'search' || key == 'per_page') {
          return false;
        }
        if (_isMobile && (key == 'start_date' || key == 'end_date')) {
          return false;
        }
        return params[key]!.isNotEmpty;
      },
    );
  }

  Future<void> _loadDashboardData() async {
    if (!mounted) return;

    setState(() => isLoading = true);

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    await _safeFetch(_handleFetchMenu);

    await Future.wait([
      _safeFetch(_handleFetchStats),
      _safeFetch(_handleFetchPie),
      _safeFetch(_handleFetchMachine),
      _safeFetch(_handleFetchSummary),
      _safeFetch(_loadMore),
    ]);

=======
=======
    await _safeFetch(_handleFetchMenu);

>>>>>>> 04b6e1a6 (fix: filter dashboard data by accessible processes)
    await Future.wait([
      _safeFetch(_handleFetchStats),
      _safeFetch(_handleFetchPie),
      _safeFetch(_handleFetchMachine),
      _safeFetch(_handleFetchSummary),
      _safeFetch(_loadMore),
    ]);

>>>>>>> 45ea02f (fix: dashboard)
=======
    await Future.wait([
      _safeFetch(_handleFetchMenu),
      _safeFetch(_handleFetchStats),
      _safeFetch(_handleFetchPie),
      _safeFetch(_handleFetchMachine),
      _safeFetch(_handleFetchSummary),
      _safeFetch(_loadMore),
    ]);

>>>>>>> 6f05bd35 (merge to fase 2  (#27))
    if (!mounted) return;

    setState(() => isLoading = false);
  }

  Future<void> _safeFetch(Future<void> Function() callback) async {
    try {
      await callback();
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    } catch (e) {
      if (mounted) {
        debugPrint('Dashboard request failed: $e');
      }
=======
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
>>>>>>> 45ea02f (fix: dashboard)
=======
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
=======
    } catch (e) {
      throw (e.toString());
>>>>>>> 720fcd7c (fix: dashboard work order summary untuk greige)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    } catch (e) {
=======
=======
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
    } catch (e, s) {
=======
    } catch (e) {
>>>>>>> 720fcd7c (fix: dashboard work order summary untuk greige)
      debugPrint('Machine Error: $e');

<<<<<<< HEAD
>>>>>>> 632c9e3 (fix: show logged in name di appbar)
=======
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 720fcd7c (fix: dashboard work order summary untuk greige)
      greigeSummaryList = [];
    });

    try {
      final service = Provider.of<WorkOrderSummaryService>(
        context,
        listen: false,
      );

      await Future.wait([
        service.getDataList(context, summaryParams),
        service.getPreDataList(context, summaryParams),
      ]);
      service.filterByProcessNames(menuProcessNames);
<<<<<<< HEAD
=======
    });

    try {
=======
    });

    try {
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
      final service =
          Provider.of<WorkOrderSummaryService>(context, listen: false);

<<<<<<< HEAD
      await service.getDataList(context, summaryParams);
<<<<<<< HEAD
>>>>>>> 45ea02f (fix: dashboard)
=======
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
=======
      await Future.wait([
        service.getDataList(context, summaryParams),
        service.getPreDataList(context, summaryParams),
      ]);
>>>>>>> 720fcd7c (fix: dashboard work order summary untuk greige)
=======
>>>>>>> 04b6e1a6 (fix: filter dashboard data by accessible processes)

      if (!mounted) return;

      setState(() {
        summaryList = service.dataList;
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        greigeSummaryList = service.preDataList;
      });
    } catch (e) {
=======
=======
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
=======
        greigeSummaryList = service.preDataList;
>>>>>>> 720fcd7c (fix: dashboard work order summary untuk greige)
      });
    } catch (e) {
      debugPrint('Summary Error: $e');

<<<<<<< HEAD
>>>>>>> 45ea02f (fix: dashboard)
=======
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
      if (!mounted) return;

      setState(() {
        summaryList = [];
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        greigeSummaryList = [];
=======
>>>>>>> 45ea02f (fix: dashboard)
=======
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
=======
        greigeSummaryList = [];
>>>>>>> 720fcd7c (fix: dashboard work order summary untuk greige)
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

      if (key == 'start_date') {
        dariTanggalSummary = value;
      } else if (key == 'end_date') {
        sampaiTanggalSummary = value;
      }
    });

    _handleFetchSummary();
  }

  void _handleSummaryDateRange(String startDate, String endDate) {
    setState(() {
      dariTanggalSummary = startDate;
      sampaiTanggalSummary = endDate;
      summaryParams['start_date'] = startDate;
      summaryParams['end_date'] = endDate;
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

  void _handleProcessDateRange(String startDate, String endDate) {
    if (!_isMobile) return;

    setState(() {
      params['page'] = '0';
      params['per_page'] = '10';
      params['start_date'] = startDate;
      params['end_date'] = endDate;
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
<<<<<<< HEAD
<<<<<<< HEAD
    if (_isLoadMore) return;
=======
=======

    setState(() {
      _isLoadMore = true;
    });
>>>>>>> 6f05bd35 (merge to fase 2  (#27))

    setState(() {
      _isLoadMore = true;
    });
>>>>>>> 45ea02f (fix: dashboard)

    final isReset = params['page'] == '0';
    if (!isReset && !_hasMore) return;

    if (_isMobile) {
      params['per_page'] = '10';
    } else {
      params.remove('per_page');
      params.remove('start_date');
      params.remove('end_date');
    }

    setState(() {
      _isLoadMore = true;
      if (isReset) {
        _dataList.clear();
        _firstLoading = true;
        _hasMore = true;
      }
    });

    final currentPage = int.tryParse(params['page'] ?? '0') ?? 0;
    params['page'] = (currentPage + 1).toString();

    try {
<<<<<<< HEAD
<<<<<<< HEAD
      final service = Provider.of<WorkOrderProcessService>(
        context,
        listen: false,
      );
=======
      final service =
          Provider.of<WorkOrderProcessService>(context, listen: false);
>>>>>>> 45ea02f (fix: dashboard)
=======
      final service =
          Provider.of<WorkOrderProcessService>(context, listen: false);
>>>>>>> 6f05bd35 (merge to fase 2  (#27))

      await service.getDataList(context, params);

      if (!mounted) return;

      final loadData = service.items;

      setState(() {
        if (params['page'] == '1') {
          _dataList.clear();
        }

        _dataList.addAll(loadData);
<<<<<<< HEAD
<<<<<<< HEAD
        _hasMore = _isMobile ? loadData.length >= 10 : loadData.isNotEmpty;
=======
        _hasMore = loadData.isNotEmpty;
>>>>>>> 45ea02f (fix: dashboard)
=======
        _hasMore = loadData.isNotEmpty;
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
<<<<<<< HEAD
<<<<<<< HEAD
        if (isReset) {
          _dataList.clear();
        }
=======
        _dataList.clear();
>>>>>>> 45ea02f (fix: dashboard)
=======
        _dataList.clear();
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
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
      if (_isMobile) {
        params['search'] = _search;
        params['page'] = '0';
        params['per_page'] = '10';
      } else {
        params = {'search': _search, 'page': '0'};
      }
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                  padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _buildDashboardSettingsButton(),
                        WorkOrderStats(
                          data: statsList,
                          isFetching: isStatsLoading,
                          isMobile: _isMobile,
                        ),
                        if (_dashboardWidgets['process_summary'] ?? false)
                          WorkOrderSummary(
                            data: summaryList,
                            greigeData: greigeSummaryList,
                            handleRefetch: _handleFetchSummary,
                            isFetching: isSummaryLoading,
                            isMobile: _isMobile,
                            dariTanggal: summaryParams['start_date'] ??
                                dariTanggalSummary,
                            sampaiTanggal: summaryParams['end_date'] ??
                                sampaiTanggalSummary,
                            onDateRangeSelected:
                                _isMobile ? _handleSummaryDateRange : null,
                            filterWidget: SummaryFilter(
                              dariTanggal: dariTanggalSummary,
                              sampaiTanggal: sampaiTanggalSummary,
                              onHandleFilter: _handleSummaryFilter,
                              params: summaryParams,
                            ),
                          ),
                        if ((_dashboardWidgets['machine_status'] ?? false) &&
                            !shouldHideActiveMachine)
=======
=======
>>>>>>> 73378bdd (fix: UI mobile dashboard)
=======
>>>>>>> 8d5fb5bc (fix: UI mobile dashboard)
=======
>>>>>>> 62cb1f4a (fix: UI mobile dashboard)
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 24,
                    vertical: isMobile ? 12 : 20,
                  ),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        WorkOrderStats(
                          data: statsList,
                          isFetching: isStatsLoading,
                        ),
                        SizedBox(height: sectionGap),
                        WorkOrderSummary(
                          data: summaryList,
                          handleRefetch: _handleFetchSummary,
                          isFetching: isSummaryLoading,
                          filterWidget: SummaryFilter(
                            dariTanggal: dariTanggalSummary,
                            sampaiTanggal: sampaiTanggalSummary,
                            onHandleFilter: _handleSummaryFilter,
                            params: summaryParams,
                          ),
                        ),
                        if (!shouldHideActiveMachine) ...[
                          SizedBox(height: sectionGap),
>>>>>>> d86a31e7 (fix: UI mobile dashboard)
                          ActiveMachine(
                            data: machineList,
                            available: machineList['available'],
                            unavailable: machineList['unavailable'],
                            handleRefetch: _handleFetchMachine,
                            isFetching: isMachineLoading,
<<<<<<< HEAD
                            processNames: menuProcessNames,
                            isMobile: _isMobile,
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
                            isMobile: _isMobile,
                            filterWidget: ProcessFilter(
                              params: params,
                              onHandleFilter: _handleProcessFilter,
                              onDateRangeSelected:
                                  _isMobile ? _handleProcessDateRange : null,
                            ),
                            handleFetchData: (params) async {
                              final service =
                                  Provider.of<WorkOrderProcessService>(
                                context,
                                listen: false,
                              );
                              await service.getDataList(context, params);
                              return service.items;
                            },
                            service: WorkOrderProcessService(),
                            isFiltered: _isFiltered,
                          ),
                      ].separatedBy(CustomTheme().vGap('2xl')),
=======
                          ),
                        ],
                        SizedBox(height: sectionGap),
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
                            final service =
                                Provider.of<WorkOrderProcessService>(
                              context,
                              listen: false,
                            );

                            await service.getDataList(
                              context,
                              params,
                            );

                            return service.items;
                          },
                          service: WorkOrderProcessService(),
                          isFiltered: _isFiltered,
                        ),
                      ],
>>>>>>> d86a31e7 (fix: UI mobile dashboard)
=======
                  padding: CustomTheme().padding('content'),
                  sliver: SliverList(
=======
                  padding: CustomTheme().padding('content'),
                  sliver: SliverList(
>>>>>>> a6b1bf80 (fix: UI dashboard)
                      delegate: SliverChildListDelegate([
                    WorkOrderStats(data: statsList, isFetching: isStatsLoading),
                    WorkOrderSummary(
                      data: summaryList,
                      handleRefetch: _handleFetchSummary,
                      isFetching: isSummaryLoading,
                      filterWidget: SummaryFilter(
                        dariTanggal: dariTanggalSummary,
                        sampaiTanggal: sampaiTanggalSummary,
                        onHandleFilter: _handleSummaryFilter,
                        params: summaryParams,
                      ),
<<<<<<< HEAD
>>>>>>> 46f4802b (fix: UI dashboard)
=======
                  sliver: SliverList(
=======
                  sliver: SliverList(
>>>>>>> 8d5fb5bc (fix: UI mobile dashboard)
                    delegate: SliverChildListDelegate(
                      [
                        WorkOrderStats(
                          data: statsList,
                          isFetching: isStatsLoading,
                        ),
                        SizedBox(height: sectionGap),
                        WorkOrderSummary(
                          data: summaryList,
                          handleRefetch: _handleFetchSummary,
                          isFetching: isSummaryLoading,
                          filterWidget: SummaryFilter(
                            dariTanggal: dariTanggalSummary,
                            sampaiTanggal: sampaiTanggalSummary,
                            onHandleFilter: _handleSummaryFilter,
                            params: summaryParams,
                          ),
                        ),
                        if (!shouldHideActiveMachine) ...[
                          SizedBox(height: sectionGap),
                          ActiveMachine(
                            data: machineList,
                            available: machineList['available'],
                            unavailable: machineList['unavailable'],
                            handleRefetch: _handleFetchMachine,
                            isFetching: isMachineLoading,
                          ),
                        ],
                        SizedBox(height: sectionGap),
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
                            final service =
                                Provider.of<WorkOrderProcessService>(
                              context,
                              listen: false,
                            );

                            await service.getDataList(
                              context,
                              params,
                            );

                            return service.items;
                          },
                          service: WorkOrderProcessService(),
                          isFiltered: _isFiltered,
                        ),
                      ],
<<<<<<< HEAD
>>>>>>> 73378bdd (fix: UI mobile dashboard)
=======
                  padding: CustomTheme().padding('content'),
=======
>>>>>>> 62cb1f4a (fix: UI mobile dashboard)
=======
                  padding: CustomTheme().padding('content'),
>>>>>>> e29a2ffd (fix: UI dashboard)
                  sliver: SliverList(
                      delegate: SliverChildListDelegate([
                    WorkOrderStats(data: statsList, isFetching: isStatsLoading),
                    if (widget.showWorkOrderSummary)
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
<<<<<<< HEAD
>>>>>>> 0f73a2e7 (fix: UI dashboard)
=======
>>>>>>> 8d5fb5bc (fix: UI mobile dashboard)
=======
>>>>>>> a6b1bf80 (fix: UI dashboard)
                    ),
                    if (!shouldHideActiveMachine)
=======
                    if (widget.showActiveMachine && !shouldHideActiveMachine)
>>>>>>> 5e1caa7c (feat: widget controller)
                      ActiveMachine(
                        data: machineList,
                        available: machineList['available'],
                        unavailable: machineList['unavailable'],
                        handleRefetch: _handleFetchMachine,
                        isFetching: isMachineLoading,
                        processNames: menuProcessNames,
                      ),
                    if (widget.showWorkOrderProcess)
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
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _isDashboardWidgetsLoading ? null : _showDashboardWidgetSettings,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: CustomTheme().cardTheme(),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Widget Dashboard',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              _isDashboardWidgetsLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.dashboard_customize_outlined),
            ],
          ),
        ),
      ),
    );
  }
}
