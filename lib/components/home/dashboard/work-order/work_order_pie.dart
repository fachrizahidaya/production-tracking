import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dashboard_card.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WorkOrderPie extends StatefulWidget {
  final List<dynamic>? data;
  final process;

  const WorkOrderPie({super.key, this.data, this.process});

  @override
  State<WorkOrderPie> createState() => WorkOrderPieState();
}

class WorkOrderPieState extends State<WorkOrderPie> {
  int touchedIndex = -1;

  static const List<IconData> processIcons = [
    Icons.invert_colors_on_outlined,
    Icons.dry_outlined,
    Icons.dry_cleaning_outlined,
    Icons.air,
    Icons.cut_outlined,
    Icons.link_outlined,
    Icons.cut,
    Icons.link_outlined,
    Icons.numbers_outlined,
    Icons.print_outlined,
    Icons.sort,
    Icons.stacked_bar_chart_outlined,
    Icons.dangerous,
  ];

  IconData getIcon(int index) {
    if (index < processIcons.length) return processIcons[index];
    return Icons.dangerous;
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = widget.process.isEmpty;

    return DashboardCard(
      child: Column(
        children: [
          Padding(
            padding: CustomTheme().padding('card'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alur Proses Produksi'),
                    Text(
                      'Tahapan lengkap proses produksi dari awal hingga akhir',
                      style: TextStyle(
                          fontSize: CustomTheme().fontSize('sm'),
                          color: CustomTheme().colors('secondary')),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          if (isEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(child: NoData()),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: CustomTheme().padding('badge'),
                child: Row(
                  children: List.generate(
                    widget.process.length,
                    (i) => Row(
                      children: [
                        _buildProcessItem(
                          index: i,
                          name: widget.process[i]['name'] ?? '',
                        ),
                        if (i != widget.process.length - 1)
                          Padding(
                            padding: EdgeInsets.only(bottom: 24),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: CustomTheme().iconSize('xl'),
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProcessItem({required int index, required String name}) {
    return Column(
      children: [
        Column(
          children: [
            Container(
              decoration: CustomTheme()
                  .processCardTheme(CustomTheme().colors('primary')),
              padding: CustomTheme().padding('card'),
              child: Icon(
                getIcon(index),
                color: Colors.white,
                size: CustomTheme().iconSize('5xl'),
              ),
            ),
            SizedBox(
              width: 80,
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ].separatedBy(CustomTheme().vGap('lg')),
        ),
      ],
    );
  }
}
