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

  @override
  void initState() {
    super.initState();

    _handleFetchStats();
  }

  Future<void> _handleFetchStats() async {
    await Provider.of<WorkOrderStatsService>(context, listen: false)
        .getDataList();
    await Provider.of<WorkOrderChartService>(context, listen: false)
        .getDataList();
    await Provider.of<WorkOrderChartService>(context, listen: false)
        .getDataPie();
    final result =
        // ignore: use_build_context_synchronously
        Provider.of<WorkOrderStatsService>(context, listen: false).dataList;
    final resultChart =
        // ignore: use_build_context_synchronously
        Provider.of<WorkOrderChartService>(context, listen: false).dataList;
    print('c: $resultChart');
    final resultPie =
        // ignore: use_build_context_synchronously
        Provider.of<WorkOrderChartService>(context, listen: false).dataPie;

    setState(() {
      statsList = result;
      chartList = resultChart;
      pieList = resultPie;
      dashboardSections = [
        WorkOrderStats(data: statsList),
        WorkOrderChart(
          data: chartList,
        ),
        WorkOrderPie(
          data: pieList,
          process: chartList,
        )
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9fafc),
      body: dashboardSections.isEmpty
          ? const Center(
              child: NoData(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children:
                      dashboardSections.separatedBy(const SizedBox(height: 8)),
                ),
              ),
            ),
    );
  }
}
