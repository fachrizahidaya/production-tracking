import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
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
      this.label});

  @override
  Widget build(BuildContext context) {
    final titleLabel = getTitleLabel?.call(item) ??
        '${_capitalize(titleKey.replaceAll('_', ' '))}';
    final subtitleLabel = getSubtitleLabel?.call(item) ??
        '${_capitalize(subtitleKey.replaceAll('_', ' '))}';
    final status = getStatus?.call(item) ?? '-';

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
                  '${itemField(item, titleKey)}',
                  style: TextStyle(fontSize: 16),
                ),
                customBadgeBuilder?.call(status) ?? CustomBadge(title: status),
              ],
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
                  '${nestedField(item, subtitleKey, subtitleField)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    // Icon(
                    //   Icons.timelapse_outlined,
                    //   size: 14,
                    // ),
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
                    if (item.machine['name'] != null)
                      Row(
                        children: [
                          Icon(
                            Icons.local_laundry_service_outlined,
                            size: 14,
                          ),
                          Text(
                            '${item.machine['name']}',
                          ),
                        ].separatedBy(SizedBox(
                          width: 4,
                        )),
                      ),
                    if (item.maklon != null)
                      Row(
                        children: [
                          Icon(
                            Icons.business_outlined,
                            size: 14,
                          ),
                          Text(
                            '${item.maklon_name}',
                          ),
                        ].separatedBy(SizedBox(
                          width: 4,
                        )),
                      ),
                    if (item.maklon == null && item.machine['name'] == null)
                      Row(
                        children: [],
                      ),
                  ],
                ),
                Row(
                  children: [
                    // Icon(
                    //   Icons.playlist_add_check_outlined,
                    //   size: 14,
                    // ),
                    Text(
                      "Waktu Selesai: ${getEndTime?.call(item) ?? '-'}"
                      "${getEndBy?.call(item).isNotEmpty == true ? ", ${getEndBy!(item)}" : ""}",
                    ),
                  ],
                ),
              ].separatedBy(SizedBox(
                width: 4,
              )),
            ),
          ],
        ),
      ),
    );
  }

  dynamic itemField(dynamic item, String key) {
    if (item == null) return '-';
    try {
      return item.toJson()[key] ?? '-';
    } catch (_) {
      try {
        return item[key] ?? '-';
      } catch (_) {
        return '-';
      }
    }
  }

  dynamic nestedField(dynamic item, String key, String subKey) {
    try {
      final nested = itemField(item, key);
      if (nested is Map && nested[subKey] != null) return nested[subKey];
      return '-';
    } catch (_) {
      return '-';
    }
  }

  String _capitalize(String text) =>
      text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : text;
}
