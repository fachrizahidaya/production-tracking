import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class PackingItemsSection extends StatefulWidget {
  final List<dynamic> items;

  final Function(
    int index,
    String key,
    dynamic value,
  ) onChange;

  const PackingItemsSection({
    super.key,
    required this.items,
    required this.onChange,
  });

  @override
  State<PackingItemsSection> createState() => _PackingItemsSectionState();
}

class _PackingItemsSectionState extends State<PackingItemsSection> {
  final Map<int, TextEditingController> _packingQtyControllers = {};

  final Map<int, TextEditingController> _weightDozenControllers = {};

  final Map<int, TextEditingController> _gsmControllers = {};

  final Map<int, TextEditingController> _weightGradeAControllers = {};

  final Map<int, TextEditingController> _totalWeightControllers = {};

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];

      /// EXISTING VALUES
      final qty = item['qty'] ?? 0;

      final weightPerDozen = item['weight_per_dozen'] ?? 0;

      final gsm = item['gsm'] ?? 0;

      final gradeA = item['weight_grade_a'] ?? 0;

      final total = item['total_weight'] ?? 0;

      _packingQtyControllers[i] = TextEditingController(
        text: qty.toString(),
      );

      _weightDozenControllers[i] = TextEditingController(
        text: weightPerDozen.toString(),
      );

      _gsmControllers[i] = TextEditingController(
        text: gsm.toString(),
      );

      _weightGradeAControllers[i] = TextEditingController(
        text: gradeA.toString(),
      );

      _totalWeightControllers[i] = TextEditingController(
        text: total.toString(),
      );

      /// SYNC EXISTING DATA
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChange(
          i,
          'qty',
          qty,
        );

        widget.onChange(
          i,
          'weight_per_dozen',
          weightPerDozen,
        );

        widget.onChange(
          i,
          'gsm',
          gsm,
        );

        widget.onChange(
          i,
          'weight_grade_a',
          gradeA,
        );

        widget.onChange(
          i,
          'total_weight',
          total,
        );
      });
    }
  }

  @override
  void dispose() {
    for (final c in _packingQtyControllers.values) {
      c.dispose();
    }

    for (final c in _weightDozenControllers.values) {
      c.dispose();
    }

    for (final c in _gsmControllers.values) {
      c.dispose();
    }

    for (final c in _weightGradeAControllers.values) {
      c.dispose();
    }

    for (final c in _totalWeightControllers.values) {
      c.dispose();
    }

    super.dispose();
  }

  String formatId(num value) {
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  double calculateGsmValue(
    double weightPerDozen,
  ) {
    return weightPerDozen * 100;
  }

  void _calculatePackingItem(
    int index,
  ) {
    final qty = double.tryParse(
          _packingQtyControllers[index]!
              .text
              .replaceAll('.', '')
              .replaceAll(',', '.'),
        ) ??
        0;

    final weightPerDozen = double.tryParse(
          _weightDozenControllers[index]!
              .text
              .replaceAll('.', '')
              .replaceAll(',', '.'),
        ) ??
        0;

    /// GSM
    final gsm = calculateGsmValue(
      weightPerDozen,
    );

    /// BERAT GRADE A
    final gradeA = (qty / 12) * weightPerDozen;

    /// TOTAL BERAT
    final total = gradeA;

    _gsmControllers[index]!.text = gsm.toStringAsFixed(0);

    _weightGradeAControllers[index]!.text = formatId(gradeA);

    _totalWeightControllers[index]!.text = formatId(total);

    widget.onChange(
      index,
      'qty',
      qty,
    );

    widget.onChange(
      index,
      'weight_per_dozen',
      weightPerDozen,
    );

    widget.onChange(
      index,
      'gsm',
      gsm,
    );

    widget.onChange(
      index,
      'weight_grade_a',
      gradeA,
    );

    widget.onChange(
      index,
      'total_weight',
      total,
    );

    setState(() {});
  }

  Widget _buildItemContent(
    BuildContext context,
    int index,
    dynamic item,
  ) {
    final finished = item['finished_product'];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  finished?['code'] ?? '-',
                ),
                Text(
                  finished?['name'] ?? '-',
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
                    controller: _packingQtyControllers[index],
                    req: false,
                    isNumber: true,
                    isSorting: true,
                    handleChange: (value) {
                      _calculatePackingItem(
                        index,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: TextForm(
                    label: 'Berat 1 Lusin (KG)',
                    controller: _weightDozenControllers[index],
                    req: false,
                    isNumber: true,
                    isSorting: true,
                    handleChange: (value) {
                      _calculatePackingItem(
                        index,
                      );
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
                    isNumber: true,
                    controller: _gsmControllers[index],
                  ),
                ),
                Expanded(
                  child: TextForm(
                    label: 'Berat Grade A (KG)',
                    isDisabled: true,
                    isNumber: true,
                    controller: _weightGradeAControllers[index],
                  ),
                ),
                Expanded(
                  child: TextForm(
                    label: 'Total Berat Keseluruhan (KG)',
                    isDisabled: true,
                    isNumber: true,
                    controller: _totalWeightControllers[index],
                  ),
                ),
              ].separatedBy(
                CustomTheme().hGap('xl'),
              ),
            ),
          ),
        ].separatedBy(
          CustomTheme().vGap('lg'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return NoData();
    }

    /// SINGLE ITEM
    if (widget.items.length == 1) {
      return TemplateCard(
        title: 'Packing',
        icon: Icons.inventory_2_outlined,
        child: _buildItemContent(
          context,
          0,
          widget.items.first,
        ),
      );
    }

    /// MULTIPLE ITEM
    return DefaultTabController(
      length: widget.items.length,
      child: TemplateCard(
        title: 'Packing per Produk',
        icon: Icons.inventory_2_outlined,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(
                  8,
                ),
              ),
              child: TabBar(
                isScrollable: true,
                dividerColor: Colors.transparent,
                tabAlignment: TabAlignment.start,
                tabs: widget.items.asMap().entries.map(
                  (entry) {
                    final index = entry.key;

                    final item = entry.value;

                    return Tab(
                      text: item['finished_product']?['code'] ??
                          'Produk ${index + 1}',
                    );
                  },
                ).toList(),
              ),
            ),
            SizedBox(
              height: 520,
              child: TabBarView(
                children: widget.items.asMap().entries.map(
                  (entry) {
                    final index = entry.key;

                    final item = entry.value;

                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                      ),
                      child: _buildItemContent(
                        context,
                        index,
                        item,
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ].separatedBy(
            CustomTheme().vGap('lg'),
          ),
        ),
      ),
    );
  }
}
