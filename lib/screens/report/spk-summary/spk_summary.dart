import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/models/report/spk_summary.dart';

class SpkSummaryComp extends StatelessWidget {
  final SpkSummary? data;
  final String dateRangeText;
  final VoidCallback onSelectDateRange;
  final dynamic formatNumber;

  const SpkSummaryComp({
    super.key,
    required this.data,
    required this.dateRangeText,
    required this.onSelectDateRange,
    required this.formatNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTotalSpkCard(),
              const SizedBox(height: 12),
              _buildTotalQuantityCard(),
              const SizedBox(height: 12),
              _buildStatusCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalSpkCard() {
    return Container(
      decoration: CustomTheme().cardTheme(),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total SPK',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            formatNumber(data?.totalSpk),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                formatNumber(data?.totalActiveSpk),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 4),
              const Text(
                'aktif',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              const Text('・'),
              Text(
                formatNumber(data?.totalDoneSpk),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 4),
              const Text(
                'selesai',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalQuantityCard() {
    return Container(
      decoration: CustomTheme().cardTheme(),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Qty SPK',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            formatNumber(data?.totalQtySpk),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      decoration: CustomTheme().cardTheme(),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _buildStatusRow(
            'Melewati Deadline',
            data?.overdueSpk,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildStatusRow(
            'Belum ada Deadline',
            data?.noDeadlineSpk,
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildStatusRow(
            'Belum Diproses',
            data?.waitingSpk,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String title, num? value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            Text(
              formatNumber(value),
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'PCS',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }
}
