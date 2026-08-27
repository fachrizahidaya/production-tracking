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
  final bool isMobile;
  final Future<void> Function()? onRefreshReworkNotifications;

  const Dashboard({
    super.key,
    required this.isMobile,
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
      if (mounted) {
        _loadDashboardData();
      }
    });
  }

  bool get shouldHideActiveMachine {
    bool checkMenus(List<dynamic> menuList) {
      for (final menu in menuList) {
        final name = (menu['name'] ?? '').toString().toLowerCase();

        // if (name == 'sorting' || name == 'packing') {
        //   return true;
        // }

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

    await Future.wait([
      _safeFetch(_handleFetchMenu),
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
      throw (e.toString());
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
      debugPrint('Machine Error: $e');

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

      if (!mounted) return;

      setState(() {
        summaryList = service.dataList;
        greigeSummaryList = service.preDataList;
      });
    } catch (e) {
      debugPrint('Summary Error: $e');

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

    setState(() {
      _isLoadMore = true;
    });

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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final sectionGap = isMobile ? 16.0 : 24.0;

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
                  padding: EdgeInsets.zero,
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
                          ActiveMachine(
                            data: machineList,
                            available: machineList['available'],
                            unavailable: machineList['unavailable'],
                            handleRefetch: _handleFetchMachine,
                            isFetching: isMachineLoading,
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
                    ),
                  ),
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
