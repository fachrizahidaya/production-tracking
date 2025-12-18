import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/machine/machine_card.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class MachineSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color headerColor;
  final List<dynamic> data;
  final bool isPortrait;

  const MachineSection({
    super.key,
    required this.title,
    required this.icon,
    required this.headerColor,
    required this.data,
    required this.isPortrait,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCard(
          color: headerColor,
          child: Padding(
            padding: PaddingColumn.screen,
            child: Row(
              children: [
                Icon(icon),
                Text('$title (${data.length})'),
              ].separatedBy(const SizedBox(width: 8)),
            ),
          ),
        ),
        SizedBox(
          height: 500,
          child: data.isEmpty
              ? const Center(child: NoData())
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
