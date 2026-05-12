// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/list_item.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ItemTab extends StatefulWidget {
  final data;
  final handleSpk;
  final refetch;
  final hasMore;
  final label;

  const ItemTab(
      {super.key,
      this.data,
      this.handleSpk,
      this.refetch,
      this.hasMore,
      this.label});

  @override
  State<ItemTab> createState() => _ItemTabState();
}

class _ItemTabState extends State<ItemTab> {
  @override
  Widget build(BuildContext context) {
    final List items = widget.data['items'] ?? [];
    final int totalQty = items.fold<int>(
      0,
      (sum, item) => sum + (item['qty'] ?? 0) as int,
    );
    final totalBerat = widget.data['greige_qty'] ?? 0;
    final spkNo = widget.data?['items']?[0]?['spk_no'] ?? '-';

    return TemplateCard(
      title: 'Material',
      icon: Icons.inventory_2_outlined,
      child: widget.data.isEmpty
          ? NoData()
          : Column(
              children: [
                _buildProdukJadiHeader(spkNo, totalQty, totalBerat),
                SizedBox(height: 16),
                Column(
                  children: List.generate(items.length, (index) {
                    return Column(
                      children: [
                        ListItem(
                          item: items[index],
                          label: widget.label,
                          index: index,
                          withSpk: false,
                        ),
                        if (index != items.length - 1) SizedBox(height: 12),
                      ].separatedBy(CustomTheme().vGap('xl')),
                    );
                  }),
                ),
              ],
            ),
    );
  }

  /// Build Produk Jadi header with totals in row format
  Widget _buildProdukJadiHeader(
      String spkNo, dynamic totalQty, dynamic totalBerat) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRODUK JADI',
            style: TextStyle(fontWeight: CustomTheme().fontWeight('semibold')),
          ),
          Divider(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data['items'][0]['item_code'] ?? '-',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('lg'),
                        fontWeight: CustomTheme().fontWeight('semibold'),
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      widget.data['items'][0]['item_name'] ?? '-',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('lg'),
                        fontWeight: CustomTheme().fontWeight('semibold'),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Qty',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('md'),
                        color: Colors.grey[600],
                        fontWeight: CustomTheme().fontWeight('semibold'),
                      ),
                    ),
                    Text(
                      '${formatNumber(totalQty)} ${widget.data['items'][0]['unit']['code'] ?? ''}',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('lg'),
                        fontWeight: CustomTheme().fontWeight('semibold'),
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Berat',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('md'),
                        color: Colors.grey[600],
                        fontWeight: CustomTheme().fontWeight('semibold'),
                      ),
                    ),
                    Text(
                      '${formatNumber(totalBerat)} ${widget.data['greige_unit']['code'] ?? ''}',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('lg'),
                        fontWeight: CustomTheme().fontWeight('semibold'),
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ].separatedBy(SizedBox(width: 16)),
          ),
        ].separatedBy(CustomTheme().vGap('md')),
      ),
    );
  }
}
