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
              _buildHeader(isTablet),

              const Divider(height: 24),

              // Info Section
              _buildInfoSection(isTablet),

              // Machine & Maklon Section
              if (_hasMachineOrMaklon()) ...[
                SizedBox(height: isTablet ? 16 : 12),
                _buildMachineAndMaklonSection(isTablet),
              ],

              // Timestamps Section
              SizedBox(height: isTablet ? 16 : 12),
              _buildTimestampSection(isTablet),
            ],
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
              Text(
                item[titleKey] ?? '-',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: CustomTheme().fontWeight('bold'),
                ),
              ),
              if (item[subtitleField] != null) ...[
                const SizedBox(height: 4),
                Text(
                  '${item[subtitleField][subtitleKey] ?? '-'}',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        if (item['status'] != null)
          CustomBadge(
            title: _getStatusLabel(item['status']),
            status: item['status'],
            withStatus: true,
          ),
      ],
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
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
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
                if (item['machine'] != null && item['maklon'] == true)
                  const SizedBox(width: 24),
                if (item['maklon'] == true)
                  Expanded(child: _buildMaklonInfo(isTablet)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['machine'] != null) _buildMachineInfo(isTablet),
                if (item['machine'] != null && item['maklon'] == true)
                  const SizedBox(height: 12),
                if (item['maklon'] == true) _buildMaklonInfo(isTablet),
              ],
            ),
    );
  }

  /// Widget untuk menampilkan info Mesin
  Widget _buildMachineInfo(bool isTablet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: CustomTheme().buttonColor('primary').withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.local_laundry_service_outlined,
            size: isTablet ? 20 : 18,
            color: CustomTheme().buttonColor('primary'),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mesin',
                style: TextStyle(
                  fontSize: isTablet ? 12 : 10,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item['machine']['name'] ?? '-',
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
  bool _hasMachineOrMaklon() {
    return item['machine'] != null || item['maklon'] == true;
  }

  /// Helper untuk mendapatkan label status
  String _getStatusLabel(String? status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'in_progress':
        return 'Proses';
      case 'completed':
        return 'Selesai';
      case 'rework':
        return 'Rework';
      default:
        return status ?? '-';
    }
  }
}
