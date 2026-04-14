// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ListItem extends StatelessWidget {
  final item;
  final label;
  final index;

  const ListItem({super.key, this.item, this.label, this.index});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: CustomTheme().padding('card'),
              child: isTablet ? _buildTabletLayout() : _buildMobileLayout(),
            ),
          ),
        );
      },
    );
  }

  /// Layout untuk Tablet
  Widget _buildTabletLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Item Info
              _buildItemInfo(true),
              _buildAdditionalInfo(true),
            ].separatedBy(CustomTheme().vGap('xl')),
          ),
        ),
        Expanded(flex: 1, child: _buildQuantitySection(true))
      ],
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              item['greige_item']['code']?.toString() ?? '-',
              style: TextStyle(
                fontSize: CustomTheme().fontSize('lg'),
                fontWeight: CustomTheme().fontWeight('semibold'),
                color: Colors.grey[800],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            Text(
              item['greige_item']['name']?.toString() ?? '-',
              style: TextStyle(
                fontSize: CustomTheme().fontSize('lg'),
                fontWeight: CustomTheme().fontWeight('semibold'),
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // if (item['spk_no'] != null) ...[
            //   Text(
            //     item['spk_no'].toString(),
            //     style: TextStyle(
            //       fontSize: CustomTheme().fontSize('lg'),
            //       color: Colors.grey[500],
            //     ),
            //     maxLines: 1,
            //     overflow: TextOverflow.ellipsis,
            //   ),
            // ],
          ],
        ),
      ],
    );
  }

  /// Additional Info (Category, Supplier, etc.)
  Widget _buildAdditionalInfo(bool isTablet) {
    if (isTablet) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildInfoChip(
            title: 'No. OP',
            icon: Icons.design_services_outlined,
            label: item['greige_item_op_no']?.toString() ?? '-',
            isTablet: isTablet,
          ),
          if (item['variants'][2] != null)
            _buildInfoChip(
              title: 'Desain',
              icon: Icons.design_services_outlined,
              label: item['variants'][0]['value']?.toString() ?? '-',
              isTablet: isTablet,
            ),
          if (item['variants'][1] != null)
            _buildInfoChip(
              title: 'Size',
              icon: Icons.numbers_outlined,
              label: item['variants'][1]['value']?.toString() ?? '-',
              isTablet: isTablet,
            ),
          if (item['variants'][0] != null)
            _buildInfoChip(
              title: 'Bahan',
              icon: Icons.cut_outlined,
              label: item['variants'][2]['value']?.toString() ?? '-',
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
      padding: CustomTheme().padding('badge-rework'),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${title}:',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('md'),
                    color: Colors.grey[500],
                    fontWeight: CustomTheme().fontWeight('semibold'),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  ' $label',
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
    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // if (label != 'Long Hemming' ||
          //     label != 'Cross Cutting' ||
          //     label != ' Sewing' ||
          //     label != ' Embroidery' ||
          //     label != ' Printing' ||
          //     label != ' Packing')
          // if (label == 'Long Hemming' ||
          //     label == 'Cross Cutting' ||
          //     label == ' Sewing' ||
          //     label == ' Embroidery' ||
          //     label == ' Printing' ||
          //     label == ' Packing')
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Qty',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: CustomTheme().fontWeight('semibold')),
                ),
                Row(
                  children: [
                    Text(
                      _formatQuantity(item['qty']),
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('xl'),
                        fontWeight: CustomTheme().fontWeight('bold'),
                      ),
                    ),
                    Text(
                      item['unit']?['code']?.toString() ?? '-',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('lg'),
                        color: Colors.grey[600],
                      ),
                    ),
                  ].separatedBy(CustomTheme().hGap('sm')),
                ),
              ].separatedBy(CustomTheme().hGap('xl'))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Berat',
                style: TextStyle(
                  fontWeight: CustomTheme().fontWeight('semibold'),
                  color: Colors.grey[600],
                ),
              ),
              Row(
                children: [
                  Text(
                    _formatQuantity(item['weight']),
                    style: TextStyle(
                      fontSize: CustomTheme().fontSize('xl'),
                      fontWeight: CustomTheme().fontWeight('bold'),
                    ),
                  ),
                  Text(
                    item['weight_unit']?['code']?.toString() ?? '-',
                    style: TextStyle(
                      fontSize: CustomTheme().fontSize('lg'),
                      color: Colors.grey[600],
                    ),
                  ),
                ].separatedBy(CustomTheme().hGap('sm')),
              ),
            ],
          ),
        ].separatedBy(CustomTheme().hGap('xl')));
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
