// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/home/dashboard/filter/process_filter.dart';
import 'package:textile_tracking/components/home/dashboard/filter/summary_filter.dart';
import 'package:textile_tracking/components/home/dashboard/machine/active_machine.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/work_order_process.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/work_order_pie.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/work_order_stats.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/work_order_summary.dart';
import 'package:textile_tracking/components/master/layout/card/item_process.dart';
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

  String dariTanggal = '';
  String sampaiTanggal = '';
  String dariTanggalProses = '';
  String sampaiTanggalProses = '';
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
  bool isChartLoading = false;
  bool isMachineLoading = false;
  bool isSummaryLoading = false;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    dariTanggal = DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
    sampaiTanggal = DateFormat('yyyy-MM-dd').format(now);
    dariTanggalProses = DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
    sampaiTanggalProses = DateFormat('yyyy-MM-dd').format(now);
    dariTanggalSummary = DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
    sampaiTanggalSummary = DateFormat('yyyy-MM-dd').format(now);

    setState(() {
      params = {
        'search': _search,
        'page': '0',
        'start_date': dariTanggalProses,
        'end_date': sampaiTanggalProses,
      };
    });
    setState(() {
      chartParams = {
        'process_start_date': dariTanggal,
        'process_end_date': sampaiTanggal,
      };
    });
    setState(() {
      summaryParams = {
        'start_date': dariTanggalProses,
        'end_date': sampaiTanggalProses,
      };
    });
    Future.delayed(Duration.zero, () {
      _loadMore();
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
    setState(() => isLoading = true);

    try {
      await Future.wait([
        _handleFetchStats(),
        _handleFetchPie(),
        _handleFetchCharts(
          fromDate: dariTanggal,
          toDate: sampaiTanggal,
        ),
        _handleFetchMachine(),
        _handleFetchSummary(
            fromDate: dariTanggalSummary, toDate: sampaiTanggalSummary),
        _loadMore(),
      ]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _handleFetchCharts({String? fromDate, String? toDate}) async {
    setState(() => isChartLoading = true);

    await Provider.of<WorkOrderChartService>(context, listen: false)
        .getDataList(chartParams);

    setState(() {
      chartList =
          Provider.of<WorkOrderChartService>(context, listen: false).dataList;
      isChartLoading = false;
    });
  }

  Future<void> _handleFetchStats() async {
    await Provider.of<WorkOrderStatsService>(context, listen: false)
        .getDataList();

    setState(() {
      statsList =
          Provider.of<WorkOrderStatsService>(context, listen: false).dataList;
    });
  }

  Future<void> _handleFetchMachine() async {
    setState(() => isMachineLoading = true);

    await Provider.of<MachineService>(context, listen: false).getDataList();

    setState(() {
      machineList =
          Provider.of<MachineService>(context, listen: false).dataList;
      isMachineLoading = false;
    });
  }

  Future<void> _handleFetchPie() async {
    await Provider.of<WorkOrderChartService>(context, listen: false)
        .getDataPie();

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
    setState(() => isSummaryLoading = true);

    await Provider.of<WorkOrderSummaryService>(context, listen: false)
        .getDataList(summaryParams);

    setState(() {
      summaryList =
          Provider.of<WorkOrderSummaryService>(context, listen: false).dataList;
      isSummaryLoading = false;
    });
  }

  void _handleFilter(String key, String value) {
    setState(() {
      if (value.isEmpty) {
        chartParams.remove(key);
      } else {
        chartParams[key] = value;
      }
    });

    _handleFetchCharts();
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

  Future<void> _submitFilter() async {
    Navigator.pop(context);
    setState(() {
      _isFiltered = _checkIsFiltered();
    });
    _loadMore();
  }

  Future<void> _pickDate({
    required TextEditingController controller,
    required String type,
    handleProcess,
  }) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.text.isNotEmpty
          ? DateTime.tryParse(controller.text) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: CustomTheme().colors('base'),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        controller.text = formattedDate;
      });
      handleProcess(type, formattedDate);
    }
  }

  Future<void> _handleSearch(String value) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _search = value;
        params['search'] = value;
        params['page'] = '0';
      });
      _loadMore();
    });
  }

  Future<void> _loadMore() async {
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
        .getDataList(params);

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
      setState(() {
        params = {
          'search': _search,
          'page': '0',
          'start_date': dariTanggalProses,
          'end_date': sampaiTanggalProses,
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
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFf9fafc),
        body: RefreshIndicator(
            onRefresh: () => _loadDashboardData(),
            child: CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: CustomTheme().padding('content'),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate([
                    WorkOrderStats(data: statsList),
                    // WorkOrderChart(
                    //   data: chartList,
                    //   filterWidget: ChartFilter(
                    //     dariTanggal: dariTanggal,
                    //     sampaiTanggal: sampaiTanggal,
                    //     onHandleFilter: _handleFilter,
                    //     pickDate: _pickDate,
                    //     params: chartParams,
                    //   ),
                    //   handleRefetch: _handleFetchCharts,
                    //   isFetching: isChartLoading,
                    // ),
                    WorkOrderSummary(
                      data: summaryList,
                      handleRefetch: _handleFetchSummary,
                      isFetching: isSummaryLoading,
                      filterWidget: SummaryFilter(
                        dariTanggal: dariTanggalSummary,
                        sampaiTanggal: sampaiTanggalSummary,
                        onHandleFilter: _handleSummaryFilter,
                        pickDate: _pickDate,
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
                    WorkOrderPie(
                      data: pieList,
                      process: chartList,
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
                        title: 'Filter',
                        params: params,
                        onHandleFilter: _handleProcessFilter,
                        onSubmitFilter: _submitFilter,
                        dariTanggal: dariTanggalProses,
                        sampaiTanggal: sampaiTanggalProses,
                        pickDate: _pickDate,
                      ),
                      handleFetchData: (params) async {
                        final service = Provider.of<WorkOrderProcessService>(
                            context,
                            listen: false);
                        await service.getDataList(params);
                        return service.items;
                      },
                      handleBuildItem: (item) => ItemProcess(item: item),
                      onHandleFilter: _handleFilter,
                      service: WorkOrderProcessService(),
                      isFiltered: _isFiltered,
                    ),
                  ].separatedBy(CustomTheme().vGap('2xl')))),
                ),
              ],
            )
            // NestedScrollView(
            //   physics: const AlwaysScrollableScrollPhysics(),
            //   headerSliverBuilder: (context, innerBoxIsScrolled) {
            //     return [
            //       SliverPadding(
            //         padding: CustomTheme().padding('content'),
            //         sliver: SliverList(
            //           delegate: SliverChildListDelegate(
            //             [
            //               WorkOrderStats(data: statsList),
            //               // WorkOrderChart(
            //               //   data: chartList,
            //               //   filterWidget: ChartFilter(
            //               //     dariTanggal: dariTanggal,
            //               //     sampaiTanggal: sampaiTanggal,
            //               //     onHandleFilter: _handleFilter,
            //               //     pickDate: _pickDate,
            //               //     params: chartParams,
            //               //   ),
            //               //   handleRefetch: _handleFetchCharts,
            //               //   isFetching: isChartLoading,
            //               // ),
            //               WorkOrderSummary(
            //                 data: summaryList,
            //                 dariTanggal: dariTanggalSummary,
            //                 sampaiTanggal: sampaiTanggalSummary,
            //                 handleRefetch: _handleFetchSummary,
            //                 isFetching: isSummaryLoading,
            //                 handleProcess: _handleSummaryFilter,
            //               ),
            //               ActiveMachine(
            //                 data: machineList,
            //                 available: machineList['available'],
            //                 unavailable: machineList['unavailable'],
            //                 handleRefetch: _handleFetchMachine,
            //                 isFetching: isMachineLoading,
            //               ),
            //               WorkOrderPie(
            //                 data: pieList,
            //                 process: chartList,
            //               ),
            //               WorkOrderProcessScreen(
            //                 data: _dataList,
            //                 search: _search,
            //                 handleSearch: _handleSearch,
            //                 firstLoading: _firstLoading,
            //                 hasMore: _hasMore,
            //                 handleLoadMore: _loadMore,
            //                 handleRefetch: _refetch,
            //                 isLoadMore: _isLoadMore,
            //                 filterWidget: ProcessFilter(
            //                   title: 'Filter',
            //                   params: params,
            //                   onHandleFilter: _handleProcessFilter,
            //                   onSubmitFilter: _submitFilter,
            //                   dariTanggal: dariTanggalProses,
            //                   sampaiTanggal: sampaiTanggalProses,
            //                   pickDate: _pickDate,
            //                 ),
            //                 handleFetchData: (params) async {
            //                   final service =
            //                       Provider.of<WorkOrderProcessService>(context,
            //                           listen: false);
            //                   await service.getDataList(params);
            //                   return service.items;
            //                 },
            //                 handleBuildItem: (item) => ItemProcess(item: item),
            //                 onHandleFilter: _handleFilter,
            //                 service: WorkOrderProcessService(),
            //                 isFiltered: _isFiltered,
            //               ),
            //             ].separatedBy(CustomTheme().vGap('2xl')),
            //           ),
            //         ),
            //       ),
            //     ];
            //   },
            //   body: const SizedBox.shrink(),
            // ),
            ),
      ),
    );
  }
}
