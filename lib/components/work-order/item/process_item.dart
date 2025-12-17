import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ProcessItem extends StatefulWidget {
  final item;

  const ProcessItem({super.key, this.item});

  @override
  State<ProcessItem> createState() => _ProcessItemState();
}

class _ProcessItemState extends State<ProcessItem> {
  @override
  Widget build(BuildContext context) {
    final processName = widget.item['process'];
    final data = widget.item['data'];

    return CustomCard(
      child: Padding(
          padding: PaddingColumn.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                processName,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              ViewText(
                viewLabel: 'Waktu Mulai',
                viewValue: data['start_time'],
              ),
              if (data['end_time'] != null)
                ViewText(
                  viewLabel: 'Waktu Selesai',
                  viewValue: data['end_time'],
                ),
              if (data['end_time'] != null)
                ViewText(
                  viewLabel: 'Qty',
                  viewValue: data['qty'],
                ),
            ].separatedBy(SizedBox(
              height: 8,
            )),
          )),
    );
  }
}
