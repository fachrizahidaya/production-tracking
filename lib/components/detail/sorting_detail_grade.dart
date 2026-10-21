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

        if (gradeCode?.toString().toUpperCase() == 'A') {
          final transfersOut = item['transfers_out'];
          if (transfersOut is List) {
            groupedItems[uniqueKey]!['transfers_out'] = transfersOut
                .whereType<Map>()
                .map((transfer) => Map<String, dynamic>.from(transfer))
                .toList();
          }
          final transfersIn = item['transfers_in'];
          if (transfersIn is List) {
            groupedItems[uniqueKey]!['transfers_in'] = transfersIn
                .whereType<Map>()
                .map((transfer) => Map<String, dynamic>.from(transfer))
                .toList();
          }
        }

        groupedItems[uniqueKey]!['grades'].add({
          'code': gradeCode,
          'qty': item['qty'] ?? 0,
          'available_qty': item['available_qty'],
          'defects': item['defects'] ?? [],
          'semifinished_product': item['semifinished_product'],
          'finished_product': item['finished_product'],
          'spraying': item['spraying'] ?? 0,
          'rework_long_hemming': item['rework_long_hemming'] ?? 0,
          'combing': item['combing'] ?? 0,
        });
        final absorbed = item['absorbed_work_orders'];
        if (absorbed is List && absorbed.isNotEmpty) {
          groupedItems[uniqueKey]!['absorbed_work_orders'] = absorbed;
        }
      }
    }

    final sourceItems = sortingData['items'];
    if (sourceItems is List) {
      for (final grouped in groupedItems.values) {
        if (_absorbedRows(grouped).isNotEmpty) continue;
        for (final source in sourceItems.whereType<Map>()) {
          if (source['wo_item_id']?.toString() !=
              grouped['wo_item_id']?.toString()) {
            continue;
          }
          final absorbed = source['absorbed_work_orders'];
          if (absorbed is List && absorbed.isNotEmpty) {
            grouped['absorbed_work_orders'] = absorbed;
          }
        }
      }
    }

    if (groupedItems.length == 1 &&
        _absorbedRows(groupedItems.values.first).isEmpty &&
        sortingData['absorbed_work_orders'] is List) {
      groupedItems.values.first['absorbed_work_orders'] =
          sortingData['absorbed_work_orders'];
    }

    final items = groupedItems.values.toList();

    /// semua grade ada tapi items kosong
    if (items.isEmpty) {
      return TemplateCard(
          title: 'Detail Per Material',
          icon: Icons.inventory_2_outlined,
          child: NoData());
    }

    return DefaultTabController(
      length: items.length,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          return AnimatedBuilder(
            animation: tabController,
            builder: (context, _) {
              final item = items[tabController.index];
              return Column(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
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
                          for (int index = 0; index < items.length; index++)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: Tab(
                                text: 'Item ${index + 1}',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  _buildItemCard(item),
                ].separatedBy(CustomTheme().vGap('xl')),
              );
            },
          );
        },
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
                for (final grade in grades) ...[
                  _buildGradeCard(
                    item,
                    grade,
                  ),
                  if (grade['code']?.toString().toUpperCase() == 'A')
                    ..._transferOutNotes(item, grade),
                ],
                if (_absorbedRows(item).isNotEmpty)
                  _buildAbsorbedWorkOrders(item),
              ].separatedBy(
                CustomTheme().vGap('xl'),
              ),
            ),
          ),
          // if (_transferInRows(item).isNotEmpty) _buildGradeASourceSection(item),

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
          _buildHasilSortir(grades),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

  List<Map<String, dynamic>> _absorbedRows(Map item) {
    final raw = item['absorbed_work_orders'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .where((row) {
      final label = row['wo_no'] ?? row['label'] ?? row['wo_id'];
      return label != null && label.toString().trim().isNotEmpty;
    }).toList();
  }

  Widget _buildAbsorbedWorkOrders(Map<String, dynamic> item) {
    final rows = _absorbedRows(item);
    final total = rows.fold<num>(
      0,
      (sum, row) => sum + parseSafe(row['qty']),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 24),
        Text(
          'Qty dari WO lain',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        for (final row in rows) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  (row['wo_no'] ?? row['label'] ?? row['wo_id']).toString(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(formatNumber(row['qty'])),
            ],
          ),
          const SizedBox(height: 6),
        ],
        Text(
          'Total qty diambil: ${formatNumber(total)}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  List<Widget> _transferOutNotes(Map item, Map grade) {
    final out = _transferSummary(item['transfers_out'], 'to_wo_no');
    final incoming = _transferSummary(item['transfers_in'], 'from_wo_no');
    if (out == null && incoming == null) return [];

    const black = TextStyle(color: Colors.black);
    const blackBold = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );
    const redBold = TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w700,
    );
    final lines = <Widget>[];

    if (out != null) {
      lines.add(
        _qtyTakenLine(
          amount: '-${formatNumber(out.$1)}',
          amountStyle: redBold,
          conjunction: ' untuk ',
          woNos: out.$2,
          labelStyle: black,
        ),
      );
    }

    if (incoming != null) {
      lines.add(
        _qtyTakenLine(
          amount: '+${formatNumber(incoming.$1)}',
          amountStyle: blackBold,
          conjunction: ' dari ',
          woNos: incoming.$2,
          labelStyle: black,
        ),
      );
    }

    final total =
        parseSafe(grade['qty']) - (out?.$1 ?? 0) + (incoming?.$1 ?? 0);
    lines.add(
      Text(
        'Total: ${formatNumber(total)}',
        textAlign: TextAlign.right,
        style: blackBold,
      ),
    );

    return [
      Row(
        children: [
          const Spacer(flex: 4),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: lines.separatedBy(const SizedBox(height: 4)).toList(),
            ),
          ),
        ],
      ),
    ];
  }

  (double, String)? _transferSummary(dynamic rows, String woKey) {
    if (rows is! List) return null;
    final transfers = rows.whereType<Map>().toList();
    if (transfers.isEmpty) return null;

    var total = 0.0;
    final woNos = <String>[];
    for (final row in transfers) {
      total += parseSafe(row['qty']);
      final woNo = (row[woKey] ?? row['wo_no'])?.toString() ?? '';
      if (woNo.isNotEmpty) woNos.add(woNo);
    }

    return (total, woNos.join(', '));
  }

  Widget _qtyTakenLine({
    required String amount,
    required TextStyle amountStyle,
    required String conjunction,
    required String woNos,
    required TextStyle labelStyle,
  }) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
        ),
        children: [
          TextSpan(
            text: 'Qty diambil ',
            style: labelStyle,
          ),
          TextSpan(
            text: amount,
            style: amountStyle,
          ),
          if (woNos.isNotEmpty) ...[
            TextSpan(
              text: conjunction,
              style: labelStyle,
            ),
            TextSpan(
              text: woNos,
              style: labelStyle,
            ),
          ],
        ],
      ),
      textAlign: TextAlign.right,
    );
  }

  Widget _buildGradeCard(
    Map<String, dynamic> item,
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
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (grade['code'] == 'A')
                  Text(
                    getSpkNo(item),
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                  ),
              ],
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

  List<Map> _transferInRows(Map item) {
    final rows = item['transfers_in'];
    if (rows is! List) return [];
    return rows.whereType<Map>().toList();
  }

  Widget _buildGradeASourceSection(Map item) {
    final rows = _transferInRows(item);

    return TemplateCard(
      title: 'Ambil Qty Grade A',
      icon: Icons.move_down_outlined,
      child: Column(
        children: [
          for (final row in rows)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: _readOnlyField(
                      'WO / Lot',
                      _transferInLabel(row),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _readOnlyField(
                      'Qty diambil',
                      formatNumber(row['qty'] ?? 0),
                    ),
                  ),
                ].separatedBy(CustomTheme().hGap('md')),
              ),
            ),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: CustomTheme().fontWeight('semibold'),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 56,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: CustomTheme().inputStaticDecorationDisabled(),
          child: Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  String _transferInLabel(Map row) {
    final woNo = (row['from_wo_no'] ?? row['wo_no'] ?? '').toString();
    final sortingNo =
        (row['from_sorting_no'] ?? row['sorting_no'] ?? '').toString();
    if (woNo.isEmpty) return sortingNo;
    if (sortingNo.isEmpty) return woNo;
    return '$woNo ($sortingNo)';
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

  Widget _buildHasilSortir(List grades) {
    var gradeA = 0.0;
    var gradeB = 0.0;
    var gradeBS = 0.0;

    for (final grade in grades) {
      if (grade is! Map) continue;
      final code = (grade['code'] ?? '').toString().toUpperCase();
      final qty = parseSafe(grade['qty']);

      if (code == 'A') {
        gradeA += grade['available_qty'] == null
            ? qty
            : parseSafe(grade['available_qty']);
      } else if (code == 'B') {
        gradeB += qty;
      } else if (code == 'BS') {
        gradeBS += qty;
      }
    }

    final repair = grades.isEmpty
        ? 0.0
        : parseSafe(grades.first['spraying']) +
            parseSafe(grades.first['rework_long_hemming']) +
            parseSafe(grades.first['combing']);
    final total = gradeA + gradeB + gradeBS + repair;

    return TemplateCard(
      title: 'Hasil Sortir',
      icon: Icons.summarize_outlined,
      child: Row(
        children: [
          _buildRepairBox('Grade A', gradeA),
          _buildRepairBox('Grade B', gradeB),
          _buildRepairBox('Tipe BS', gradeBS),
          _buildRepairBox('Perbaikan', repair),
          _buildRepairBox('Hasil Sortir', total),
        ].separatedBy(CustomTheme().hGap('xl')),
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
