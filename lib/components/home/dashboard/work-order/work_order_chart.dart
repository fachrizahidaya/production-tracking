// ignore_for_file: prefer_typing_uninitialized_variables, deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WorkOrderChart extends StatefulWidget {
  final List<dynamic> data;
  final onHandleFilter;
  final dariTanggal;
  final sampaiTanggal;
  final filterWidget;
  final handleRefetch;
  final isFetching;

  const WorkOrderChart(
      {super.key,
      required this.data,
      this.onHandleFilter,
      this.dariTanggal,
      this.sampaiTanggal,
      this.filterWidget,
      this.handleRefetch,
      this.isFetching});

  @override
  State<WorkOrderChart> createState() => _WorkOrderChartState();
}

class _WorkOrderChartState extends State<WorkOrderChart> {
  final double width = 22;
  List<BarChartGroupData> barGroups = [];
  double maxY = 0;
  int? touchedIndex;

  final TextEditingController dariTanggalInput = TextEditingController();
  final TextEditingController sampaiTanggalInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateChartData();

    dariTanggalInput.text = widget.dariTanggal;
    sampaiTanggalInput.text = widget.sampaiTanggal;
  }

  @override
  void didUpdateWidget(covariant WorkOrderChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dariTanggal != dariTanggalInput.text) {
      dariTanggalInput.text = widget.dariTanggal;
    }
    if (widget.sampaiTanggal != sampaiTanggalInput.text) {
      sampaiTanggalInput.text = widget.sampaiTanggal;
    }
  }

  @override
  void dispose() {
    dariTanggalInput.dispose();
    sampaiTanggalInput.dispose();
    super.dispose();
  }

  void _generateChartData() {
    barGroups.clear();
    double localMax = 0;

    for (int i = 0; i < widget.data.length; i++) {
      final item = widget.data[i];
      final completed = (item['completed'] ?? 0).toDouble();
      final inProgress = (item['inProgress'] ?? 0).toDouble();
      final awaitingProgress = (item['waiting'] ?? 0).toDouble();

      final processMax = completed > inProgress
          ? completed
          : inProgress > awaitingProgress
              ? inProgress
              : awaitingProgress;
      if (processMax > localMax) localMax = processMax;

      barGroups.add(makeGroupData(i, completed, inProgress, awaitingProgress));
    }

    maxY = localMax == 0 ? 1 : localMax + (localMax * 0.2);
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3) {
    return BarChartGroupData(
      x: x,
      barsSpace: 6,
      barRods: [
        BarChartRodData(
          toY: y2,
          color: const Color(0xfff18800),
          width: width,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: y3,
          color: const Color(0xFF94a3b8),
          width: width,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: y1,
          color: const Color(0xFF10B981),
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

    final double groupWidth = (width * 2) + (6 * 2);

    return SideTitleWidget(
      meta: meta,
      space: 8,
      child: SizedBox(
        width: groupWidth,
        child: SizedBox(
          width: groupWidth,
          child: Text(
            name,
            style: const TextStyle(
              color: Color(0xff7589a2),
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            softWrap: true,
          ),
        ),
      ),
    );
  }

  void _openFilter() {
    if (widget.filterWidget != null) {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        enableDrag: true,
        isDismissible: true,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return widget.filterWidget!;
        },
      );
    }
  }

  Widget _buildDateFilterRow() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: IconButton(
        icon: Stack(
          children: [
            const Icon(
              Icons.tune,
            ),
          ],
        ),
        onPressed: () {
          _openFilter();
        },
      ),
    );
  }

  Widget _buildRefetchRow() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: IconButton(
        icon: Stack(
          children: [
            const Icon(
              Icons.refresh_outlined,
            ),
          ],
        ),
        onPressed: () {
          widget.handleRefetch();
        },
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

    return CustomCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: PaddingColumn.screen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status Setiap Proses',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Tracking progres setiap tahap Work Order',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildRefetchRow(),
                    _buildDateFilterRow(),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          Column(
            children: [
              AspectRatio(
                aspectRatio: chartRatio,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: widget.isFetching
                      ? Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : BarChart(
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
                                  touchedIndex =
                                      response.spot!.touchedBarGroupIndex;
                                });
                              },
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawHorizontalLine: false,
                              drawVerticalLine: false,
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
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(
                                        color: Color(0xff7589a2),
                                        fontSize: 12,
                                      ),
                                    );
                                  },
                                ),
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
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem(const Color(0xfff18800), 'Diproses'),
                    _buildLegendItem(
                        const Color(0xFF94a3b8), 'Menunggu Diproses'),
                    _buildLegendItem(const Color(0xFF10B981), 'Selesai'),
                  ].separatedBy(SizedBox(
                    width: 16,
                  )),
                ),
              ),
            ].separatedBy(SizedBox(
              height: 16,
            )),
          ),
        ].separatedBy(const SizedBox(height: 16)),
      ),
    );
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
        Text(
          text,
          style: const TextStyle(
            color: Color(0xff7589a2),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ].separatedBy(SizedBox(
        width: 8,
      )),
    );
  }
}
