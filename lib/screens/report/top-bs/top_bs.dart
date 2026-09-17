import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/models/report/top_bs.dart';

class TopBsComp extends StatelessWidget {
  final List<TopBsItem> items;
  final bool loading;
  final ScrollController scrollController;
  final String dateRangeText;
  final VoidCallback onSelectDateRange;
  final dynamic formatNumber;

  const TopBsComp({
    super.key,
    required this.items,
    required this.loading,
    required this.scrollController,
    required this.dateRangeText,
    required this.onSelectDateRange,
    required this.formatNumber,
  });

  @override
  Widget build(BuildContext context) {
    const double listHeight = 120;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Text(
                'WO / Lot BS Tertinggi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: InkWell(
                      onTap: onSelectDateRange,
                      child: Container(
                        decoration: CustomTheme().cardTheme(),
                        padding: const EdgeInsets.all(12),
                        child: Text(dateRangeText),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: loading || items.isEmpty ? 120 : listHeight,
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : items.isEmpty
                      ? NoData()
                      : ListView.builder(
                          controller: scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: items.length,
                          padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                          itemBuilder: (context, index) {
                            return SizedBox(
                                width: 200,
                                child: _buildTopBsCard(items[index],
                                    isLast: index == items.length - 1));
                          },
                        ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBsCard(TopBsItem item, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 0, isLast ? 12 : 0, 12),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.woNo,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildRow('Qty BS', item.bsQty),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Presentse'),
                Row(
                  children: [
                    Text(
                      formatNumber(item.bsPercentage),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 2),
                    const Text('%'),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, num value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Row(
          children: [
            Text(
              formatNumber(value),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 2),
            const Text('PCS'),
          ],
        ),
      ],
    );
  }
}
