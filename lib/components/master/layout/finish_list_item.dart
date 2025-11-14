import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
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
        child: Padding(
            padding: PaddingColumn.screen,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        item['spk_item']?['item']['name'] ?? '-',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      CustomBadge(
                          title: item['spk_item']['item']['sku']?.toString() ??
                              '-'),
                    ]),
                Divider(),
                const SizedBox(
                  height: 8,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        item['spk_item']?['spk']['spk_no'] ?? '-',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        item['spk_item']?['design'] ?? '-',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${item['qty']} ${item['unit']['code']}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        item['spk_item']?['color'] ?? '-',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ]),
              ],
            )));
  }
}
