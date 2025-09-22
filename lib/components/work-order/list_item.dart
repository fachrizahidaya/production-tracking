import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/layout/custom_card.dart';
import 'package:production_tracking/components/master/text/view_text.dart';
import 'package:production_tracking/helpers/util/padding_column.dart';
import 'package:production_tracking/helpers/util/separated_column.dart';

class ListItem extends StatelessWidget {
  final item;
  final handleSpk;

  const ListItem({super.key, required this.item, this.handleSpk});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        child: Padding(
            padding: PaddingColumn.screen,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    handleSpk(item['spk_item']?['spk_id']),
                  ),
                  ViewText(
                      viewLabel: 'Name',
                      viewValue: item['spk_item']?['design']),
                  ViewText(
                      viewLabel: 'Warna',
                      viewValue: item['spk_item']?['color']),
                ].separatedBy(SizedBox(
                  height: 8,
                )))));
  }
}
