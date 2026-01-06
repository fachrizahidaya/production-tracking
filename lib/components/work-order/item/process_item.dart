import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/layout/card/custom_badge.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/master/theme.dart';
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
    final List data = widget.item['data'] ?? [];
    final bool hasData = data.isNotEmpty;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.item['label'] ?? '-',
                style: TextStyle(fontSize: CustomTheme().fontSize('lg')),
              ),
              CustomBadge(
                title: hasData
                    ? data.first['status'] ?? 'Menunggu Diproses'
                    : 'Menunggu Diproses',
                rework: true,
                status: hasData
                    ? data.first['status'] ?? 'Menunggu Diproses'
                    : 'Menunggu Diproses',
              ),
            ],
          ),
          if (hasData && data.first['start_time'] != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ViewText(
                  viewLabel: 'Waktu Mulai',
                  viewValue: data.first['start_time'],
                ),
                ViewText(
                  viewLabel: 'Waktu Selesai',
                  viewValue: data.first['end_time'],
                ),
                ViewText(
                  viewLabel: 'Qty',
                  viewValue: data.first['qty'],
                ),
              ].separatedBy(CustomTheme().vGap('md')),
            ),
        ].separatedBy(CustomTheme().vGap('lg')),
      ),
    );
  }
}
