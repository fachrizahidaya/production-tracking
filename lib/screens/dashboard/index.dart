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

    setState(() {
      params = {
        'search': _search,
        'page': '0',
      };
    });

    setState(() {
      summaryParams = {
        'start_date': dariTanggalSummary,
        'end_date': sampaiTanggalSummary,
      };
    });

    _loadDashboardData();
  }

  bool _checkIsFiltered() {
    final filterKeys = [
      'status',
    ];

    for (var key in filterKeys) {
      if (params[key] != null && params[key]!.isNotEmpty) {
        return true;
      }
    }

    return false;
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _loadDashboardData() async {
    if (!mounted) return;

    setState(() => isLoading = true);

    try {
      await Future.wait([
        _handleFetchStats(),
        _handleFetchPie(),
        _handleFetchMachine(),
        _handleFetchSummary(
          fromDate: dariTanggalSummary,
          toDate: sampaiTanggalSummary,
        ),
      ]);

      await _loadMore(); // pindahkan ke sini
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> _handleFetchStats() async {
    if (!mounted) return;
    setState(() => isStatsLoading = true);

    await Provider.of<WorkOrderStatsService>(context, listen: false)
        .getDataList();

    if (!mounted) return;
    setState(() {
      statsList =
          Provider.of<WorkOrderStatsService>(context, listen: false).dataList;
      isStatsLoading = false;
    });
  }

  Future<void> _handleFetchMachine() async {
    if (!mounted) return;
    setState(() => isMachineLoading = true);

    await Provider.of<MachineService>(context, listen: false).getDataList();

    if (!mounted) return;
    setState(() {
      machineList =
          Provider.of<MachineService>(context, listen: false).dataList;
      isMachineLoading = false;
    });
  }

  Future<void> _handleFetchPie() async {
    await Provider.of<WorkOrderChartService>(context, listen: false)
        .getDataPie();

    if (!mounted) return;
    setState(() {
      pieList =
          Provider.of<WorkOrderChartService>(context, listen: false).dataPie;
    });
  }

  Future<void> _handleFetchSummary({
    String? fromDate,
    String? toDate,
    String? status,
  }) async {
    if (!mounted) return;
    setState(() => isSummaryLoading = true);

    await Provider.of<WorkOrderSummaryService>(context, listen: false)
        .getDataList(context, summaryParams);

    if (!mounted) return;
    setState(() {
      summaryList =
          Provider.of<WorkOrderSummaryService>(context, listen: false).dataList;
      isSummaryLoading = false;
    });
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

    _debounce = Timer(const Duration(milliseconds: 500), () {
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
    _isLoadMore = true;

    if (params['page'] == '0') {
      setState(() {
        _dataList.clear();
        _firstLoading = true;
        _hasMore = true;
      });
    }

    String newPage = (int.parse(params['page']!) + 1).toString();
    setState(() {
      params['page'] = newPage;
    });

    await Provider.of<WorkOrderProcessService>(context, listen: false)
        .getDataList(context, params);

    if (!mounted) return;

    List<dynamic> loadData =
        Provider.of<WorkOrderProcessService>(context, listen: false).items;

    if (loadData.isEmpty) {
      setState(() {
        _firstLoading = false;
        _isLoadMore = false;
        _hasMore = false;
      });
    } else {
      setState(() {
        _dataList.addAll(loadData);
        _firstLoading = false;
        _isLoadMore = false;
      });
    }
  }

  _refetch() {
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      setState(() {
        params = {
          'search': _search,
          'page': '0',
        };
      });
      _loadMore();
    });
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
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: CustomTheme().padding('content'),
                sliver: SliverList(
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
                  ),
                  ActiveMachine(
                    data: machineList,
                    available: machineList['available'],
                    unavailable: machineList['unavailable'],
                    handleRefetch: _handleFetchMachine,
                    isFetching: isMachineLoading,
                  ),
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
    );
  }
}
