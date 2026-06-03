// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/spk/%5Bspk_id%5D.dart';

class ListItem extends StatefulWidget {
  final item;
  final label;
  final index;
  final withSpk;

  const ListItem({super.key, this.item, this.label, this.index, this.withSpk});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  dynamic get item => widget.item;
  dynamic get label => widget.label;
  dynamic get index => widget.index;
  dynamic get withSpk => widget.withSpk;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _buildQuantitySection(true, withSpk)),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildProdukJadiInfo(),
            ),
            Expanded(
              child: _buildGreigeInfo(),
            ),
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
        _buildAdditionalInfo(true),
      ].separatedBy(CustomTheme().vGap('xl')),
    );
  }

  /// Layout untuk Mobile
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuantitySection(false, withSpk),
        _buildProdukJadiInfo(),
        _buildGreigeInfo(),
        _buildAdditionalInfo(false),
      ].separatedBy(CustomTheme().vGap('xl')),
    );
  }

  /// Produk Jadi Info (Code + Name)
  Widget _buildProdukJadiInfo() {
    return Container(
      width: double.infinity,
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.blue.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRODUK JADI',
            style: TextStyle(
              fontWeight: CustomTheme().fontWeight('bold'),
              color: Colors.blue.shade700,
            ),
          ),
          Text(
            item['item_code']?.toString() ?? '-',
            style: TextStyle(
              fontSize: CustomTheme().fontSize('lg'),
              fontWeight: CustomTheme().fontWeight('semibold'),
              color: Colors.grey[800],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            item['item_name']?.toString() ?? '-',
            style: TextStyle(
              fontSize: CustomTheme().fontSize('lg'),
              fontWeight: CustomTheme().fontWeight('semibold'),
              color: Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ].separatedBy(CustomTheme().vGap('md')),
      ),
    );
  }

  /// Item Info (Code + Name)
  Widget _buildItemInfo(bool isTablet) {
    return Container(
      width: double.infinity,
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.orange.shade100,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GREIGE AWAL',
                  style: TextStyle(
                    fontWeight: CustomTheme().fontWeight('bold'),
                    color: Colors.orange.shade700,
                  ),
                ),
                Text(
                  item['greige_item']?['code']?.toString() ?? '-',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('lg'),
                    fontWeight: CustomTheme().fontWeight('semibold'),
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item['greige_item']?['name']?.toString() ?? '-',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('lg'),
                    fontWeight: CustomTheme().fontWeight('semibold'),
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ].separatedBy(CustomTheme().vGap('md')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreigeInfo() {
    final List greigeItems = item['greige_items'] ?? [];

    return Container(
      width: double.infinity,
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.orange.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GREIGE AWAL',
            style: TextStyle(
              fontWeight: CustomTheme().fontWeight('bold'),
              color: Colors.orange.shade700,
            ),
          ),
          if (greigeItems.isEmpty)
            Text(
              '-',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ...greigeItems.map((greige) {
            final greigeItem = greige['greige_item'];

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.shade100,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (greige['greige_item_op_no'] != null)
                    Row(
                      children: [
                        Icon(
                          Icons.confirmation_number_outlined,
                          size: 16,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'OP No : ${greige['greige_item_op_no']}',
                            style: TextStyle(
                              fontWeight: CustomTheme().fontWeight('semibold'),
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (greige['greige_item_op_no'] != null)
                    const SizedBox(height: 8),
                  Text(
                    greigeItem?['code']?.toString() ?? '-',
                    style: TextStyle(
                      fontSize: CustomTheme().fontSize('lg'),
                      fontWeight: CustomTheme().fontWeight('semibold'),
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    greigeItem?['name']?.toString() ?? '-',
                    style: TextStyle(
                      fontSize: CustomTheme().fontSize('md'),
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Qty : ${_formatQuantity(greige['qty'])} PCS',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Berat : ${_formatQuantity(greige['weight'])} KG',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
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
                  '$title:',
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
  Widget _buildQuantitySection(bool isTablet, withSpk) {
    return Container(
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (withSpk == true)
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SPK',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: CustomTheme().fontWeight('semibold'),
                      ),
                    ),
                    GestureDetector(
                      onTap: _openSpkDetail,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              item['spk_no']?.toString() ?? '-',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: CustomTheme().fontSize('xl'),
                                fontWeight: CustomTheme().fontWeight('bold'),
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_outlined,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Qty',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: CustomTheme().fontWeight('semibold'),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        _formatQuantity(item['qty']),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: CustomTheme().fontSize('xl'),
                          fontWeight: CustomTheme().fontWeight('bold'),
                        ),
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
              ],
            ),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        _formatQuantity(item['weight']),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: CustomTheme().fontSize('xl'),
                          fontWeight: CustomTheme().fontWeight('bold'),
                        ),
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
          ].separatedBy(SizedBox(
            width: 24,
          )),
        ),
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

  void _openSpkDetail() {
    final spkId = item?['spk_id'] ?? item?['spk']?['id'] ?? item?['spk_no'];

    if (spkId == null || spkId.toString().isEmpty || spkId == '-') {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpkDetail(id: spkId.toString()),
      ),
    );
  }
}
