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
  final onSeeAll;

  const WoListComp(
      {super.key,
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
      this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final bool isSingleSearchResult =
        searchController.text.isNotEmpty && items.length == 1;

    const double listHeight = 280;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Work Order',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: onSeeAll,
                    child: const Row(
                      children: [
                        Text(
                          'Lihat semua ',
                          style: TextStyle(),
                        ),
                        Icon(Icons.chevron_right_outlined)
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Row(
            //   children: [
            //     Expanded(
            //       flex: 5,
            //       child: Container(
            //         decoration: CustomTheme().cardTheme(),
            //         child: TextField(
            //           controller: searchController,
            //           textInputAction: TextInputAction.search,
            //           decoration: InputDecoration(
            //             hintText: 'Cari...',
            //             prefixIcon: const Icon(Icons.search),
            //             suffixIcon: searchController.text.isNotEmpty
            //                 ? IconButton(
            //                     onPressed: onClearSearch,
            //                     icon: const Icon(Icons.close),
            //                   )
            //                 : null,
            //             border: InputBorder.none,
            //             contentPadding: const EdgeInsets.all(12),
            //           ),
            //           onChanged: onSearchChanged,
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 8),
            //     Expanded(
            //       child: InkWell(
            //         onTap: showFilter,
            //         child: Container(
            //           decoration: CustomTheme().cardTheme(),
            //           padding: const EdgeInsets.all(12),
            //           child: const Icon(Icons.tune_outlined, size: 18),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 8),
            SizedBox(
              height: loading || items.isEmpty ? 120 : listHeight,
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : items.isEmpty
                      ? const NoData()
                      : ListView.builder(
                          controller: scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: items.length + (loadingMore ? 1 : 0),
                          padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return SizedBox(
                                width: 280,
                                child: _buildWoListCard(items[index],
                                    isLast: index == items.length - 1));
                          },
                        ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildWoListCard(WoListItem item, {isLast = false}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 0, isLast ? 12 : 0, 12),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.woNo,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusBadge(item.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Tanggal',
                    formatDate(DateTime.parse(item.date)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(
                    'Qty WO',
                    formatNumber(item.woQty),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Total Sortir',
                    formatNumber(item.sortingQty),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(
                    'Total Packing',
                    formatNumber(item.packingQty),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Berat 1 Lusin',
                    formatNumber(item.weightPerDozen),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(
                    'Gramasi',
                    formatNumber(item.gsm),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Berat Grade A',
                    formatNumber(item.gradeAWeight),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(
                    'Total Berat',
                    formatNumber(item.weight),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          (value),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _getStatusColor(status),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
      case 'completed':
        return Colors.green;
      case 'diproses':
      case 'in_progress':
        return Colors.orange;
      case 'menunggu diproses':
      case 'waiting':
        return Colors.blue;
      case 'dilewati':
      case 'skipped':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
