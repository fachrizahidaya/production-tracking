import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ProcessItemsQtySection extends StatefulWidget {
  final String label;
  final List<dynamic> items;
  final Function(int index, String key, dynamic value) onChange;
  final data;
  final handleItemQtyWarning;

  const ProcessItemsQtySection(
      {super.key,
      required this.label,
      required this.items,
      required this.onChange,
      this.data,
      this.handleItemQtyWarning});

  @override
  State<ProcessItemsQtySection> createState() => _ProcessItemsQtySectionState();
}

class _ProcessItemsQtySectionState extends State<ProcessItemsQtySection> {
  final Map<int, TextEditingController> _qtyControllers = {};
  final Map<int, String?> _qtyWarnings = {};

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];

      _qtyControllers[i] = TextEditingController(
        text: item['qty']?.toString() ?? '0',
      );

      _qtyWarnings[i] = _validateItemQty(i, item['qty']);
    }
  }

  @override
  void dispose() {
    for (final controller in _qtyControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0;

    if (value is num) {
      return value.toDouble();
    }

    final valueString = value.toString().trim();

    if (valueString.isEmpty) {
      return 0;
    }

    return double.tryParse(valueString.replaceAll(',', '.')) ?? 0;
  }

  Map<String, dynamic>? _getWorkOrderItem(
    Map<String, dynamic> item,
  ) {
    final woItems = widget.data;

    if (woItems == null || woItems is! List) {
      return null;
    }

    final woItemId = item['wo_item_id'];
    final itemCode = item['finished_product']?['code'];

    for (final raw in woItems) {
      if (raw is! Map) continue;

      final woItem = Map<String, dynamic>.from(raw);

      if (woItem['id'].toString() == woItemId?.toString() &&
          woItem['item_code'].toString() == itemCode?.toString()) {
        return woItem;
      }
    }

    return null;
  }

  String? _validateItemQty(
    int index,
    dynamic inputValue,
  ) {
    if (widget.label != 'Cross Cutting' && widget.label != 'Sewing') {
      return null;
    }

    if (index >= widget.items.length) {
      return null;
    }

    final item = widget.items[index];

    final woItem = _getWorkOrderItem(item);

    if (woItem == null) {
      return null;
    }

    final referenceQty = _toDouble(woItem['qty']);
    final inputQty = _toDouble(inputValue);

    if (referenceQty <= 0) {
      return null;
    }

    final lowerLimit = referenceQty * 0.90;
    final upperLimit = referenceQty * 1.10;

    if (inputQty < lowerLimit || inputQty > upperLimit) {
      final differencePercent =
          ((inputQty - referenceQty) / referenceQty) * 100;

      return 'Qty ${inputQty < referenceQty ? 'kurang' : 'lebih'} '
          '${differencePercent.abs().toStringAsFixed(2)}% '
          '(Batas: ${lowerLimit.toStringAsFixed(0)} – '
          '${upperLimit.toStringAsFixed(0)})';
    }

    return null;
  }

  bool get _hasWarning {
    return _qtyWarnings.values.any(
      (warning) => warning != null && warning!.isNotEmpty,
    );
  }

  void _handleQty(
    int index,
    String value,
  ) {
    final safeValue = value.toString().trim().isEmpty ? '0' : value.toString();

    final warning = _validateItemQty(
      index,
      safeValue,
    );

    setState(() {
      _qtyWarnings[index] = warning;
    });

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
            Expanded(
              child: Container(
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
                      semiFinished?['code'] ?? '-',
                    ),
                    Text(
                      semiFinished?['name'] ?? '-',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Finished Product
            Expanded(
              child: Container(
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
            ),

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
            label: 'Qty Hasil ${widget.label} (PCS)',
            controller: _qtyControllers[index],
            initialValue: item['qty']?.toString() ?? '0',
            req: false,
            isNumber: true,
            isSorting: true,
            handleChange: (value) => _handleQty(
              index,
              value,
            ),
          ),
        ),
        if (_qtyWarnings[index] != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.orange.shade200,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _qtyWarnings[index]!,
                    style: TextStyle(
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
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

    /// SINGLE ITEM
    if (widget.items.length == 1) {
      return Expanded(
        child: TemplateCard(
          title: 'Qty Produk',
          icon: Icons.numbers_outlined,
          child: _buildItemContent(
            context,
            0,
            widget.items.first,
          ),
        ),
      );
    }

    /// MULTIPLE ITEM
    return DefaultTabController(
      length: widget.items.length,
      child: Expanded(
        child: TemplateCard(
          title: 'Qty per Produk',
          icon: Icons.numbers_outlined,
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
            ].separatedBy(
              CustomTheme().vGap('lg'),
            ),
          ),
        ),
      ),
    );
  }
}
