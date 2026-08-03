// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_date_safe.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ItemDyeingPreparationCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemDyeingPreparationCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Divider(),
          _buildInformation(),
        ].separatedBy(CustomTheme().vGap('lg')),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['prep_no'] ?? '-',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('lg'),
                  fontWeight: CustomTheme().fontWeight('bold'),
                ),
              ),
              Text(
                item['wo_no'] ?? '-',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: CustomTheme().fontSize('md'),
                ),
              ),
            ].separatedBy(CustomTheme().vGap('sm')),
          ),
        ),
        CustomBadge(
          title: item['status'] ?? '-',
          status: item['status'],
          withStatus: true,
        ),
      ],
    );
  }

  Widget _buildInformation() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoRow(
            Icons.calendar_today_outlined,
            "Tanggal Persiapan",
            formatDateSafe(item['prep_date']),
          ),
        ),
        Expanded(
          child: _buildInfoRow(
            Icons.person_outline,
            "Dibuat Oleh",
            item['start_by'] ?? "-",
          ),
        ),
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      children: [
        Container(
          padding: CustomTheme().padding('process-content'),
          decoration: BoxDecoration(
            color: CustomTheme().buttonColor('primary').withOpacity(.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 18,
            color: CustomTheme().buttonColor('primary'),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: CustomTheme().fontSize('sm'),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: CustomTheme().fontWeight('semibold'),
                  fontSize: CustomTheme().fontSize('md'),
                ),
              ),
            ].separatedBy(CustomTheme().vGap('sm')),
          ),
        ),
      ].separatedBy(CustomTheme().hGap('xl')),
    );
  }
}
