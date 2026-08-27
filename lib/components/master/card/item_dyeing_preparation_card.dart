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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isTablet),
                  const Divider(),
                ],
              ),
              _buildInformation(isTablet),
            ].separatedBy(CustomTheme().vGap('lg')),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['prep_no'] ?? '-',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize(isTablet ? 'lg' : 'md'),
                  fontWeight: CustomTheme().fontWeight('bold'),
                ),
              ),
              Text(
                item['wo_no'] ?? '-',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: CustomTheme().fontSize(isTablet ? 'xl' : 'lg'),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ].separatedBy(CustomTheme().vGap('sm')),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item['status'] != null)
              CustomBadge(
                title: _getStatusLabel(item['status']),
                status: item['status'],
                withStatus: true,
              ),
          ].separatedBy(CustomTheme().hGap('md')),
        ),
      ].separatedBy(CustomTheme().hGap('xl')),
    );
  }

  Widget _buildInformation(bool isTablet) {
    final children = [
      _buildInfoSection(
        isTablet,
        icon: Icons.calendar_today_outlined,
        title: 'Tanggal Persiapan',
        value: formatDateSafe(item['prep_date']),
      ),
      _buildInfoSection(
        isTablet,
        icon: Icons.person_outline,
        title: 'Dibuat Oleh',
        value: _getUserName(item['start_by']),
      ),
    ];

    return Row(
      children: children
          .map(
            (child) => Expanded(
              child: Container(
                padding: CustomTheme().padding('card'),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: child,
              ),
            ),
          )
          .toList()
          .separatedBy(CustomTheme().hGap('xl')),
    );
  }

  Widget _buildInfoSection(
    bool isTablet, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return isTablet
        ? Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  isTablet,
                  icon,
                  title,
                  value,
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                isTablet,
                icon,
                title,
                value,
              ),
            ],
          );
  }

  Widget _buildInfoRow(
    bool isTablet,
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: CustomTheme().padding('process-content'),
          decoration: BoxDecoration(
            color: CustomTheme().buttonColor('primary').withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: isTablet ? 20 : 18,
            color: CustomTheme().buttonColor('primary'),
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: CustomTheme().fontSize(isTablet ? 12 : 10),
                  fontWeight: CustomTheme().fontWeight('semibold'),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: CustomTheme().fontWeight('semibold'),
                  fontSize: CustomTheme().fontSize('md'),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ].separatedBy(CustomTheme().vGap('sm')),
          ),
        ),
      ].separatedBy(CustomTheme().hGap('xl')),
    );
  }

  String _getUserName(dynamic user) {
    if (user is Map) {
      return user['name']?.toString() ?? '-';
    }

    return user?.toString() ?? '-';
  }

  String _getStatusLabel(String? status) {
    switch (status) {
      case 'Diproses':
        return 'Diproses';
      case 'Selesai':
        return 'Selesai';
      case 'Rework':
        return 'Rework';
      default:
        return status ?? '-';
    }
  }
}
