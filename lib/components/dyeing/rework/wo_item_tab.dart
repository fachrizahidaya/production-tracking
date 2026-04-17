// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/list_item.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WoItemTab extends StatefulWidget {
  final dynamic data;

  const WoItemTab({
    super.key,
    this.data,
  });

  @override
  State<WoItemTab> createState() => _WoItemTabState();
}

class _WoItemTabState extends State<WoItemTab> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items =
        (widget.data?['items'] ?? []).cast<Map<String, dynamic>>();
    // final int totalQty = items.fold<int>(
    //   0,
    //   (sum, item) => sum + (item['qty'] ?? 0) as int,
    // );
    // final totalBerat = widget.data['greige_qty'] ?? 0;
    // final spkNo = widget.data?['items']?[0]?['spk_no'] ?? '-';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: CustomTheme().padding('card'),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: CustomTheme().padding('process-content'),
                  decoration: BoxDecoration(
                    color:
                        CustomTheme().buttonColor('primary').withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 18,
                    color: CustomTheme().buttonColor('primary'),
                  ),
                ),
                Text(
                  'Material',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('md'),
                    fontWeight: CustomTheme().fontWeight('semibold'),
                    color: Colors.grey[800],
                  ),
                ),
              ].separatedBy(CustomTheme().hGap('xl')),
            ),
          ),
          // _buildProdukJadiHeader(spkNo, totalQty, totalBerat),
          Padding(
              padding: CustomTheme().padding('item-detail'),
              child: widget.data.isEmpty
                  ? NoData()
                  : Column(
                      children: List.generate(items.length, (index) {
                        return Column(
                          children: [
                            ListItem(item: items[index]),
                            if (index != items.length - 1) SizedBox(height: 12),
                          ].separatedBy(CustomTheme().vGap('xl')),
                        );
                      }),
                    )),
        ],
      ),
    );
  }

  Widget _buildProdukJadiHeader(
      String spkNo, dynamic totalQty, dynamic totalBerat) {
    return Padding(
      padding: CustomTheme().padding('item-detail'),
      child: Container(
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
              style:
                  TextStyle(fontWeight: CustomTheme().fontWeight('semibold')),
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
                        'SPK',
                        style: TextStyle(
                          fontSize: CustomTheme().fontSize('md'),
                          color: Colors.grey[600],
                          fontWeight: CustomTheme().fontWeight('semibold'),
                        ),
                      ),
                      Text(
                        spkNo.isNotEmpty ? spkNo : '-',
                        style: TextStyle(
                          fontSize: CustomTheme().fontSize('lg'),
                          fontWeight: CustomTheme().fontWeight('semibold'),
                          color: Colors.grey[800],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
