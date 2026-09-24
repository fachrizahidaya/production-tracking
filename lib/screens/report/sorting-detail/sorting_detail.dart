import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/models/report/production_summary.dart';

class SortingDetailComp extends StatelessWidget {
  final ProductionSummary? data;
  final String dateRangeText;
  final VoidCallback onSelectDateRange;
  final VoidCallback? onDownload;
  final dynamic formatNumber;

  const SortingDetailComp({
    super.key,
    required this.data,
    required this.dateRangeText,
    required this.onSelectDateRange,
    required this.formatNumber,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: Column(
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
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: onDownload,
                      child: Container(
                        decoration: CustomTheme().cardTheme(),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(Icons.download_outlined, size: 18),
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
                  _buildSummaryCard(
                    title: 'Total WO / Lot',
                    value: data?.totalWo,
                    subtitle: Row(
                      children: [
                        _buildInlineValue(data?.totalActiveWO, 'aktif'),
                        const Text('・'),
                        _buildInlineValue(data?.totalDoneWO, 'selesai'),
                      ],
                    ),
                    showChevron: false,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    title: 'WO / Lot Aktif',
                    value: data?.totalActiveWO,
                    subtitle: const Text('Sedang diproses'),
                    showChevron: false,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    title: 'WO / Lot Selesai',
                    value: data?.totalDoneWO,
                    subtitle: Row(
                      children: [
                        const Text(
                          'Dari',
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatNumber(data?.totalWo),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'total WO / Lot',
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                    showChevron: false,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    title: 'WO / Lot Aktif',
                    value: data?.reworkCount,
                    valueColor: Colors.red,
                    subtitle: const Text('Dari total WO / Lot'),
                    showChevron: false,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    title: 'Qty Proses',
                    value: data?.totalProcessQty,
                    valueColor: Colors.redAccent,
                    unit: 'PCS',
                    subtitle: _buildQuantitySource(
                      'Dari total qty SPK',
                      data?.totalSpkQty,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    title: 'Qty Packing',
                    value: data?.totalPackingQty,
                    valueColor: Colors.redAccent,
                    unit: 'PCS',
                    subtitle: _buildQuantitySource(
                      'Dari total sortir Grade A',
                      data?.gradeAQty,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSortingDetailCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required dynamic value,
    Widget? subtitle,
    Color? valueColor,
    String? unit,
    bool showChevron = false,
  }) {
    return Container(
      decoration: CustomTheme().cardTheme(),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              if (showChevron) const Icon(Icons.chevron_right_outlined),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                formatNumber(value),
                style: TextStyle(
                  color: valueColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: const TextStyle(fontWeight: FontWeight.w300),
                ),
              ],
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            subtitle,
          ],
        ],
      ),
    );
  }

  Widget _buildInlineValue(dynamic value, String label) {
    return Row(
      children: [
        Text(
          formatNumber(value),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w300),
        ),
      ],
    );
  }

  Widget _buildQuantitySource(String label, dynamic value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w300)),
        const SizedBox(width: 4),
        Text(
          formatNumber(value),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 4),
        const Text('PCS', style: TextStyle(fontWeight: FontWeight.w300)),
      ],
    );
  }

  Widget _buildSortingDetailCard() {
    return Container(
      decoration: CustomTheme().cardTheme(),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rincian Sortir',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    'Total: ${formatNumber(data?.totalSortingQty)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('PCS', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildGradeRow('Grade A', data?.gradeAQty, Colors.green),
          const SizedBox(height: 12),
          _buildGradeRow('Grade B', data?.gradeBQty, Colors.orange),
          const SizedBox(height: 12),
          _buildGradeRow('Grade BS', data?.gradeBSQty, Colors.red),
        ],
      ),
    );
  }

  Widget _buildGradeRow(String title, dynamic value, Color color) {
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
            const Text('PCS', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
