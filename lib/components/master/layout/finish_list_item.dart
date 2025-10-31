import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class FinishListItem extends StatelessWidget {
  final item;
  final handleSpk;

  const FinishListItem({super.key, required this.item, this.handleSpk});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        withBorder: true,
        child: Padding(
            padding: PaddingColumn.screen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ViewText(
                          viewLabel: 'SKU',
                          viewValue: item['spk_item']?['item']['sku'] ?? '-'),
                      ViewText(
                          viewLabel: 'Nama',
                          viewValue: item['spk_item']?['item']['name'] ?? '-'),
                      ViewText(
                          viewLabel: 'SPK',
                          viewValue: item['spk_item']?['spk']['spk_no'] ?? '-'),
                    ].separatedBy(SizedBox(
                      height: 8,
                    ))),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ViewText(
                          viewLabel: 'Name',
                          viewValue: item['spk_item']?['design'] ?? '-'),
                      ViewText(
                          viewLabel: 'Warna',
                          viewValue: item['spk_item']?['color'] ?? '-'),
                      ViewText(
                          viewLabel: 'Jumlah',
                          viewValue: '${item['qty']} ${item['unit']['code']}'),
                    ].separatedBy(SizedBox(
                      height: 8,
                    )))
              ],
            )));
  }
}
