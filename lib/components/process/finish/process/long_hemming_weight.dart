import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class LongHemmingItemsWeightSection extends StatefulWidget {
  final List<dynamic> items;
  final Function(int index, String key, dynamic value) onChange;

  const LongHemmingItemsWeightSection({
    super.key,
    required this.items,
    required this.onChange,
  });

  @override
  State<LongHemmingItemsWeightSection> createState() =>
      _LongHemmingItemsWeightSectionState();
}

class _LongHemmingItemsWeightSectionState
    extends State<LongHemmingItemsWeightSection> {
  final Map<int, TextEditingController> _goodControllers = {};
  final Map<int, TextEditingController> _bsControllers = {};

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];

      _goodControllers[i] = TextEditingController(
        text: item['good_weight']?.toString() ?? '0',
      );

      _bsControllers[i] = TextEditingController(
        text: item['bs_weight']?.toString() ?? '0',
      );
    }
  }

  @override
  void dispose() {
    for (final c in _goodControllers.values) {
      c.dispose();
    }

    for (final c in _bsControllers.values) {
      c.dispose();
    }

    super.dispose();
  }

  Widget _buildItemContent(
    BuildContext context,
    int index,
    dynamic item,
  ) {
    final isTablet = MediaQuery.of(context).size.width > 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Semi Finished
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.orange.shade100,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Produk Setengah Jadi',
                style: TextStyle(
                  fontWeight: CustomTheme().fontWeight('semibold'),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item['semifinished_product']?['code'] ?? '-',
              ),
              Text(
                item['semifinished_product']?['name'] ?? '-',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        /// Finished Product
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
                  fontWeight: CustomTheme().fontWeight('semibold'),
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

        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: isTablet
                  ? (MediaQuery.of(context).size.width - 80) / 2
                  : double.infinity,
              child: TextForm(
                label: 'Berat Bagus (KG)',
                controller: _goodControllers[index],
                isNumber: true,
                isSorting: true,
                handleChange: (value) {
                  widget.onChange(
                    index,
                    'good_weight',
                    value,
                  );
                },
              ),
            ),
            SizedBox(
              width: isTablet
                  ? (MediaQuery.of(context).size.width - 80) / 2
                  : double.infinity,
              child: TextForm(
                label: 'Berat BS (KG)',
                controller: _bsControllers[index],
                isNumber: true,
                isSorting: true,
                handleChange: (value) {
                  widget.onChange(
                    index,
                    'bs_weight',
                    value,
                  );
                },
              ),
            ),
          ],
        ),
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return NoData();
    }

    /// SINGLE ITEM
    if (widget.items.length == 1) {
      return Expanded(
        child: TemplateCard(
          title: 'Berat Produk',
          icon: Icons.scale_outlined,
          child: _buildItemContent(
            context,
            0,
            widget.items.first,
          ),
        ),
      );
    }

    /// MULTI ITEM
    return DefaultTabController(
      length: widget.items.length,
      child: Expanded(
        child: TemplateCard(
          title: 'Berat per Produk',
          icon: Icons.inventory_2_outlined,
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: TabBar(
                    isScrollable: false,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Colors.white,
                    indicator: BoxDecoration(
                      color: Colors.blue[800],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    tabs: [
                      for (final item in widget.items)
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Tab(
                            text: item['finished_product']?['code'] ?? '-',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 420,
                child: TabBarView(
                  children: widget.items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 16),
                      child: _buildItemContent(
                        context,
                        index,
                        item,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ].separatedBy(CustomTheme().vGap('lg')),
          ),
        ),
      ),
    );
  }
}
