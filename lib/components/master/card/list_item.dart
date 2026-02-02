// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ListItem extends StatelessWidget {
  final item;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showActions;

  const ListItem({
    super.key,
    this.item,
    this.onTap,
    this.onLongPress,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // Main Content
                    Expanded(
                      child: Padding(
                        padding: CustomTheme().padding('card'),
                        child: isTablet
                            ? _buildTabletLayout()
                            : _buildMobileLayout(),
                      ),
                    ),
                    // Quantity Section
                    _buildQuantitySection(isTablet),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Layout untuk Tablet
  Widget _buildTabletLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Item Info
        Expanded(
          flex: 2,
          child: _buildItemInfo(true),
        ),
        // Additional Info
        Expanded(
          flex: 2,
          child: _buildAdditionalInfo(true),
        ),
        // Status Badge
      ].separatedBy(CustomTheme().hGap('xl')),
    );
  }

  /// Layout untuk Mobile
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: Icon + Info + Status
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildItemInfo(false)),
          ].separatedBy(CustomTheme().vGap('xl')),
        ),
        // Bottom Row: Additional Info
        _buildAdditionalInfo(false),
      ].separatedBy(CustomTheme().vGap('xl')),
    );
  }

  /// Item Info (Code + Name)
  Widget _buildItemInfo(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Item Code Badge
        Container(
          padding: CustomTheme().padding('badge'),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            item['item_code']?.toString() ?? '-',
            style: TextStyle(
              fontSize: CustomTheme().fontSize('sm'),
              fontWeight: CustomTheme().fontWeight('semibold'),
              color: Colors.grey[700],
              letterSpacing: 0.5,
            ),
          ),
        ),
        // Item Name
        Text(
          item['item_name']?.toString() ?? '-',
          style: TextStyle(
            fontSize: CustomTheme().fontSize(isTablet ? 'lg' : 'md'),
            fontWeight: CustomTheme().fontWeight('semibold'),
            color: Colors.grey[800],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (item['spk_no'] != null) ...[
          Text(
            item['spk_no'].toString(),
            style: TextStyle(
              fontSize: isTablet ? 13 : 11,
              color: Colors.grey[500],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }

  /// Additional Info (Category, Supplier, etc.)
  Widget _buildAdditionalInfo(bool isTablet) {
    if (isTablet) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (item['variants'][2] != null)
            _buildInfoChip(
              title: 'Desain',
              icon: Icons.design_services_outlined,
              label: item['variants'][2]['value']?.toString() ?? '-',
              isTablet: isTablet,
            ),
          if (item['variants'][0] != null)
            _buildInfoChip(
              title: 'Bahan',
              icon: Icons.cut_outlined,
              label: item['variants'][0]['value']?.toString() ?? '-',
              isTablet: isTablet,
            ),
          if (item['variants'][1] != null)
            _buildInfoChip(
              title: 'Ukuran',
              icon: Icons.numbers_outlined,
              label: item['variants'][1]['value']?.toString() ?? '-',
              isTablet: isTablet,
            ),
          if (item['variants'][3] != null) ...[
            _buildInfoChip(
              title: 'GSM',
              icon: Icons.numbers_outlined,
              label: item['variants'][3]['value']?.toString() ?? '-',
              isTablet: isTablet,
            ),
          ],
          if (item['variants'][4] != null) ...[
            _buildInfoChip(
              title: 'Warna',
              icon: Icons.color_lens_outlined,
              label: item['variants'][4]['value']?.toString() ?? '-',
              isTablet: isTablet,
            ),
          ],
        ],
      );
    }

    // Mobile: Horizontal scroll chips
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (item['variants'][2] != null)
            _buildInfoChip(
              title: 'Desain',
              icon: Icons.design_services_outlined,
              label: item['variants'][2]['value']?.toString() ?? '-',
              isTablet: isTablet,
            ),
          if (item['variants'][0] != null)
            _buildInfoChip(
              title: 'Bahan',
              icon: Icons.cut_outlined,
              label: item['variants'][0]['value']?.toString() ?? '-',
              isTablet: isTablet,
            ),
          if (item['variants'][1] != null)
            _buildInfoChip(
              title: 'Ukuran',
              icon: Icons.numbers_outlined,
              label: item['variants'][1]['value']?.toString() ?? '-',
              isTablet: isTablet,
            ),
          if (item['variants'][3] != null) ...[
            _buildInfoChip(
              title: 'GSM',
              icon: Icons.numbers_outlined,
              label: item['variants'][3]['value']?.toString() ?? '-',
              isTablet: isTablet,
            ),
          ],
          if (item['variants'][4] != null) ...[
            _buildInfoChip(
              title: 'Warna',
              icon: Icons.color_lens_outlined,
              label: item['variants'][4]['value']?.toString() ?? '-',
              isTablet: isTablet,
            ),
          ],
        ],
      ),
    );
  }

  /// Info Chip Widget
  Widget _buildInfoChip({
    required IconData icon,
    required String title,
    required String label,
    required bool isTablet,
  }) {
    return Container(
      padding: CustomTheme().padding('badge'),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: isTablet ? 16 : 14,
            color: Colors.grey[600],
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('xs'),
                    color: Colors.grey[500],
                    fontWeight: CustomTheme().fontWeight('medium'),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('sm'),
                    color: Colors.grey[700],
                    fontWeight: CustomTheme().fontWeight('semibold'),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ].separatedBy(CustomTheme().hGap('md')),
      ),
    );
  }

  /// Quantity Section
  Widget _buildQuantitySection(bool isTablet) {
    return Container(
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            CustomTheme().buttonColor('primary').withOpacity(0.08),
            CustomTheme().buttonColor('primary').withOpacity(0.03),
          ],
        ),
        border: Border(
          left: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatQuantity(item['qty']),
            style: TextStyle(
              fontSize: CustomTheme().fontSize(isTablet ? 'xl' : 'lg'),
              fontWeight: CustomTheme().fontWeight('bold'),
              color: CustomTheme().buttonColor('primary'),
            ),
          ),
          Text(
            item['unit']?['code']?.toString() ?? '-',
            style: TextStyle(
              fontSize: CustomTheme().fontSize('sm'),
              color: Colors.grey[600],
              fontWeight: CustomTheme().fontWeight('semibold'),
            ),
          ),
        ],
      ),
    );
  }

  /// Format Quantity
  String _formatQuantity(dynamic qty) {
    if (qty == null) return '0';
    if (qty is num) {
      return formatNumber(qty);
    }
    return qty.toString();
  }
}
