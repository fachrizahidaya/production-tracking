import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
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
    final Map<String, Map<String, dynamic>> groupedItems = {};

    for (final grade in grades) {
      final gradeCode = grade['item_grade']?['code'];

      final items = grade['items'] ?? [];

      for (final item in items) {
        final itemId = item['item_id'];
        final uniqueKey =
            '${item['wo_item_id']}_${item['finished_product']?['code']}';

        if (!groupedItems.containsKey(uniqueKey)) {
          groupedItems[uniqueKey] = {
            'wo_item_id': item['wo_item_id'],
            'finished_product': item['finished_product'],
            'grades': [],
            'defects': item['defects'] ?? [],
          };
        }

        groupedItems[uniqueKey]!['grades'].add({
          'code': gradeCode,
          'qty': item['qty'] ?? 0,
          'defects': item['defects'] ?? [],
          'semifinished_product': item['semifinished_product'],
          'finished_product': item['finished_product'],
          'spraying': item['spraying'] ?? 0,
          'rework_long_hemming': item['rework_long_hemming'] ?? 0,
          'combing': item['combing'] ?? 0,
        });
      }
    }

    final items = groupedItems.values.toList();

    /// semua grade ada tapi items kosong
    if (items.isEmpty) {
      return TemplateCard(
          title: 'Detail Per Material',
          icon: Icons.inventory_2_outlined,
          child: NoData());
    }

    final woItems = sortingData['work_orders']?['items'] ?? [];

    String getSpkNo(Map<String, dynamic> item) {
      final woItemId = item['wo_item_id'];
      final itemCode = item['finished_product']?['code'];

      final woItems = sortingData['work_orders']?['items'] ?? [];

      final matched = woItems.cast<Map<String, dynamic>?>().firstWhere(
            (e) => e?['id'] == woItemId && e?['item_code'] == itemCode,
            orElse: () => null,
          );

      return matched?['spk_no']?.toString() ?? woItemId.toString();
    }

    return DefaultTabController(
      length: items.length,
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: TabBar(
                isScrollable: true,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicatorColor: Colors.white,
                indicator: BoxDecoration(
                  color: Colors.blue[800],
                  borderRadius: BorderRadius.circular(6),
                ),
                tabAlignment: TabAlignment.start,
                tabs: [
                  for (final item in items)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Tab(
                        text:
                            '${item['finished_product']?['code'] ?? '-'} (${getSpkNo(item)})',
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 800,
            child: TabBarView(
              children: [
                for (final item in items)
                  _buildItemCard(
                    item,
                  ),
              ],
            ),
          ),
        ].separatedBy(CustomTheme().vGap('xl')),
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

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
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
                CustomTheme().vGap('xl'),
              ),
            ),
          ),

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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
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
              ].separatedBy(CustomTheme().hGap('xl')),
            ),
          ),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
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
                            grade['semifinished_product']?['code'] ??
                                grade['finished_product']?['code'] ??
                                '-',
                          ),
                          Text(
                            grade['semifinished_product']?['name'] ??
                                grade['finished_product']?['name'] ??
                                '-',
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
