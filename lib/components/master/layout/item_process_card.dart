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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$label: ${itemField(item, titleKey)}'),
                Text(
                    'No. WO: ${nestedField(item, subtitleKey, subtitleField)}'),
              ].separatedBy(const SizedBox(height: 8)),
            ),

            // Middle column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dibuat: ${getStartTime?.call(item) ?? '-'}"
                  "${getStartBy?.call(item).isNotEmpty == true ? " by ${getStartBy!(item)}" : ""}",
                ),
                Text(
                  "Selesai: ${getEndTime?.call(item) ?? '-'}"
                  "${getEndBy?.call(item).isNotEmpty == true ? " by ${getEndBy!(item)}" : ""}",
                ),
              ].separatedBy(const SizedBox(height: 8)),
            ),

            // Right badge
            customBadgeBuilder?.call(status) ?? CustomBadge(title: status),
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
