import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/work_order_chart.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/work_order_pie.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/work_order_stats.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/master/work_order_chart.dart';
import 'package:textile_tracking/models/master/work_order_stats.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<dynamic> statsList = [];
  late List<dynamic> chartList = [];
  late List<dynamic> pieList = [];

  List<Widget> dashboardSections = [];

  String dariTanggal = '';
  String sampaiTanggal = '';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final today = now;

    dariTanggal = DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
    sampaiTanggal = DateFormat('yyyy-MM-dd').format(today);

    _handleFetchStats(
      fromDate: dariTanggal,
      toDate: sampaiTanggal,
    );
  }

  Future<void> _handleFetchStats({String? fromDate, String? toDate}) async {
    setState(() {
      isLoading = true;
    });

    final chartParams = {
      'process_start_date': fromDate ?? dariTanggal,
      'process_end_date': toDate ?? sampaiTanggal,
    };

    try {
      await Provider.of<WorkOrderStatsService>(context, listen: false)
          .getDataList();
      await Provider.of<WorkOrderChartService>(context, listen: false)
          .getDataList(chartParams);
      await Provider.of<WorkOrderChartService>(context, listen: false)
          .getDataPie();

      final result =
          Provider.of<WorkOrderStatsService>(context, listen: false).dataList;
      final resultChart =
          Provider.of<WorkOrderChartService>(context, listen: false).dataList;
      final resultPie =
          Provider.of<WorkOrderChartService>(context, listen: false).dataPie;

      setState(() {
        statsList = result;
        chartList = resultChart;
        pieList = resultPie;

        dashboardSections = [
          WorkOrderStats(data: statsList),
          WorkOrderChart(
            data: chartList,
            dariTanggal: dariTanggal,
            sampaiTanggal: sampaiTanggal,
            onHandleFilter: _handleFilter,
          ),
          WorkOrderPie(
            data: pieList,
            process: chartList,
          )
        ];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleFilter(String type, String value) {
    setState(() {
      if (type == 'dari_tanggal') dariTanggal = value;
      if (type == 'sampai_tanggal') sampaiTanggal = value;
    });

    _handleFetchStats(
      fromDate: dariTanggal,
      toDate: sampaiTanggal,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: dashboardSections
                            .separatedBy(const SizedBox(height: 8)),
                      ),
                    ),
                  ),
      ),
    );
  }
}
