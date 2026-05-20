import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class SortingDetailGradeList extends StatelessWidget {
  final Map<String, dynamic> sortingData;

  const SortingDetailGradeList({
    super.key,
    required this.sortingData,
  });

  double parseSafe(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value.toDouble();
    }

    if (value is double) {
      return value;
    }

    return double.tryParse(
          value.toString(),
        ) ??
        0;
  }

  @override
  Widget build(BuildContext context) {
    final grades = sortingData['grades'] ?? [];

    if (grades.isEmpty) {
      return const NoData();
    }

    final Map<int, Map<String, dynamic>> groupedItems = {};

    for (final grade in grades) {
      final gradeCode = grade['item_grade']?['code'];

      final items = grade['items'] ?? [];

      for (final item in items) {
        final itemId = item['item_id'];

        if (!groupedItems.containsKey(itemId)) {
          groupedItems[itemId] = {
            'finished_product': item['finished_product'],
            'grades': [],
            'defects': item['defects'] ?? [],
          };
        }

        groupedItems[itemId]!['grades'].add({
          'code': gradeCode,
          'qty': item['qty'] ?? 0,
          'defects': item['defects'] ?? [],
          'semifinished_product': item['semifinished_product'],
          'spraying': item['spraying'] ?? 0,
          'rework_long_hemming': item['rework_long_hemming'] ?? 0,
          'combing': item['combing'] ?? 0,
        });
      }
    }

    final items = groupedItems.values.toList();

    return DefaultTabController(
      length: items.length,
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            child: TabBar(
              isScrollable: true,
              dividerColor: Colors.transparent,
              tabs: [
                for (final item in items)
                  Tab(
                    text: item['finished_product']?['code'] ?? '-',
                  ),
              ],
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 660,
            child: TabBarView(
              children: [
                for (final item in items)
                  _buildItemCard(
                    item,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(
    Map<String, dynamic> item,
  ) {
    final grades = item['grades'] ?? [];

    final bsGrade = grades.firstWhere(
      (e) => e['code'] == 'BS',
      orElse: () => {},
    );

    final defects = bsGrade['defects'] ?? [];

    return Column(
      children: [
        /*
|--------------------------------------------------------------------------
| GRADE
|--------------------------------------------------------------------------
*/

        TemplateCard(
          title: 'Grade',
          icon: Icons.grade_outlined,
          child: Column(
            children: [
              for (final grade in grades)
                _buildGradeCard(
                  grade,
                ),
            ].separatedBy(
              SizedBox(height: 12),
            ),
          ),
        ),
        SizedBox(height: 16),

        /*
|--------------------------------------------------------------------------
| TIPE BS
|--------------------------------------------------------------------------
*/

        if (defects.isNotEmpty)
          TemplateCard(
            title: 'Tipe BS',
            icon: Icons.warning_amber_outlined,
            child: SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: defects.length,
                separatorBuilder: (_, __) => SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final defect = defects[index];

                  return Container(
                    constraints: BoxConstraints(
                      minWidth: 120,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.red.shade100,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          defect['type']['name'] ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.red.shade700,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          formatNumber(defect['qty']),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        SizedBox(height: 16),

        /*
|--------------------------------------------------------------------------
| PERBAIKAN
|--------------------------------------------------------------------------
*/

        TemplateCard(
          title: 'Perbaikan',
          icon: Icons.build_outlined,
          child: Row(
            children: [
              _buildRepairBox(
                'Semprotan',
                gradeValue(
                  grades,
                  'spraying',
                ),
              ),
              _buildRepairBox(
                'Permak Long Hemming',
                gradeValue(
                  grades,
                  'rework_long_hemming',
                ),
              ),
              _buildRepairBox(
                'Sisiran',
                gradeValue(
                  grades,
                  'combing',
                ),
              ),
            ].separatedBy(
              SizedBox(width: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradeCard(
    Map<String, dynamic> grade,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              grade['code'] ?? '-',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: grade['code'] == 'BS'
                  ? [
                      Text(
                        'Perhitungan otomatis dari total Tipe BS',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ]
                  : grade['code'] == 'B' &&
                          grade['semifinished_product']?['code'] == null
                      ? [
                          Text(
                            'Material code belum tersedia',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ]
                      : [
                          Text(
                            grade['semifinished_product']?['code'] ?? '',
                          ),
                          Text(
                            grade['semifinished_product']?['name'] ?? '-',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
            ),
          ),
          Expanded(
            flex: 2,
            child: grade['code'] == 'BS'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatNumber(
                          ((grade['defects'] ?? []) as List).fold<double>(
                            0,
                            (total, defect) => total + parseSafe(defect['qty']),
                          ),
                        ).toString(),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : Text(
                    formatNumber(
                      grade['qty'] ?? 0,
                    ).toString(),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepairBox(
    String title,
    dynamic value,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            SizedBox(height: 8),
            Text(
              formatNumber(value).toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double gradeValue(
    List grades,
    String key,
  ) {
    if (grades.isEmpty) {
      return 0;
    }

    return parseSafe(
      grades.first[key],
    );
  }
}
