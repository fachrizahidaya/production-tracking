import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/work_order_chart.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/work_order_pie.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/work_order_stats.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/master/work_order_chart.dart';
import 'package:textile_tracking/models/master/work_order_process.dart';
import 'package:textile_tracking/models/master/work_order_stats.dart';

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

  String dariTanggal = '';
  String sampaiTanggal = '';
  String dariTanggalProses = '';
  String sampaiTanggalProses = '';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    dariTanggal = DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
    sampaiTanggal = DateFormat('yyyy-MM-dd').format(now);
    dariTanggalProses = DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
    sampaiTanggalProses = DateFormat('yyyy-MM-dd').format(now);

    // Fetch all data at once
    _loadDashboardData();
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
        _handleFetchProcess(
            fromDate: dariTanggalProses, toDate: sampaiTanggalProses)
      ]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _handleFetchCharts({String? fromDate, String? toDate}) async {
    final params = {
      'process_start_date': fromDate ?? dariTanggal,
      'process_end_date': toDate ?? sampaiTanggal,
    };

    await Provider.of<WorkOrderChartService>(context, listen: false)
        .getDataList(params);

    setState(() {
      chartList =
          Provider.of<WorkOrderChartService>(context, listen: false).dataList;
    });
  }

  Future<void> _handleFetchProcess({String? fromDate, String? toDate}) async {
    final params = {
      'process_start_date': fromDate ?? dariTanggalProses,
      'process_end_date': toDate ?? sampaiTanggalProses,
    };

    await Provider.of<WorkOrderProcessService>(context, listen: false)
        .getDataProcess(params);

    setState(() {
      processList = Provider.of<WorkOrderProcessService>(context, listen: false)
          .dataProcess;
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

  @override
  Widget build(BuildContext context) {
    List<Widget> dashboardSections = [];

    if (statsList.isNotEmpty) {
      dashboardSections.add(WorkOrderStats(data: statsList));
    }

    if (chartList.isNotEmpty) {
      dashboardSections.add(
        WorkOrderChart(
          data: chartList,
          dariTanggal: dariTanggal,
          sampaiTanggal: sampaiTanggal,
          onHandleFilter: _handleFilter,
        ),
      );
    }

    if (pieList.isNotEmpty) {
      dashboardSections.add(
        WorkOrderPie(
          data: pieList,
          process: chartList,
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFf9fafc),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : dashboardSections.isEmpty
                ? const Center(child: NoData())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: dashboardSections
                          .separatedBy(const SizedBox(height: 8)),
                    ),
                  ),
      ),
    );
  }
}
