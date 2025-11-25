import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dasboard_card.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/helpers/util/margin_card.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WorkOrderStats extends StatefulWidget {
  final data;

  const WorkOrderStats({super.key, this.data});

  @override
  State<WorkOrderStats> createState() => _WorkOrderStatsState();
}

class _WorkOrderStatsState extends State<WorkOrderStats> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return !isMobile
        ? Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < widget.data?.length && i < 2; i++)
                    Expanded(
                      flex: 1,
                      child: DasboardCard(
                          withBottomBorder: true,
                          bottomBorderColor: i == 0
                              ? Color(0xff3b82f6)
                              : i == 1
                                  ? Color(0xFF10b981)
                                  : i == 2
                                      ? Color(0xfff18800)
                                      : Color(0xFF94a3b8),
                          child: Padding(
                            padding: PaddingColumn.screen,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: i == 0
                                              ? Color(0xff3b82f6)
                                              : i == 1
                                                  ? Color(0xFF10b981)
                                                  : i == 2
                                                      ? Color(0xfff18800)
                                                      : Color(0xFF94a3b8),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      padding: MarginCard.screen,
                                      child: Icon(
                                        i == 0
                                            ? Icons.work_outline
                                            : i == 1
                                                ? Icons.task_alt_outlined
                                                : i == 2
                                                    ? Icons.access_time_outlined
                                                    : Icons.error_outline,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    Text(
                                      widget.data[i]['value'].toString(),
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ].separatedBy(SizedBox(
                                    width: 8,
                                  )),
                                ),
                                CustomBadge(
                                  title: widget.data[i]['label'],
                                  withDifferentColor: true,
                                  color: i == 0
                                      ? Color(0xffdbeaff)
                                      : i == 1
                                          ? Color(0xffd1fae4)
                                          : i == 2
                                              ? Color(0xFFfff3c6)
                                              : Color(0xFFf1f5f9),
                                )
                              ],
                            ),
                          )),
                    ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 2; i < widget.data?.length; i++)
                    Expanded(
                      flex: 1,
                      child: DasboardCard(
                          withBottomBorder: true,
                          bottomBorderColor: i == 0
                              ? Color(0xff3b82f6)
                              : i == 1
                                  ? Color(0xFF10b981)
                                  : i == 2
                                      ? Color(0xfff18800)
                                      : Color(0xFF94a3b8),
                          child: Padding(
                            padding: PaddingColumn.screen,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: i == 0
                                              ? Color(0xff3b82f6)
                                              : i == 1
                                                  ? Color(0xFF10b981)
                                                  : i == 2
                                                      ? Color(0xfff18800)
                                                      : Color(0xFF94a3b8),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      padding: MarginCard.screen,
                                      child: Icon(
                                        i == 0
                                            ? Icons.work_outline
                                            : i == 1
                                                ? Icons.task_alt_outlined
                                                : i == 2
                                                    ? Icons.access_time_outlined
                                                    : Icons.error_outline,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    Text(
                                      widget.data[i]['value'].toString(),
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ].separatedBy(SizedBox(
                                    width: 8,
                                  )),
                                ),
                                CustomBadge(
                                  title: widget.data[i]['label'],
                                  withDifferentColor: true,
                                  color: i == 0
                                      ? Color(0xffdbeaff)
                                      : i == 1
                                          ? Color(0xffd1fae4)
                                          : i == 2
                                              ? Color(0xFFfff3c6)
                                              : Color(0xFFf1f5f9),
                                )
                              ],
                            ),
                          )),
                    ),
                ],
              ),
            ],
          )
        : Column(
            children: [
              for (int i = 0; i < widget.data?.length; i++)
                DasboardCard(
                    withBottomBorder: true,
                    bottomBorderColor: i == 0
                        ? Color(0xff3b82f6)
                        : i == 1
                            ? Color(0xFF10b981)
                            : i == 2
                                ? Color(0xfff18800)
                                : Color(0xFF94a3b8),
                    child: Padding(
                      padding: PaddingColumn.screen,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: i == 0
                                        ? Color(0xff3b82f6)
                                        : i == 1
                                            ? Color(0xfff18800)
                                            : i == 2
                                                ? Color(0xFF10b981)
                                                : Color(0xFF94a3b8),
                                    borderRadius: BorderRadius.circular(4)),
                                padding: MarginCard.screen,
                                child: Icon(
                                  i == 0
                                      ? Icons.work_outline
                                      : i == 1
                                          ? Icons.task_alt_outlined
                                          : i == 2
                                              ? Icons.access_time_outlined
                                              : Icons.error_outline,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              Text(
                                widget.data[i]['value'].toString(),
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          ),
                          CustomBadge(
                            title: widget.data[i]['label'],
                            withDifferentColor: true,
                            color: i == 0
                                ? Color(0xffdbeaff)
                                : i == 1
                                    ? Color(0xffd1fae4)
                                    : i == 2
                                        ? Color(0xFFfff3c6)
                                        : Color(0xFFf1f5f9),
                          )
                        ],
                      ),
                    ))
            ],
          );
  }
}
