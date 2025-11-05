import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/dasboard_card.dart';
import 'package:textile_tracking/helpers/util/margin_card.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
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

  @override
  Widget build(BuildContext context) {
    final summary = widget.data ?? [];

    // Handle empty or zero data
    final total = summary.fold<num>(0, (sum, e) => sum + (e['value'] ?? 0));
    final hasData = total > 0;

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: DasboardCard(
              child: Padding(
            padding: PaddingColumn.screen,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Alur Proses Produksi'),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < widget.process?.length; i++)
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xff3b82f6),
                                borderRadius: BorderRadius.circular(4)),
                            padding: MarginCard.screen,
                            child: Icon(
                              i == 0
                                  ? Icons.invert_colors_on_outlined
                                  : i == 1
                                      ? Icons.content_copy_rounded
                                      : i == 2
                                          ? Icons.air
                                          : i == 3
                                              ? Icons.content_paste_outlined
                                              : i == 4
                                                  ? Icons.cut
                                                  : i == 5
                                                      ? Icons.cut
                                                      : i == 6
                                                          ? Icons.link_outlined
                                                          : i == 7
                                                              ? Icons
                                                                  .color_lens_outlined
                                                              : i == 8
                                                                  ? Icons.sort
                                                                  : i == 9
                                                                      ? Icons
                                                                          .stacked_bar_chart_outlined
                                                                      : Icons
                                                                          .dangerous,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          Text(widget.process?[i]['name'])
                        ].separatedBy(SizedBox(
                          height: 8,
                        )),
                      )
                  ],
                ),
              ].separatedBy(SizedBox(
                height: 16,
              )),
            ),
          )),
        ),
        // Expanded(
        //   flex: 1,
        //   child: DasboardCard(
        //       child: Padding(
        //     padding: PaddingColumn.screen,
        //     child: AspectRatio(
        //       aspectRatio: hasData ? 1.3 : 2,
        //       child: hasData
        //           ? Row(
        //               children: <Widget>[
        //                 const SizedBox(height: 18),
        //                 Expanded(
        //                   child: AspectRatio(
        //                     aspectRatio: 1,
        //                     child: PieChart(
        //                       PieChartData(
        //                         pieTouchData: PieTouchData(
        //                           touchCallback:
        //                               (FlTouchEvent event, pieTouchResponse) {
        //                             setState(() {
        //                               if (!event.isInterestedForInteractions ||
        //                                   pieTouchResponse == null ||
        //                                   pieTouchResponse.touchedSection ==
        //                                       null) {
        //                                 touchedIndex = -1;
        //                                 return;
        //                               }
        //                               touchedIndex = pieTouchResponse
        //                                   .touchedSection!.touchedSectionIndex;
        //                             });
        //                           },
        //                         ),
        //                         borderData: FlBorderData(show: false),
        //                         sectionsSpace: 0,
        //                         centerSpaceRadius: 40,
        //                         sections: showingSections(summary),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 const SizedBox(width: 28),
        //               ],
        //             )
        //           : const Center(
        //               child: Text(
        //                 "No data available",
        //                 style: TextStyle(color: Colors.grey),
        //               ),
        //             ),
        //     ),
        //   )),
        // )
      ],
    );
  }

  List<PieChartSectionData> showingSections(List<dynamic> summary) {
    final total = summary.fold<num>(0, (sum, e) => sum + (e['value'] ?? 0));

    if (total == 0) return [];

    return List.generate(summary.length, (i) {
      final item = summary[i];
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final shadows = const [Shadow(color: Colors.black45, blurRadius: 2)];

      final value = item['value']?.toDouble() ?? 0;
      final percentage =
          total > 0 ? (value / total * 100).toStringAsFixed(1) : "0";

      return PieChartSectionData(
        color: Color(_hexToColor(item['color'] ?? '#cccccc')),
        value: value,
        title: "$percentage%",
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }

  int _hexToColor(String hex) {
    return int.parse(hex.replaceFirst('#', '0xff'));
  }
}
