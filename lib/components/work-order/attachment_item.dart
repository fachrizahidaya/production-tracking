import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/layout/custom_card.dart';
import 'package:production_tracking/helpers/util/padding_column.dart';
import 'package:production_tracking/helpers/util/separated_column.dart';

class AttachmentItem extends StatelessWidget {
  final item;

  const AttachmentItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        child: Padding(
            padding: PaddingColumn.screen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.attachment),
                Expanded(
                  flex: 1,
                  child: Text(
                    item['file_name']!,
                  ),
                ),
              ].separatedBy(SizedBox(
                width: 16,
              )),
            )));
  }
}
