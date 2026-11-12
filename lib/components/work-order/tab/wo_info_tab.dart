import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/work-order/list/list_info.dart';
import 'package:textile_tracking/components/work-order/tab/attachment_tab.dart';
import 'package:textile_tracking/components/work-order/tab/item_tab.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WoInfoTab extends StatefulWidget {
  final data;
  final isLoading;

  const WoInfoTab({super.key, this.data, this.isLoading});

  @override
  State<WoInfoTab> createState() => _WoInfoTabState();
}

class _WoInfoTabState extends State<WoInfoTab> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (widget.data.isEmpty) {
      return NoData();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final items = List<Map<String, dynamic>>.from(
          widget.data['items'] ?? [],
        );
        final itemChanges = items
            .expand(
              (item) => List<Map<String, dynamic>>.from(
                item['item_changes'] ?? [],
              ),
            )
            .toList();

        return SingleChildScrollView(
          padding: CustomTheme().padding('content'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListInfo(
                data: widget.data,
              ),
              ItemTab(
                data: widget.data,
                withSpk: true,
              ),
              if (widget.data['packing_grade_a_stocks'] is List &&
                  (widget.data['packing_grade_a_stocks'] as List).isNotEmpty)
                _buildPackingGradeAStockSection(
                  (widget.data['packing_grade_a_stocks'] as List)
                      .whereType<Map>()
                      .map((stock) => Map<String, dynamic>.from(stock))
                      .toList(),
                ),
              if (itemChanges.isNotEmpty)
                TemplateCard(
                  title: 'Ganti Material',
                  icon: Icons.swap_horiz_outlined,
                  child: _buildMaterialChanges(itemChanges, isTablet),
                ),
              AttachmentTab(
                  existingAttachment: widget.data['attachments'] ?? [])
            ].separatedBy(CustomTheme().vGap('2xl')),
          ),
        );
      },
    );
  }

  Widget _buildPackingGradeAStockSection(
    List<Map<String, dynamic>> stocks,
  ) {
    return TemplateCard(
      title: 'Stok Grade A',
      icon: Icons.inventory_2_outlined,
      child: DefaultTabController(
        length: stocks.length,
        child: Builder(
          builder: (context) {
            final tabController = DefaultTabController.of(context);

            return AnimatedBuilder(
              animation: tabController,
              builder: (context, _) {
                final stock = stocks[tabController.index];
                final item = stock['item'];
                final itemMap = item is Map ? item : <String, dynamic>{};
                final fromPacking = stock['from_packing'];
                final usages = stock['usages'] is List
                    ? (stock['usages'] as List).whereType<Map>().toList()
                    : <Map>[];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          dividerColor: Colors.transparent,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          indicator: BoxDecoration(
                            color: Colors.blue.shade800,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          tabs: [
                            for (var index = 0; index < stocks.length; index++)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Tab(
                                  text: (() {
                                    final stockItem = stocks[index]['item'];
                                    return (stocks[index]['code'] ??
                                            (stockItem is Map
                                                ? stockItem['code']
                                                : null) ??
                                            'Item ${index + 1}')
                                        .toString();
                                  })(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon(
                        //   Icons.inventory_2_outlined,
                        //   color: Colors.blueGrey.shade600,
                        //   size: 28,
                        // ),
                        // const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (stock['code'] ?? itemMap['code'] ?? '-')
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                (itemMap['name'] ?? '-').toString(),
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${fromPacking is Map ? (fromPacking['packing_no'] ?? '-') : '-'} · '
                                'Grade A sortir ${formatNumber(stock['sorting_grade_a_qty'])} PCS · '
                                'Packing ${formatNumber(stock['packing_qty'])} PCS',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStockValue(
                            'Stok Disimpan',
                            stock['stock_qty'],
                            stock['unit_code'],
                          ),
                        ),
                        Expanded(
                          child: _buildStockValue(
                            'Stok diambil',
                            stock['used_qty'],
                            stock['unit_code'],
                          ),
                        ),
                        Expanded(
                          child: _buildStockValue(
                            'Stok tersedia',
                            stock['available_qty'],
                            stock['unit_code'],
                          ),
                        ),
                      ].separatedBy(CustomTheme().hGap('xl')),
                    ),
                    if (usages.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Divider(color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text(
                        'Digunakan di',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final cardWidth = (constraints.maxWidth - 12) / 2;

                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: usages.map((usage) {
                              final toWorkOrder = usage['to_work_order'];
                              final toPacking = usage['to_packing'];
                              final woNo = toWorkOrder is Map
                                  ? toWorkOrder['wo_no']?.toString() ?? '-'
                                  : '-';
                              final packingNo = toPacking is Map
                                  ? toPacking['packing_no']?.toString() ?? '-'
                                  : '-';

                              return SizedBox(
                                width: cardWidth,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '$woNo · $packingNo',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${formatNumber(usage['qty'])} ${stock['unit_code'] ?? ''}'
                                            .trim(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildStockValue(String label, dynamic value, dynamic unitCode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 6),
          Text(
            '${formatNumber(value)} ${unitCode ?? ''}'.trim(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialChanges(
    List<Map<String, dynamic>> itemChanges,
    bool isTablet,
  ) {
    return Column(
      children: itemChanges
          .map((change) {
            final fromMaterial = _buildChangedMaterial(
              label: 'Dari',
              code: change['from_item_code']?.toString() ?? '-',
              name: change['from_item_name']?.toString() ?? '-',
              isTablet: isTablet,
              isPrevious: true,
            );
            final toMaterial = _buildChangedMaterial(
              label: 'Menjadi',
              code: change['to_item_code']?.toString() ?? '-',
              name: change['to_item_name']?.toString() ?? '-',
              isTablet: isTablet,
            );

            return Container(
              width: double.infinity,
              padding: CustomTheme().padding('card'),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: isTablet
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: fromMaterial),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(Icons.arrow_forward, color: Colors.grey),
                        ),
                        Expanded(child: toMaterial),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        fromMaterial,
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Icon(Icons.arrow_downward, color: Colors.grey),
                        ),
                        toMaterial,
                      ],
                    ),
            );
          })
          .toList()
          .separatedBy(CustomTheme().vGap('lg')),
    );
  }

  Widget _buildChangedMaterial({
    required String label,
    required String code,
    required String name,
    required bool isTablet,
    bool isPrevious = false,
  }) {
    final textDecoration =
        isPrevious ? TextDecoration.lineThrough : TextDecoration.none;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 12 : 11,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          code,
          style: TextStyle(
            fontSize: isTablet ? 14 : 13,
            fontWeight: FontWeight.w600,
            color: isPrevious ? Colors.grey.shade600 : Colors.grey.shade800,
            decoration: textDecoration,
          ),
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: isTablet ? 14 : 13,
            color: isPrevious ? Colors.grey.shade500 : Colors.grey.shade700,
            decoration: textDecoration,
          ),
        ),
      ].separatedBy(CustomTheme().vGap('sm')),
    );
  }
}
