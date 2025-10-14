import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/helpers/util/format_date_safe.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/process/dyeing.dart';

class ItemDyeing extends StatelessWidget {
  final Dyeing item;

  const ItemDyeing({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        child: Padding(
            padding: PaddingColumn.screen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dyeing No: ${item.dyeing_no!}',
                    ),
                    Text(
                      'WO No: ${item.work_orders['wo_no']}',
                    ),
                    if (item.rework == true)
                      Row(
                        children: [
                          Icon(
                            Icons.replay_outlined,
                            size: 16,
                          ),
                          Text(
                            'Rework',
                          ),
                        ],
                      )
                  ].separatedBy(SizedBox(
                    height: 8,
                  )),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dibuat: ${formatDateSafe(item.start_time)}"
                      "${item.start_by != null && item.start_by['name'] != null ? " by ${item.start_by['name']}" : ""}",
                    ),
                    Text(
                      "Selesai: ${formatDateSafe(item.end_time)}"
                      "${item.end_by != null && item.end_by['name'] != null ? " by ${item.end_by['name']}" : ""}",
                    ),
                  ].separatedBy(SizedBox(
                    height: 8,
                  )),
                ),
                CustomBadge(title: item.status!)
              ],
            )));
  }
}
