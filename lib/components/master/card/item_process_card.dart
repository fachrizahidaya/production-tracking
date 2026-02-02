// ignore_for_file: deprecated_member_use

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
  final dynamic label;
  final dynamic itemField;
  final dynamic nestedField;

  const ItemProcessCard({
    super.key,
    required this.item,
    required this.titleKey,
    required this.subtitleKey,
    required this.subtitleField,
    this.label,
    this.itemField,
    this.nestedField,
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
              // Header Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isTablet),
                  const Divider(),
                ],
              ),

              // Machine & Maklon Section

              Row(
                children: [
                  if (item['machine'] != null)
                    _buildMachineAndMaklonSection(isTablet),
                  if (item['maklon_name'] != null)
                    _buildMaklonSection(isTablet),
                  if (item['start_time'] != null)
                    _buildStartTimeSection(isTablet),
                  if (item['end_time'] != null) _buildEndTimeSection(isTablet)
                ].separatedBy(CustomTheme().hGap('xl')),
              ),

              // Timestamps Section
            ].separatedBy(CustomTheme().vGap('lg')),
          ),
        );
      },
    );
  }

  /// Header dengan title dan status badge
  Widget _buildHeader(bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    item[titleKey] ?? '-',
                    style: TextStyle(
                      fontSize: CustomTheme().fontSize(isTablet ? 'lg' : 'md'),
                      fontWeight: CustomTheme().fontWeight('bold'),
                    ),
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
                          title: item['rework_reference'] != null
                              ? item['rework_reference']['dyeing_no']
                              : '-',
                          rework: true,
                        )
                      ].separatedBy(CustomTheme().hGap('md')),
                    ),
                ].separatedBy(CustomTheme().hGap('xl')),
              ),
              if (item[subtitleKey] != null) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${item[subtitleKey][subtitleField] ?? '-'}',
                      style: TextStyle(
                        fontSize:
                            CustomTheme().fontSize(isTablet ? 'xl' : 'lg'),
                        color: Colors.grey[600],
                      ),
                    ),
                    if (item['work_orders']['urgent'] == true)
                      Icon(
                        Icons.warning_amber,
                        color: Colors.red,
                        size: 18,
                      )
                  ].separatedBy(CustomTheme().hGap('md')),
                ),
              ],
            ].separatedBy(CustomTheme().vGap('sm')),
          ),
        ),
        if (item['status'] != null)
          CustomBadge(
            title: _getStatusLabel(item['status']),
            status: item['status'],
            withStatus: true,
          ),
      ].separatedBy(CustomTheme().hGap('xl')),
    );
  }

  /// Section untuk Mesin dan Maklon
  Widget _buildMachineAndMaklonSection(bool isTablet) {
    return Expanded(
      child: Container(
        padding: CustomTheme().padding('card'),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: isTablet
            ? Row(
                children: [
                  if (item['machine'] != null)
                    Expanded(child: _buildMachineInfo(isTablet)),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item['machine'] != null) _buildMachineInfo(isTablet),
                ],
              ),
      ),
    );
  }

  Widget _buildMaklonSection(bool isTablet) {
    return Expanded(
      child: Container(
        padding: CustomTheme().padding('card'),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: isTablet
            ? Row(
                children: [
                  if (item['maklon'] == true)
                    Expanded(child: _buildMaklonInfo(isTablet)),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item['maklon'] == true) _buildMaklonInfo(isTablet),
                ],
              ),
      ),
    );
  }

  Widget _buildStartTimeSection(bool isTablet) {
    return Expanded(
      child: Container(
        padding: CustomTheme().padding('card'),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: isTablet
            ? Row(
                children: [
                  if (item['start_time'] != null)
                    Expanded(child: _buildTimeInfo(isTablet)),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item['start_time'] != null) _buildTimeInfo(isTablet)
                ],
              ),
      ),
    );
  }

  Widget _buildEndTimeSection(bool isTablet) {
    return Expanded(
      child: Container(
        padding: CustomTheme().padding('card'),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: isTablet
            ? Row(
                children: [
                  if (item['end_time'] != null) ...[
                    Expanded(child: _buildEndTimeInfo(isTablet)),
                  ]
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item['end_time'] != null) _buildEndTimeInfo(isTablet),
                ],
              ),
      ),
    );
  }

  /// Widget untuk menampilkan info Mesin
  Widget _buildMachineInfo(bool isTablet) {
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
            Icons.local_laundry_service_outlined,
            size: isTablet ? 20 : 18,
            color: CustomTheme().buttonColor('primary'),
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mesin',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize(isTablet ? 12 : 10),
                  color: Colors.grey[600],
                  fontWeight: CustomTheme().fontWeight('semibold'),
                ),
              ),
              Text(
                item['machine']['name'] ?? '-',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('md'),
                  fontWeight: CustomTheme().fontWeight('semibold'),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ].separatedBy(CustomTheme().vGap('sm')),
          ),
        ),
      ].separatedBy(CustomTheme().hGap('xl')),
    );
  }

  Widget _buildTimeInfo(bool isTablet) {
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
            Icons.access_time_outlined,
            size: isTablet ? 20 : 18,
            color: CustomTheme().buttonColor('primary'),
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mulai Proses',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize(isTablet ? 12 : 10),
                  color: Colors.grey[600],
                  fontWeight: CustomTheme().fontWeight('semibold'),
                ),
              ),
              Text(
                '${formatDateSafe(item['start_time'])}${item['start_by']?['name'] != null && item['start_by']?['name'].isNotEmpty ? " • ${item['start_by']?['name']}" : ""}',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('md'),
                  fontWeight: CustomTheme().fontWeight('semibold'),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ].separatedBy(CustomTheme().vGap('sm')),
          ),
        ),
      ].separatedBy(CustomTheme().hGap('xl')),
    );
  }

  Widget _buildEndTimeInfo(bool isTablet) {
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
            Icons.task_alt_outlined,
            size: isTablet ? 20 : 18,
            color: Colors.green,
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selesai Proses',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize(isTablet ? 12 : 10),
                  color: Colors.grey[600],
                  fontWeight: CustomTheme().fontWeight('semibold'),
                ),
              ),
              Text(
                '${formatDateSafe(item['end_time'])}${item['end_by']?['name'] != null && item['end_by']?['name'].isNotEmpty ? " • ${item['end_by']?['name']}" : ""}',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('md'),
                  fontWeight: CustomTheme().fontWeight('semibold'),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ].separatedBy(CustomTheme().vGap('sm')),
          ),
        ),
      ].separatedBy(CustomTheme().hGap('xl')),
    );
  }

  /// Widget untuk menampilkan info Maklon
  Widget _buildMaklonInfo(bool isTablet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: CustomTheme().buttonColor('warning').withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.business_outlined,
            size: isTablet ? 20 : 18,
            color: CustomTheme().buttonColor('warning'),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Maklon',
                style: TextStyle(
                  fontSize: isTablet ? 12 : 10,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item['maklon_name'] ?? '-',
                style: TextStyle(
                  fontSize: isTablet ? 14 : 13,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper untuk mendapatkan label status
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
