import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/custom_badge.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ItemProcessCard extends StatelessWidget {
  final dynamic item;
  final String titleKey;
  final String subtitleKey;
  final String subtitleField;
  final bool Function(dynamic item)? isRework;
  final String Function(dynamic item)? getStatus;
  final String Function(dynamic item)? getStartTime;
  final String Function(dynamic item)? getEndTime;
  final String Function(dynamic item)? getStartBy;
  final String Function(dynamic item)? getEndBy;
  final String? Function(dynamic item)? getTitleLabel;
  final String? Function(dynamic item)? getSubtitleLabel;
  final Widget Function(String title)? customBadgeBuilder;
  final label;
  final useCustomSize;
  final customWidth;
  final customHeight;
  final itemField;
  final nestedField;

  const ItemProcessCard(
      {super.key,
      required this.item,
      required this.titleKey,
      required this.subtitleKey,
      required this.subtitleField,
      this.isRework,
      this.getStatus,
      this.getStartTime,
      this.getEndTime,
      this.getStartBy,
      this.getEndBy,
      this.getTitleLabel,
      this.getSubtitleLabel,
      this.customBadgeBuilder,
      this.label,
      this.customHeight,
      this.customWidth,
      this.useCustomSize,
      this.itemField,
      this.nestedField});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        useCustomSize: useCustomSize,
        customWidth: customWidth,
        customHeight: customHeight,
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
                      "Waktu Dibuat: ${getStartTime?.call(item) ?? '-'}"
                      "${getStartBy?.call(item).isNotEmpty == true ? ", ${getStartBy!(item)}" : ""}",
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
                      "Waktu Selesai: ${getEndTime?.call(item) ?? '-'}"
                      "${getEndBy?.call(item).isNotEmpty == true ? ", ${getEndBy!(item)}" : ""}",
                    ),
                  ],
                ),
              ].separatedBy(CustomTheme().hGap('lg')),
            ),
          ],
        ));
  }
}
