import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/process/dyeing.dart';

class ItemDyeing extends StatelessWidget {
  final Dyeing item;
  final List<OptionUnit> unitOptions;

  const ItemDyeing({super.key, required this.item, required this.unitOptions});

  String _getUnitLabel(int unitId) {
    final match = unitOptions.firstWhere(
      (opt) => opt.value == unitId,
      orElse: () => OptionUnit(value: -1, label: ''),
    );
    return match.label ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final unitLabel = _getUnitLabel(item.unit_id!);

    return CustomCard(
        child: Padding(
            padding: PaddingColumn.screen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    item.dyeing_no!,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${NumberFormat("#,###").format(int.parse(
                      item.qty!,
                    ))} $unitLabel',
                  ),
                ),
                Expanded(
                  child: Text(
                    DateFormat("dd MMM yyyy HH:mm").format(DateTime.parse(
                      item.start_time!,
                    )),
                  ),
                ),
                CustomBadge(title: item.status!)
              ],
            )));
  }
}
