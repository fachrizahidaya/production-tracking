// ignore_for_file: use_build_context_synchronously, prefer_final_fields, control_flow_in_finally

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic> statsList = [];
  List<dynamic> chartList = [];
  List<dynamic> pieList = [];
  List<dynamic> summaryList = [];
  Map<String, dynamic> machineList = {};
  final List<dynamic> _dataList = [];
  List<dynamic> menus = [];

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

  bool get isMobile => MediaQuery.of(context).size.width < 600;

  bool get isTablet => MediaQuery.of(context).size.width >= 600;

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
      });
    } catch (e) {
      debugPrint('Error fetch menu: $e');
    }
  }

  bool _checkIsFiltered() {
    return params.keys.any(
        (key) => key != 'page' && key != 'search' && params[key]!.isNotEmpty);
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
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
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
    } catch (e, s) {
      debugPrint('Machine Error: $e');
      debugPrintStack(stackTrace: s);

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
    });

    try {
      final service =
          Provider.of<WorkOrderSummaryService>(context, listen: false);

      await service.getDataList(context, summaryParams);

      if (!mounted) return;

      setState(() {
        summaryList = service.dataList;
      });
    } catch (e, s) {
      debugPrint('Summary Error: $e');
      debugPrintStack(stackTrace: s);

      if (!mounted) return;

      setState(() {
        summaryList = [];
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

    // _handleFetchSummary();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final sectionGap = isMobile ? 16.0 : 24.0;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFFf9fafc),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await _loadDashboardData();
            },
            child: CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 24,
                    vertical: isMobile ? 12 : 20,
                  ),
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
}
