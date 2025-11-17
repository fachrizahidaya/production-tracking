import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class FinishListItem extends StatelessWidget {
  final item;
  final handleSpk;

  const FinishListItem({super.key, required this.item, this.handleSpk});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return CustomCard(
        child: Padding(
            padding: PaddingColumn.screen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      if (!isMobile)
                        CustomBadge(
                            title:
                                item['spk_item']['item']['sku']?.toString() ??
                                    '-'),
                    ]),
                if (isMobile)
                  Text(
                    item['spk_item']['item']['sku']?.toString() ?? '-',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
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
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                      Row(
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 14,
                          ),
                          Text(
                            '${item['qty']} ${item['unit']['code']}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ].separatedBy(SizedBox(
                          width: 4,
                        )),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.colorize_outlined,
                            size: 14,
                          ),
                          Text(
                            item['spk_item']?['color'] ?? '-',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ].separatedBy(SizedBox(
                          width: 4,
                        )),
                      ),
                    ]),
              ],
            )));
  }
}
