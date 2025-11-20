import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dasboard_card.dart';
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
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: DasboardCard(
              child: Column(
            children: [
              Padding(
                padding: PaddingColumn.screen,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Alur Proses Produksi'),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < widget.process?.length; i++)
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
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
                                                      ? Icons
                                                          .content_paste_outlined
                                                      : i == 4
                                                          ? Icons.cut
                                                          : i == 5
                                                              ? Icons.cut
                                                              : i == 6
                                                                  ? Icons
                                                                      .link_outlined
                                                                  : i == 7
                                                                      ? Icons
                                                                          .color_lens_outlined
                                                                      : i == 8
                                                                          ? Icons
                                                                              .print_outlined
                                                                          : i == 9
                                                                              ? Icons.sort
                                                                              : i == 10
                                                                                  ? Icons.stacked_bar_chart_outlined
                                                                                  : Icons.dangerous,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  SizedBox(
                                      width: 80,
                                      child: Text(
                                        widget.process?[i]['name'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      )),
                                ].separatedBy(SizedBox(
                                  height: 8,
                                )),
                              ),
                              if (i != widget.process!.length - 1)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                          // SizedBox(
                          //     width: 80,
                          //     child: Text(
                          //       widget.process?[i]['name'],
                          //       maxLines: 2,
                          //       overflow: TextOverflow.ellipsis,
                          //       textAlign: TextAlign.center,
                          //     )),
                        ].separatedBy(SizedBox(
                          height: 8,
                        )),
                      ),
                  ],
                ),
              ),
            ].separatedBy(SizedBox(
              height: 16,
            )),
          )),
        ),
      ],
    );
  }
}
