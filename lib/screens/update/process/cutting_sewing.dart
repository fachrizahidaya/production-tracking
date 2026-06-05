import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CuttingSewingQtySection extends StatefulWidget {
  final String label;
  final List<dynamic> items;
  final Function(int index, String key, dynamic value) onChange;
  final workOrders;

  const CuttingSewingQtySection(
      {super.key,
      required this.label,
      required this.items,
      required this.onChange,
      this.workOrders});

  @override
  State<CuttingSewingQtySection> createState() =>
      _CuttingSewingQtySectionState();
}

class _CuttingSewingQtySectionState extends State<CuttingSewingQtySection> {
  final Map<int, TextEditingController> _qtyControllers = {};

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];

      _qtyControllers[i] = TextEditingController(
        text: item['qty']?.toString() ?? '0',
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _qtyControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  void _handleChange(
    int index,
    String value,
  ) {
    final safeValue = value.toString().trim().isEmpty ? '0' : value.toString();

    widget.onChange(
      index,
      'qty',
      safeValue,
    );

    setState(() {});
  }

  Widget _buildItemContent(
    BuildContext context,
    int index,
    dynamic item,
  ) {
    final isTablet = MediaQuery.of(context).size.width > 700;

    final semiFinished = item['semifinished_product'];

    final finished = item['finished_product'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Semi Finished
        if (semiFinished != null)
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
                  semiFinished['code'] ?? '-',
                ),
                Text(
                  semiFinished['name'] ?? '-',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

        /// Finished Product
        if (finished != null)
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
                  finished['code'] ?? '-',
                ),
                Text(
                  finished['name'] ?? '-',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

        SizedBox(
          width: isTablet
              ? (MediaQuery.of(context).size.width - 80) / 2
              : double.infinity,
          child: TextForm(
            label: 'Qty Hasil ${widget.label} (PCS)',
            req: false,
            isNumber: true,
            isSorting: true,
            controller: _qtyControllers[index],
            initialValue: item['qty']?.toString() ?? '0',
            handleChange: (value) => _handleChange(
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

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return NoData();
    }

    final woItems = widget.workOrders;

    String getSpkNo(Map<String, dynamic> item) {
      final woItemId = item['wo_item_id'];
      final itemCode = item['finished_product']?['code'];

      final matched = woItems.cast<Map<String, dynamic>?>().firstWhere(
            (e) => e?['id'] == woItemId && e?['item_code'] == itemCode,
            orElse: () => null,
          );

      return matched?['spk_no']?.toString() ?? woItemId.toString();
    }

    /// SINGLE ITEM
    if (widget.items.length == 1) {
      return TemplateCard(
        title: 'Qty Produk',
        icon: Icons.numbers_outlined,
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
                tabs: [
                  for (final item in widget.items)
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
            height: 320,
            child: TabBarView(
              children: widget.items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return SingleChildScrollView(
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
        ].separatedBy(
          CustomTheme().vGap('lg'),
        ),
      ),
    );
  }
}
