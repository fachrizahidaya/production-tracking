// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/list_item.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WorkOrderItemTab extends StatefulWidget {
  final dynamic data;

  const WorkOrderItemTab({
    super.key,
    this.data,
  });

  @override
  State<WorkOrderItemTab> createState() => _WorkOrderItemTabState();
}

class _WorkOrderItemTabState extends State<WorkOrderItemTab> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items =
        (widget.data?['items'] ?? []).cast<Map<String, dynamic>>();
    final double totalQty = items.fold<double>(
      0,
      (sum, item) => sum + ((item['qty'] ?? 0) as num).toDouble(),
    );

    final double totalBerat = items.fold<double>(
      0,
      (sum, item) => sum + ((item['weight'] ?? 0) as num).toDouble(),
    );
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Material',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('md'),
                        color: Colors.grey[600],
                        fontWeight: CustomTheme().fontWeight('semibold'),
                      ),
                    ),
                    Text(
                      '${widget.data['items']?.length ?? '-'}',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Berat',
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
