import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ListItem extends StatelessWidget {
  final item;
  final handleSpk;

  const ListItem({super.key, required this.item, this.handleSpk});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomBadge(
                    title: item['item_code']?.toString() ?? '-',
                    rework: true,
                    status: 'Menunggu Diproses',
                  ),
                  Text(
                    item['item_name']?.toString() ?? '-',
                    style: TextStyle(
                      fontSize: CustomTheme().fontSize('lg'),
                    ),
                  ),
                ].separatedBy(CustomTheme().vGap('sm')),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: CustomTheme().iconSize('xl'),
                      ),
                      Text(
                        '${item['qty']} ${item['unit']['code']}',
                        style: TextStyle(
                            fontSize: CustomTheme().fontSize('2xl'),
                            fontWeight: CustomTheme().fontWeight('bold')),
                      )
                    ].separatedBy(CustomTheme().hGap('lg')),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.format_line_spacing_outlined,
                      ),
                      Text(
                        item?['variants'][3]['value'] ?? '-',
                      ),
                    ].separatedBy(CustomTheme().hGap('lg')),
                  ),
                ],
              ),
            ]),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Icons.design_services_outlined,
                ),
                Text(
                  item?['variants'][0]['value'] ?? '-',
                ),
              ].separatedBy(CustomTheme().hGap('lg')),
            ),
            Row(
              children: [
                Icon(
                  Icons.color_lens_outlined,
                ),
                Text(
                  item?['variants'][2]['value'] ?? '-',
                )
              ].separatedBy(CustomTheme().hGap('lg')),
            ),
          ],
        ),
      ],
    ));
  }
}
