// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/home/dashboard/filter/chart_filter.dart';
import 'package:textile_tracking/components/home/dashboard/filter/process_filter.dart';
import 'package:textile_tracking/components/home/dashboard/machine/active_machine.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/work_order_process.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/work_order_chart.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/work_order_pie.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/work_order_stats.dart';
import 'package:textile_tracking/components/master/layout/card/item_process.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/dashboard/machine.dart';
import 'package:textile_tracking/models/dashboard/work_order_chart.dart';
import 'package:textile_tracking/models/dashboard/work_order_process.dart';
import 'package:textile_tracking/models/dashboard/work_order_stats.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic> statsList = [];
  List<dynamic> chartList = [];
  List<dynamic> pieList = [];
  List<dynamic> processList = [];
  Map<String, dynamic> machineList = {};

  final TextEditingController dariTanggalInput = TextEditingController();
  final TextEditingController sampaiTanggalInput = TextEditingController();

  String dariTanggal = '';
  String sampaiTanggal = '';
  String dariTanggalProses = '';
  String sampaiTanggalProses = '';

  bool isLoading = false;
  Timer? _debounce;
  Map<String, String> params = {'search': '', 'page': '0'};
  bool _isLoading = false;
  bool _hasMore = true;
  bool _firstLoading = true;
  bool isChartLoading = false;
  bool isMachineLoading = false;
  String _search = '';
  final List<dynamic> _dataList = [];

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    dariTanggal = DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
    sampaiTanggal = DateFormat('yyyy-MM-dd').format(now);
    dariTanggalProses = DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
    sampaiTanggalProses = DateFormat('yyyy-MM-dd').format(now);

    dariTanggalInput.text = dariTanggal;
    sampaiTanggalInput.text = sampaiTanggal;

    setState(() {
      params = {
        'search': _search,
        'page': '0',
        'start_date': dariTanggalProses,
        'end_date': sampaiTanggalProses,
      };
    });
    Future.delayed(Duration.zero, () {
      _loadMore();
    });

    _loadDashboardData();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (dariTanggal != dariTanggalInput.text) {
      dariTanggalInput.text = dariTanggal;
    }
    if (sampaiTanggal != sampaiTanggalInput.text) {
      sampaiTanggalInput.text = sampaiTanggal;
    }
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

    final params = {
      'process_start_date': fromDate ?? dariTanggal,
      'process_end_date': toDate ?? sampaiTanggal,
    };

    await Provider.of<WorkOrderChartService>(context, listen: false)
        .getDataList(params);

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

  void _handleFilter(String type, String value) {
    setState(() {
      if (type == 'dari_tanggal') dariTanggal = value;
      if (type == 'sampai_tanggal') sampaiTanggal = value;
    });

    _handleFetchCharts(
      fromDate: dariTanggal,
      toDate: sampaiTanggal,
    );
  }

  void _handleProcessFilter(String key, dynamic value) {
    setState(() {
      params['page'] = '0';
      if (value != null && value.toString().isNotEmpty) {
        params[key] = value.toString();
      } else {
        params.remove(key);
      }
    });

    _loadMore();
  }

  Future<void> _submitFilter() async {
    Navigator.pop(context);
    _loadMore();
  }

  Future<void> _pickDate({
    required TextEditingController controller,
    required String type,
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
      _handleFilter(type, formattedDate);
    }
  }

  Future<void> _handleSearch(String value) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        params = {'search': value, 'page': '0'};
      });
      _loadMore();
    });
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;
    _isLoading = true;

    if (params['page'] == '0') {
      setState(() {
        _dataList.clear();
        _firstLoading = true;
        _hasMore = true;
      });
    }

    final currentPage = int.parse(params['page']!);

    try {
      List loadData =
          await Provider.of<WorkOrderProcessService>(context, listen: false)
              .getDataProcess(params);
      if (loadData.isEmpty) {
        setState(() {
          _firstLoading = false;
          _hasMore = false;
        });
      } else {
        setState(() {
          _dataList.addAll(loadData);
          _firstLoading = false;
          params['page'] = (currentPage + 1).toString();
          if (loadData.length < 20) {
            _hasMore = false;
          }
        });
      }
    } finally {
      _isLoading = false;
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
    dariTanggalInput.dispose();
    sampaiTanggalInput.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> dashboardSections = [];

    dashboardSections.add(WorkOrderStats(data: statsList));

    dashboardSections.add(
      WorkOrderChart(
        data: chartList,
        dariTanggal: dariTanggal,
        sampaiTanggal: sampaiTanggal,
        onHandleFilter: _handleFilter,
        filterWidget: ChartFilter(
          dariTanggal: dariTanggalInput,
          sampaiTanggal: sampaiTanggalInput,
          onHandleFilter: _handleFilter,
          pickDate: _pickDate,
        ),
        handleRefetch: _handleFetchCharts,
        isFetching: isChartLoading,
      ),
    );

    dashboardSections.add(
      WorkOrderPie(
        data: pieList,
        process: chartList,
      ),
    );

    dashboardSections.add(ActiveMachine(
      data: machineList,
      available: machineList['available'],
      unavailable: machineList['unavailable'],
      handleRefetch: _handleFetchMachine,
      isFetching: isMachineLoading,
    ));

    dashboardSections.add(
      WorkOrderProcessScreen(
        data: _dataList,
        search: _search,
        handleSearch: _handleSearch,
        firstLoading: _firstLoading,
        hasMore: _hasMore,
        handleLoadMore: _loadMore,
        handleRefetch: _refetch,
        filterWidget: ProcessFilter(
          title: 'Filter',
          params: params,
          onHandleFilter: _handleProcessFilter,
          onSubmitFilter: () {
            _submitFilter();
          },
          dariTanggal: dariTanggalProses,
          sampaiTanggal: sampaiTanggalProses,
          pickDate: _pickDate,
        ),
        handleFetchData: (params) async {
          return await Provider.of<WorkOrderProcessService>(context,
                  listen: false)
              .getDataProcess(params);
        },
        handleBuildItem: (item) => Align(
          alignment: Alignment.centerLeft,
          child: ItemProcess(
            item: item,
          ),
        ),
        onHandleFilter: _handleFilter,
        service: WorkOrderProcessService(),
        isFiltered: false,
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFFf9fafc),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : dashboardSections.isEmpty
                ? Center(child: NoData())
                : RefreshIndicator(
                    onRefresh: () => _loadDashboardData(),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children:
                            dashboardSections.separatedBy(SizedBox(height: 8)),
                      ),
                    ),
                  ),
      ),
    );
  }
}
