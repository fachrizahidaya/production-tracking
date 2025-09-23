import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/text/no_data.dart';
import 'package:production_tracking/helpers/util/padding_column.dart';
import 'package:production_tracking/helpers/util/separated_column.dart';

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
      body: SingleChildScrollView(
        padding: PaddingColumn.screen,
        child: Column(
            children: dashboardSections.isNotEmpty
                ? dashboardSections.separatedBy(SizedBox(
                    height: 16,
                  ))
                : const [
                    Center(
                        child: NoData(
                      fontSize: 24,
                    ))
                  ]),
      ),
    );
  }
}
