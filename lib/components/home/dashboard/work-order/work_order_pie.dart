import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
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

  static const List<IconData> processIcons = [
    Icons.invert_colors_on_outlined,
    Icons.content_copy_rounded,
    Icons.air,
    Icons.content_paste_outlined,
    Icons.cut,
    Icons.cut,
    Icons.link_outlined,
    Icons.color_lens_outlined,
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

    return Row(
      children: [
        Expanded(
          child: CustomCard(
            child: Column(
              children: [
                Padding(
                  padding: PaddingColumn.screen,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Alur Proses Produksi'),
                    ],
                  ),
                ),
                if (isEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: const Center(child: NoData()),
                  )
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: PaddingColumn.screen,
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
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 24),
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ].separatedBy(const SizedBox(height: 16)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessItem({required int index, required String name}) {
    return Column(
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff3b82f6),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: MarginCard.screen,
              child: Icon(
                getIcon(index),
                color: Colors.white,
                size: 32,
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
          ].separatedBy(const SizedBox(height: 8)),
        ),
      ],
    );
  }
}
