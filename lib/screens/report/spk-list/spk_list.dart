import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/models/report/spk_list.dart';

class SpkListComp extends StatelessWidget {
  final List<SpkListItem> items;
  final bool loading;
  final bool loadingMore;
  final TextEditingController searchController;
  final ScrollController scrollController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final dynamic formatDate;
  final dynamic formatNumber;
  final onSeeAll;

  const SpkListComp(
      {super.key,
      required this.items,
      required this.loading,
      required this.loadingMore,
      required this.searchController,
      required this.scrollController,
      required this.onSearchChanged,
      required this.onClearSearch,
      required this.formatDate,
      required this.formatNumber,
      this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).width >= 600;
    final listHeight = isTablet ? 320.0 : 350.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                    'SPK',
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
            // Container(
            //   decoration: CustomTheme().cardTheme(),
            //   child: TextField(
            //     controller: searchController,
            //     textInputAction: TextInputAction.search,
            //     decoration: InputDecoration(
            //       hintText: 'Cari...',
            //       prefixIcon: const Icon(Icons.search),
            //       suffixIcon: searchController.text.isNotEmpty
            //           ? IconButton(
            //               onPressed: onClearSearch,
            //               icon: const Icon(Icons.close),
            //             )
            //           : null,
            //       border: InputBorder.none,
            //       contentPadding: const EdgeInsets.all(12),
            //     ),
            //     onChanged: onSearchChanged,
            //   ),
            // ),
            // const SizedBox(height: 8),
            SizedBox(
              height: loading || items.isEmpty ? 120 : listHeight,
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : items.isEmpty
                      ? NoData()
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final cardWidth =
                                (constraints.maxWidth * (isTablet ? 0.65 : 0.8))
                                    .clamp(
                                      isTablet ? 440.0 : 260.0,
                                      isTablet ? 520.0 : 300.0,
                                    )
                                    .toDouble();

                            return ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context)
                                  .copyWith(scrollbars: false),
                              child: ListView.builder(
                                controller: scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: items.length + (loadingMore ? 1 : 0),
                                padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  if (index >= items.length) {
                                    return SizedBox(
                                      width: cardWidth,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  return SizedBox(
                                    width: cardWidth,
                                    child: _buildSpkListCard(
                                      items[index],
                                      isTablet: isTablet,
                                      isLast: index == items.length - 1,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildSpkListCard(
    SpkListItem item, {
    required bool isTablet,
    isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 0, isLast ? 16 : 0, 12),
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
                    item.spkNo,
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
            const SizedBox(height: 14),
            ..._buildInfoRows(
              [
                MapEntry(
                  'Tanggal',
                  formatDate(DateTime.parse(item.date)),
                ),
                MapEntry('Qty WO', '${formatNumber(item.woQty)} PCS'),
                MapEntry(
                  'Total Sortir',
                  '${formatNumber(item.sortingQty)} PCS',
                ),
                MapEntry(
                  'Total Packing',
                  '${formatNumber(item.packingQty)} PCS',
                ),
                MapEntry('Grade A', '${formatNumber(item.gradeA)} PCS'),
                MapEntry('Grade B', '${formatNumber(item.gradeB)} PCS'),
                MapEntry('Grade BS', '${formatNumber(item.gradeBs)} PCS'),
                MapEntry(
                  'Berat 1 Lusin',
                  '${formatNumber(item.dozenWeight)} KG',
                ),
                MapEntry(
                  'Berat Grade A',
                  '${formatNumber(item.gradeAWeight)} KG',
                ),
                MapEntry('Total Berat', '${formatNumber(item.weight)} KG'),
              ],
              isTablet ? 3 : 2,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInfoRows(
    List<MapEntry<String, String>> items,
    int columnCount,
  ) {
    final rows = <Widget>[];

    for (var start = 0; start < items.length; start += columnCount) {
      if (rows.isNotEmpty) {
        rows.add(const SizedBox(height: 14));
      }

      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(columnCount * 2 - 1, (position) {
            if (position.isOdd) {
              return const SizedBox(width: 16);
            }

            final index = start + (position ~/ 2);
            return Expanded(
              child: index < items.length
                  ? _buildInfo(items[index].key, items[index].value)
                  : const SizedBox.shrink(),
            );
          }),
        ),
      );
    }

    return rows;
  }

  Widget _buildInfo(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);

    return Container(
      constraints: const BoxConstraints(maxWidth: 130),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
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
