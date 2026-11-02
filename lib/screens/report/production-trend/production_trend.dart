import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class ProductionTrendComp extends StatelessWidget {
  final String dateRangeText;
  final VoidCallback onSelectDateRange;
  final num gradeA;
  final num gradeB;
  final num gradeBS;
  final dynamic formatNumber;

  const ProductionTrendComp({
    super.key,
    required this.dateRangeText,
    required this.onSelectDateRange,
    required this.gradeA,
    required this.gradeB,
    required this.gradeBS,
    required this.formatNumber,
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Container(
                decoration: CustomTheme().cardTheme(),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Hasil Sortir per Grade',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildGradeRow('Grade A', gradeA, Colors.green),
                    const SizedBox(height: 12),
                    _buildGradeRow('Grade B', gradeB, Colors.orange),
                    const SizedBox(height: 12),
                    _buildGradeRow('Grade BS', gradeBS, Colors.red),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeRow(String title, num value, Color color) {
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
