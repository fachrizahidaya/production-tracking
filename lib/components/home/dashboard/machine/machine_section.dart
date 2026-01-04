import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/process_card.dart';
import 'package:textile_tracking/components/home/dashboard/machine/machine_card.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class MachineSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final headerColor;
  final List<dynamic> data;
  final bool isPortrait;
  final status;

  const MachineSection(
      {super.key,
      required this.title,
      required this.icon,
      this.headerColor,
      required this.data,
      required this.isPortrait,
      this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProcessCard(
          forMachine: true,
          status: headerColor,
          child: Row(
            children: [
              Icon(
                icon,
                color: status,
              ),
              Text('$title (${data.length})'),
            ].separatedBy(CustomTheme().hGap('lg')),
          ),
        ),
        SizedBox(
          height: 500,
          child: data.isEmpty
              ? Center(child: NoData())
              : CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return MachineCard(
                            data: data[index],
                            isPortrait: isPortrait,
                          );
                        },
                        childCount: data.length,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
