import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class PackingSection extends StatefulWidget {
  final Map data;
  final Map processData;

  const PackingSection({
    super.key,
    required this.data,
    required this.processData,
  });

  @override
  State<PackingSection> createState() => _PackingSectionState();
}

class _PackingSectionState extends State<PackingSection> {
  double calculateGsmValue(double weightPerDozen) {
    return weightPerDozen * 100;
  }

  String formatNumber(dynamic value) {
    if (value == null) return '0';

    final number = double.tryParse(value.toString()) ?? 0;

    if (number % 1 == 0) {
      return number.toInt().toString();
    }

    return number.toStringAsFixed(2);
  }

  Widget _buildSortingQty() {
    final items = widget.processData['items'] ?? [];

    double totalGradeA = 0;
    double totalBS = 0;
    double totalRepair = 0;

    for (final item in items) {
      totalGradeA +=
          double.tryParse(item['grade_a_qty']?.toString() ?? '0') ?? 0;

      totalBS += double.tryParse(item['bs_qty']?.toString() ?? '0') ?? 0;

      totalRepair +=
          double.tryParse(item['repair_qty']?.toString() ?? '0') ?? 0;
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _summaryItem(
                'Grade A',
                formatNumber(totalGradeA),
              ),
            ),
            Expanded(
              child: _summaryItem(
                'BS',
                formatNumber(totalBS),
              ),
            ),
            Expanded(
              child: _summaryItem(
                'Perbaikan',
                formatNumber(totalRepair),
              ),
            ),
          ].separatedBy(
            CustomTheme().hGap('md'),
          ),
        ),
      ],
    );
  }

  Widget _summaryItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: CustomTheme().fontWeight('bold'),
            ),
          ),
          const SizedBox(height: 4),
          Text(title),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.data['items'] ?? [];

    return Column(
      children: [
        /// GLOBAL SORTING RESULT
        TemplateCard(
          title: 'Rincian Hasil Sortir',
          icon: Icons.sort_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _buildSortingQty(),
                      ],
                    ),
                  ),
                ].separatedBy(
                  CustomTheme().hGap('xl'),
                ),
              ),
            ].separatedBy(
              CustomTheme().vGap('lg'),
            ),
          ),
        ),

        /// PER ITEM PACKING
        DefaultTabController(
          length: items.length,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TabBar(
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  tabAlignment: TabAlignment.start,
                  tabs: List.generate(
                    items.length,
                    (index) {
                      final item = items[index];

                      return Tab(
                        text: item['finished_product']?['code'] ??
                            'Produk ${index + 1}',
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 600,
                child: TabBarView(
                  children: List.generate(
                    items.length,
                    (index) {
                      final item = items[index];

                      final qtyController = TextEditingController(
                        text: item['qty']?.toString() ?? '0',
                      );

                      final weightPerDozenController = TextEditingController(
                        text: item['weight_per_dozen']?.toString() ?? '0',
                      );

                      return SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          children: [
                            /// PRODUCT INFO
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.green.shade100,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Produk Jadi',
                                    style: TextStyle(
                                      fontWeight: CustomTheme().fontWeight(
                                        'semibold',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['finished_product']?['code'] ?? '-',
                                  ),
                                  Text(
                                    item['finished_product']?['name'] ?? '-',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// PACKING
                            TemplateCard(
                              title: 'Packing',
                              icon: Icons.layers_outlined,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextForm(
                                      label: 'Total Packing (PCS)',
                                      req: false,
                                      isNumber: true,
                                      isSorting: true,
                                      controller: qtyController,
                                      initialValue:
                                          item['qty']?.toString() ?? '0',
                                      handleChange: (value) {
                                        final qty = double.tryParse(value) ?? 0;

                                        item['qty'] = qty;

                                        final weightPerDozen = double.tryParse(
                                              weightPerDozenController.text,
                                            ) ??
                                            0;

                                        final beratGradeA =
                                            (qty / 12) * weightPerDozen;

                                        item['weight_grade_a'] = beratGradeA;

                                        item['total_weight'] = beratGradeA;

                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: TextForm(
                                      label: 'Berat 1 Lusin (KG)',
                                      req: false,
                                      isSorting: true,
                                      isNumber: true,
                                      controller: weightPerDozenController,
                                      initialValue: item['weight_per_dozen']
                                              ?.toString() ??
                                          '0',
                                      handleChange: (value) {
                                        final weightPerDozen =
                                            double.tryParse(value) ?? 0;

                                        item['weight_per_dozen'] =
                                            weightPerDozen;

                                        final qty = double.tryParse(
                                              qtyController.text,
                                            ) ??
                                            0;

                                        item['gsm'] = calculateGsmValue(
                                          weightPerDozen,
                                        );

                                        final beratGradeA =
                                            (qty / 12) * weightPerDozen;

                                        item['weight_grade_a'] = beratGradeA;

                                        item['total_weight'] = beratGradeA;

                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ].separatedBy(
                                  CustomTheme().hGap('xl'),
                                ),
                              ),
                            ),

                            /// RESULT
                            TemplateCard(
                              title: 'Gramasi & Total Berat',
                              icon: Icons.scale_outlined,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: TextForm(
                                      label: 'Gramasi (GSM)',
                                      isDisabled: true,
                                      controller: TextEditingController(
                                        text: formatNumber(
                                          item['gsm'] ?? 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextForm(
                                      label: 'Berat Grade A (KG)',
                                      isDisabled: true,
                                      controller: TextEditingController(
                                        text: formatNumber(
                                          item['weight_grade_a'] ?? 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextForm(
                                      label: 'Total Berat Keseluruhan (KG)',
                                      isDisabled: true,
                                      controller: TextEditingController(
                                        text: formatNumber(
                                          item['total_weight'] ?? 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ].separatedBy(
                                  CustomTheme().hGap('xl'),
                                ),
                              ),
                            ),
                          ].separatedBy(
                            CustomTheme().vGap('xl'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ].separatedBy(
              CustomTheme().vGap('lg'),
            ),
          ),
        ),
      ].separatedBy(
        CustomTheme().vGap('xl'),
      ),
    );
  }
}
