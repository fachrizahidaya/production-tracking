import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_date_safe.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ItemProcessCard extends StatelessWidget {
  final dynamic item;
  final String titleKey;
  final String subtitleKey;
  final String subtitleField;
  final label;
  final itemField;
  final nestedField;

  const ItemProcessCard(
      {super.key,
      required this.item,
      required this.titleKey,
      required this.subtitleKey,
      required this.subtitleField,
      this.label,
      this.itemField,
      this.nestedField});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${itemField(item, titleKey)}',
                  style: TextStyle(fontSize: CustomTheme().fontSize('lg')),
                ),
                if (item['rework'] == true)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomBadge(
                        withStatus: true,
                        status: 'Rework',
                        title: 'Rework',
                        rework: true,
                      ),
                      CustomBadge(
                        status: 'Menunggu Diproses',
                        title: item['rework_reference']['dyeing_no'],
                        rework: true,
                      )
                    ].separatedBy(CustomTheme().hGap('md')),
                  ),
              ].separatedBy(CustomTheme().vGap('lg')),
            ),
            CustomBadge(
                withStatus: true,
                status: item['status'],
                title: item['status']!),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${nestedField(item, subtitleKey, subtitleField)}',
              style: TextStyle(
                  fontSize: CustomTheme().fontSize('xl'),
                  fontWeight: CustomTheme().fontWeight('bold')),
            ),
            Row(
              children: [
                Text(
                  'Waktu Dibuat: ${item['start_time'] != null ? formatDateSafe(item['start_time']) : '-'}'
                  '${item['start_by']?['name'].isNotEmpty == true ? ", ${item['start_by']?['name']}" : ""}',
                ),
              ],
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['machine'] != null)
                  Row(
                    children: [
                      Icon(
                        Icons.local_laundry_service_outlined,
                        size: 14,
                      ),
                      Text(
                        '${item['machine']['name']}',
                      ),
                    ].separatedBy(CustomTheme().hGap('lg')),
                  ),
                if (item['maklon'] == true)
                  Row(
                    children: [
                      Icon(
                        Icons.business_outlined,
                        size: 14,
                      ),
                      Text(
                        '${item['maklon_name']}',
                      ),
                    ].separatedBy(CustomTheme().hGap('lg')),
                  ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Waktu Selesai: ${item['end_time'] != null ? formatDateSafe(item['end_time']) : '-'}'
                  "${item['end_by']?['name'].isNotEmpty == true ? ", ${item['end_by']?['name']}" : ""}",
                ),
              ],
            ),
          ].separatedBy(CustomTheme().hGap('lg')),
        ),
      ],
    ));
  }
}
