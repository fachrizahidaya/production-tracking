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

              // Info Section

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
                      fontSize: CustomTheme().fontSize(isTablet ? 'md' : 'sm'),
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

  /// Section untuk informasi item (label, field, nested)
  Widget _buildInfoSection(bool isTablet) {
    final items = <Widget>[];

    if (label != null && label is List) {
      for (var l in label) {
        if (item[l['field']] != null) {
          items.add(_buildInfoItem(
            label: l['label'] ?? '',
            value: item[l['field']].toString(),
            isTablet: isTablet,
          ));
        }
      }
    }

    if (itemField != null && itemField is List) {
      for (var field in itemField) {
        if (item[field['field']] != null) {
          items.add(_buildInfoItem(
            label: field['label'] ?? '',
            value: item[field['field']].toString(),
            isTablet: isTablet,
          ));
        }
      }
    }

    if (nestedField != null && nestedField is List) {
      for (var nested in nestedField) {
        final parentKey = nested['parent'];
        final childKey = nested['child'];
        if (item[parentKey] != null && item[parentKey][childKey] != null) {
          items.add(_buildInfoItem(
            label: nested['label'] ?? '',
            value: item[parentKey][childKey].toString(),
            isTablet: isTablet,
          ));
        }
      }
    }

    if (items.isEmpty) return const SizedBox.shrink();

    // Layout grid untuk tablet, column untuk mobile
    if (isTablet) {
      return Wrap(
        spacing: 24,
        runSpacing: 12,
        children: items,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.separatedBy(const SizedBox(height: 8)),
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
            Icons.play_circle_outline,
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
            Icons.check_circle_outline,
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

  /// Section untuk timestamp (created, updated)
  Widget _buildTimestampSection(bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isTablet ? 12 : 8,
        horizontal: isTablet ? 12 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: isTablet
          ? Row(
              children: [
                if (item['start_time'] != null)
                  Expanded(
                      child: _buildTimestampItem(
                    icon: Icons.play_circle_outline,
                    label: 'Mulai',
                    time: item['start_time'],
                    user: item['start_by']?['name'],
                    isTablet: isTablet,
                  )),
                if (item['end_time'] != null) ...[
                  const SizedBox(width: 16),
                  Expanded(
                      child: _buildTimestampItem(
                    icon: Icons.check_circle_outline,
                    label: 'Selesai',
                    time: item['end_time'],
                    user: item['end_by']?['name'],
                    isTablet: isTablet,
                  )),
                ],
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['start_time'] != null)
                  _buildTimestampItem(
                    icon: Icons.play_circle_outline,
                    label: 'Mulai',
                    time: item['start_time'],
                    user: item['start_by']?['name'],
                    isTablet: isTablet,
                  ),
                if (item['end_time'] != null) ...[
                  const SizedBox(height: 8),
                  _buildTimestampItem(
                    icon: Icons.check_circle_outline,
                    label: 'Selesai',
                    time: item['end_time'],
                    user: item['end_by']?['name'],
                    isTablet: isTablet,
                  ),
                ],
              ],
            ),
    );
  }

  /// Widget untuk single timestamp item
  Widget _buildTimestampItem({
    required IconData icon,
    required String label,
    required dynamic time,
    String? user,
    required bool isTablet,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: isTablet ? 16 : 14,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            '$label: ${formatDateSafe(time)}${user != null && user.isNotEmpty ? " • $user" : ""}',
            style: TextStyle(
              fontSize: isTablet ? 12 : 11,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Widget untuk single info item
  Widget _buildInfoItem({
    required String label,
    required String value,
    required bool isTablet,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: isTablet ? 13 : 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTablet ? 13 : 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Helper untuk mengecek apakah ada machine atau maklon

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
