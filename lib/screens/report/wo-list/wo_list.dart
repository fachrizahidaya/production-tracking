import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/models/report/wo_list.dart';

class WoListComp extends StatelessWidget {
  final List<WoListItem> items;
  final bool loading;
  final bool loadingMore;
  final TextEditingController searchController;
  final ScrollController scrollController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final VoidCallback showFilter;
  final dynamic formatDate;
  final dynamic formatNumber;

  const WoListComp({
    super.key,
    required this.items,
    required this.loading,
    required this.loadingMore,
    required this.searchController,
    required this.scrollController,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.showFilter,
    required this.formatDate,
    required this.formatNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Work Order',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: CustomTheme().cardTheme(),
                    child: TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Cari...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: onClearSearch,
                                icon: const Icon(Icons.close),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      onChanged: onSearchChanged,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: showFilter,
                    child: Container(
                      decoration: CustomTheme().cardTheme(),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(Icons.tune_outlined, size: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: loading || items.isEmpty
                  ? 120
                  : (items.length.clamp(1, 3).toDouble() * 106) + 6,
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : items.isEmpty
                      ? const NoData()
                      : ListView.builder(
                          controller: scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: items.length + (loadingMore ? 1 : 0),
                          padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                          itemBuilder: (context, index) {
                            if (index >= items.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            return _buildWoListCard(items[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWoListCard(WoListItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.woNo,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildTextRow(
              'Tanggal',
              formatDate(DateTime.parse(item.date)),
            ),
            const SizedBox(height: 8),
            _buildTextRow('Status', item.status),
            const SizedBox(height: 8),
            _buildNumberRow('Qty WO', item.woQty),
            const SizedBox(height: 8),
            _buildNumberRow('Total Sortir', item.sortingQty),
            const SizedBox(height: 8),
            _buildNumberRow('Total Packing', item.packingQty),
            const SizedBox(height: 8),
            _buildNumberRow('Berat 1 Lusin', item.weightPerDozen),
            const SizedBox(height: 8),
            _buildNumberRow('Gramasi', item.gsm),
            const SizedBox(height: 8),
            _buildNumberRow('Berat Grade A', item.gradeAWeight),
            const SizedBox(height: 8),
            _buildNumberRow('Total Berat', item.weight),
          ],
        ),
      ),
    );
  }

  Widget _buildTextRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildNumberRow(String title, num value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Row(
          children: [
            Text(
              formatNumber(value),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 2),
            const Text('PCS'),
          ],
        ),
      ],
    );
  }
}
