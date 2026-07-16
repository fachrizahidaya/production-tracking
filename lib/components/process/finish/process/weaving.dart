import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WeavingSection extends StatefulWidget {
  final items;
  final onChange;
  final data;

  const WeavingSection({super.key, this.data, this.items, this.onChange});

  @override
  State<WeavingSection> createState() => _WeavingSectionState();
}

class _WeavingSectionState extends State<WeavingSection> {
  final Map<int, TextEditingController> _greigeControllers = {};
  final Map<int, TextEditingController> _wasteControllers = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];

      _greigeControllers[i] = TextEditingController(
        text: item['greige_weight']?.toString() ?? '0',
      );

      _wasteControllers[i] = TextEditingController(
        text: item['waste_weight']?.toString() ?? '0',
      );
    }
  }

  @override
  void dispose() {
    for (final c in _greigeControllers.values) {
      c.dispose();
    }

    for (final c in _wasteControllers.values) {
      c.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return NoData();
    }

    if (widget.items.length == 1) {
      return Expanded(
        child: TemplateCard(
            title: 'Berat Order',
            icon: Icons.scale_outlined,
            child: _buildItemContent(context, 0, widget.items.first)),
      );
    }

    return DefaultTabController(
        length: widget.items.length,
        child: Expanded(
            child: TemplateCard(
                title: 'Berat per Order',
                icon: Icons.rule,
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
                          tabs: widget.items.asMap().entries.map((entry) {
                            final index = entry.key;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: Tab(
                                text: 'Item ${index + 1}',
                              ),
                            );
                          }).toList(),
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
                  ],
                ))));
  }

  Widget _buildItemContent(
    BuildContext context,
    int index,
    dynamic item,
  ) {
    final isTablet = MediaQuery.of(context).size.width > 700;

    final woItems = widget.data;

    String getSpkNo(Map<String, dynamic> item) {
      final woItemId = item['wo_item_id'];
      final itemCode = item['finished_product']?['code'];

      final matched = woItems.cast<Map<String, dynamic>?>().firstWhere(
            (e) => e?['id'] == woItemId && e?['item_code'] == itemCode,
            orElse: () => null,
          );

      return matched?['spk_no']?.toString() ?? woItemId.toString();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Semi Finished

            /// Finished Product

            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
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
                      'No. SPK',
                      style: TextStyle(
                        fontWeight: CustomTheme().fontWeight('semibold'),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      getSpkNo(item) ?? '-',
                    ),
                  ],
                ),
              ),
            ),
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
        Row(
          children: [
            SizedBox(
              width: isTablet
                  ? (MediaQuery.of(context).size.width - 80) / 2
                  : double.infinity,
              child: TextForm(
                label: 'Berat Greige (KG)',
                controller: _greigeControllers[index],
                isNumber: true,
                isSorting: true,
                handleChange: (value) {
                  widget.onChange(
                    index,
                    'greige_weight',
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
                label: 'Berat Waste (KG)',
                controller: _wasteControllers[index],
                isNumber: true,
                isSorting: true,
                handleChange: (value) {
                  widget.onChange(
                    index,
                    'waste_weight',
                    value,
                  );
                },
              ),
            ),
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
      ].separatedBy(CustomTheme().vGap('xl')),
    );
  }
}
