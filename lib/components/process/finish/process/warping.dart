import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WarpingSection extends StatefulWidget {
  final items;
  final onChange;
  final data;

  const WarpingSection({super.key, this.items, this.onChange, this.data});

  @override
  State<WarpingSection> createState() => _WarpingSectionState();
}

class _WarpingSectionState extends State<WarpingSection> {
  final Map<int, TextEditingController> _beamWeightControllers = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];

      _beamWeightControllers[i] = TextEditingController(
        text: item['beam_weight']?.toString() ?? '0',
      );
    }
  }

  void _handleQty(
    int index,
    String value,
  ) {
    final safeValue = value.toString().trim().isEmpty ? '0' : value.toString();

    widget.onChange(
      index,
      'beam_weight',
      safeValue,
    );
  }

  @override
  void dispose() {
    for (final controller in _beamWeightControllers.values) {
      controller.dispose();
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
              title: 'Berat Beam',
              icon: Icons.rule,
              child: _buildItemContent(context, 0, widget.items.first)));
    }

    return DefaultTabController(
        length: widget.items.length,
        child: Expanded(
            child: TemplateCard(
                title: 'Berat Beam',
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
                            final item = entry.value;

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
                      height: 360,
                      child: TabBarView(
                        children: widget.items.asMap().entries.map((entry) {
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

    final semiFinished = item['semifinished_product'];

    final finished = item['finished_product'];

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
        SizedBox(
          width: isTablet
              ? (MediaQuery.of(context).size.width - 80) / 2
              : double.infinity,
          child: TextForm(
            label: 'Berat Beam (PCS)',
            controller: _beamWeightControllers[index],
            initialValue: item['beam_weight']?.toString() ?? '0',
            req: false,
            isNumber: true,
            isSorting: true,
            handleChange: (value) => _handleQty(
              index,
              value,
            ),
          ),
        ),
      ].separatedBy(
        CustomTheme().vGap('lg'),
      ),
    );
  }
}
