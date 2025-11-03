import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/dasboard_card.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WorkOrderChart extends StatefulWidget {
  final List<dynamic> data;
  const WorkOrderChart({super.key, required this.data});

  @override
  State<WorkOrderChart> createState() => _WorkOrderChartState();
}

class _WorkOrderChartState extends State<WorkOrderChart> {
  final double width = 14;
  List<BarChartGroupData> barGroups = [];
  double maxY = 0;
  int? touchedIndex;

  @override
  void initState() {
    super.initState();
    _generateChartData();
  }

  void _generateChartData() {
    barGroups.clear();
    double localMax = 0;

    for (int i = 0; i < widget.data.length; i++) {
      final item = widget.data[i];
      final completed = (item['completed'] ?? 0).toDouble();
      final inProgress = (item['inProgress'] ?? 0).toDouble();

      final processMax = completed > inProgress ? completed : inProgress;
      if (processMax > localMax) localMax = processMax;

      barGroups.add(makeGroupData(i, completed, inProgress));
    }

    maxY = localMax == 0 ? 1 : localMax + (localMax * 0.2);
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    final bool isTouched = x == touchedIndex;

    return BarChartGroupData(
      x: x,
      barsSpace: 6,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: isTouched
              ? const Color(0xFF34D399)
              : const Color(0xFF10B981), // highlight when touched
          width: width,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: y2,
          color: isTouched
              ? const Color(0xFFFFB84D)
              : const Color(0xfff18800), // highlight when touched
          width: width,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    if (value.toInt() < 0 || value.toInt() >= widget.data.length) {
      return const SizedBox.shrink();
    }

    final name = widget.data[value.toInt()]['name'] ?? '';
    final bool isTouched = value.toInt() == touchedIndex;

    return SideTitleWidget(
      meta: meta,
      space: 8,
      child: SizedBox(
        width: 60,
        child: Text(
          name,
          style: TextStyle(
            color: isTouched ? Colors.white : const Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool allZero = widget.data.every((item) {
      final completed = (item['completed'] ?? 0).toDouble();
      final inProgress = (item['inProgress'] ?? 0).toDouble();
      return completed == 0 && inProgress == 0;
    });

    final double chartRatio = allZero ? 3 : 2;

    return DasboardCard(
        child: Padding(
      padding: PaddingColumn.screen,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Text('Status Setiap Proses'),
              ),
              SizedBox(
                width: 400,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GroupForm(
                        label: 'Dari Tanggal',
                        formControl: TextFormField(
                          // controller: dariTanggalInput,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          decoration: CustomTheme().inputDateDecoration(
                              clearable:
                                  // dariTanggalInput.text != '' ? true :
                                  false,
                              onPressClear: () => {
                                    setState(() {
                                      // widget.onHandleFilter('dari_tanggal', '');
                                      // dariTanggalInput.text = '';
                                    })
                                  },
                              hintTextString: 'Pilih tanggal'),
                          keyboardType: TextInputType.datetime,
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2101),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: CustomTheme().colors('base'),
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black87,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              setState(() {
                                // dariTanggalInput.text = formattedDate;
                                // widget.onHandleFilter(
                                //     'dari_tanggal', formattedDate);
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GroupForm(
                        label: 'Sampai Tanggal',
                        formControl: TextFormField(
                          // controller: sampaiTanggalInput,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          decoration: CustomTheme().inputDateDecoration(
                              clearable:
                                  // sampaiTanggalInput.text != '' ? true :
                                  false,
                              onPressClear: () => {
                                    setState(() {
                                      // widget.onHandleFilter(
                                      //     'sampai_tanggal', '');
                                      // sampaiTanggalInput.text = '';
                                    })
                                  },
                              hintTextString: 'Pilih tanggal'),
                          keyboardType: TextInputType.datetime,
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2101),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: CustomTheme().colors('base'),
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black87,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              setState(() {
                                // sampaiTanggalInput.text = formattedDate;
                                // widget.onHandleFilter(
                                //     'sampai_tanggal', formattedDate);
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ].separatedBy(SizedBox(
                    width: 16,
                  )),
                ),
              ),
            ],
          ),
          AspectRatio(
            aspectRatio: chartRatio,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                barGroups: barGroups,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (FlTouchEvent event, response) {
                    if (!event.isInterestedForInteractions ||
                        response == null ||
                        response.spot == null) {
                      setState(() => touchedIndex = null);
                      return;
                    }
                    setState(() {
                      touchedIndex = response.spot!.touchedBarGroupIndex;
                    });
                  },
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: false,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) {
                    if (value == 0 || value == maxY) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      );
                    }
                    return FlLine(
                      color: Colors.transparent,
                      strokeWidth: 0,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: bottomTitles,
                      reservedSize: 50,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(const Color(0xFF10B981), 'Selesai'),
              const SizedBox(width: 16),
              _buildLegendItem(const Color(0xfff18800), 'Diproses'),
            ],
          ),
        ].separatedBy(SizedBox(
          height: 16,
        )),
      ),
    ));
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xff7589a2),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
