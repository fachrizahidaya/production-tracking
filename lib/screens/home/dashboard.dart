import 'package:flutter/material.dart';
import 'package:production_tracking/components/dashboard/work_order_status.dart';
import 'package:production_tracking/helpers/util/padding_column.dart';
import 'package:production_tracking/helpers/util/separated_column.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Widget> dashboardSections = [WorkOrderStatus()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      body: SingleChildScrollView(
        padding: PaddingColumn.screen,
        child: Column(
          children: dashboardSections.separatedBy(SizedBox(
            height: 16,
          )),
        ),
      ),
    );
  }
}
