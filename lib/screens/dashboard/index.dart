import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Widget> dashboardSections = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      body: Expanded(
        // padding: PaddingColumn.screen,
        child: dashboardSections.isEmpty
            ? Center(
                child: NoData(
                fontSize: 24,
              ))
            : Column(
                children: dashboardSections.separatedBy(SizedBox(
                height: 16,
              ))),
      ),
    );
  }
}
