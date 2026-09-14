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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WO / Lot BS Tertinggi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
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
              const SizedBox(height: 8),
              SizedBox(
                height: loading || items.isEmpty
                    ? 120
                    : (items.length.clamp(1, 3).toDouble() * 106) + 6,
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : items.isEmpty
                        ? const NoData()
                        : ListView.builder(
                            controller: scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: items.length,
                            padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                            itemBuilder: (context, index) {
                              return _buildTopBsCard(items[index]);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBsCard(TopBsItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        padding: const EdgeInsets.all(12),
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
