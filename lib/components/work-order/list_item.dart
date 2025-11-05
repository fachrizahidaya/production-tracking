import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ListItem extends StatelessWidget {
  final item;
  final handleSpk;

  const ListItem({super.key, required this.item, this.handleSpk});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        child: Padding(
            padding: PaddingColumn.screen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Material',
                        style: TextStyle(),
                      ),
                      CustomBadge(
                          title: item['spk_item']['item']['sku']?.toString() ??
                              '-'),
                      Text(
                        item['spk_item']['item']['name']?.toString() ?? '-',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ViewText(
                          viewLabel: 'Desain',
                          viewValue: item['spk_item']?['design'] ?? '-'),
                    ].separatedBy(SizedBox(
                      height: 8,
                    ))),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ViewText(
                          viewLabel: 'SPK',
                          viewValue: item['spk_item']?['spk']['spk_no'] ?? '-'),
                      ViewText(
                          viewLabel: 'Warna',
                          viewValue: item['spk_item']?['color'] ?? '-'),
                      ViewText(
                          viewLabel: 'Qty',
                          viewValue: '${item['qty']} ${item['unit']['code']}'),
                    ].separatedBy(SizedBox(
                      height: 8,
                    )))
              ],
            )));
  }
}
