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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    final isTablet = MediaQuery.sizeOf(context).width >= 600;
    final listHeight = isTablet ? 250.0 : 280.0;
=======
    const double listHeight = 280;
>>>>>>> 5ad2d445 (feat: temporarily)
=======
    final isTablet = MediaQuery.sizeOf(context).width >= 600;
    final listHeight = isTablet ? 250.0 : 280.0;
>>>>>>> 5ea4dfbf (fix: responsive size for report)

=======
>>>>>>> ad8e0407 (fix: laporan)
=======
    final bool isSingleSearchResult =
        searchController.text.isNotEmpty && items.length == 1;

    const double listHeight = 280;

>>>>>>> 65038198 (feat:)
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
<<<<<<< HEAD
            const Text(
              'Work Order',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
<<<<<<< HEAD
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
<<<<<<< HEAD
<<<<<<< HEAD
                  ? const Center(child: CircularProgressIndicator())
                  : items.isEmpty
                      ? const NoData()
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
                                    child: _buildWoListCard(
                                      items[index],
                                      isTablet: isTablet,
                                      isLast: index == items.length - 1,
                                    ),
                                  );
                                },
                              ),
                            );
=======
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
                                width: 360,
                                child: _buildWoListCard(items[index],
                                    isLast: index == items.length - 1));
>>>>>>> 5ad2d445 (feat: temporarily)
=======
                  ? const Center(child: CircularProgressIndicator())
                  : items.isEmpty
                      ? const NoData()
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
                                    child: _buildWoListCard(
                                      items[index],
                                      isTablet: isTablet,
                                      isLast: index == items.length - 1,
                                    ),
                                  );
                                },
                              ),
                            );
>>>>>>> 2261585c (fix: report axis horizontal)
                          },
                        ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 5ea4dfbf (fix: responsive size for report)
  Widget _buildWoListCard(
    WoListItem item, {
    required bool isTablet,
    isLast = false,
  }) {
<<<<<<< HEAD
=======
  Widget _buildWoListCard(WoListItem item, {isLast = false}) {
>>>>>>> 5ad2d445 (feat: temporarily)
=======
>>>>>>> 5ea4dfbf (fix: responsive size for report)
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 0, isLast ? 16 : 0, 12),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
=======
>>>>>>> ad8e0407 (fix: laporan)
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
=======
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
>>>>>>> 65038198 (feat:)
            ),
<<<<<<< HEAD
            const SizedBox(height: 12),
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 5ea4dfbf (fix: responsive size for report)
            ..._buildInfoRows(
              [
                MapEntry(
                  'Tanggal',
                  formatDate(DateTime.parse(item.date)),
<<<<<<< HEAD
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
                MapEntry(
                  'Berat 1 Lusin',
                  '${formatNumber(item.weightPerDozen)} KG',
                ),
                MapEntry('Gramasi', '${formatNumber(item.gsm)} GSM'),
                MapEntry(
                  'Berat Grade A',
                  '${formatNumber(item.gradeAWeight)} KG',
                ),
                MapEntry('Total Berat', '${formatNumber(item.weight)} KG'),
              ],
              isTablet ? 3 : 2,
=======
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Tanggal',
                    formatDate(DateTime.parse(item.date)),
                  ),
=======
>>>>>>> 5ea4dfbf (fix: responsive size for report)
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
                MapEntry(
                  'Berat 1 Lusin',
                  '${formatNumber(item.weightPerDozen)} KG',
                ),
                MapEntry('Gramasi', '${formatNumber(item.gsm)} GSM'),
                MapEntry(
                  'Berat Grade A',
                  '${formatNumber(item.gradeAWeight)} KG',
                ),
                MapEntry('Total Berat', '${formatNumber(item.weight)} KG'),
              ],
<<<<<<< HEAD
>>>>>>> 5ad2d445 (feat: temporarily)
=======
              isTablet ? 3 : 2,
>>>>>>> 5ea4dfbf (fix: responsive size for report)
=======
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
>>>>>>> ad8e0407 (fix: laporan)
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 5ea4dfbf (fix: responsive size for report)
  List<Widget> _buildInfoRows(
    List<MapEntry<String, String>> items,
    int columnCount,
  ) {
    final rows = <Widget>[];

    for (var start = 0; start < items.length; start += columnCount) {
      if (rows.isNotEmpty) {
        rows.add(const SizedBox(height: 12));
      }

      rows.add(
        Row(
=======
  Widget _buildWoListCard(WoListItem item) {
=======
  Widget _buildWoListCard(WoListItem item, {isLast = false}) {
>>>>>>> 65038198 (feat:)
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 0, isLast ? 12 : 0, 12),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        padding: EdgeInsets.all(12),
        child: Column(
>>>>>>> ad8e0407 (fix: laporan)
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

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 5ad2d445 (feat: temporarily)
=======
>>>>>>> 5ea4dfbf (fix: responsive size for report)
  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
=======
  Widget _buildTextRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
>>>>>>> ad8e0407 (fix: laporan)
=======
  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
>>>>>>> 65038198 (feat:)
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

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 65038198 (feat:)
  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        color: _getStatusColor(status).withValues(alpha: 0.1),
=======
        color: _getStatusColor(status).withOpacity(0.1),
>>>>>>> 5ad2d445 (feat: temporarily)
=======
        color: _getStatusColor(status).withValues(alpha: 0.1),
>>>>>>> 5ea4dfbf (fix: responsive size for report)
=======
        color: _getStatusColor(status).withOpacity(0.1),
>>>>>>> 65038198 (feat:)
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _getStatusColor(status),
<<<<<<< HEAD
=======
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
>>>>>>> ad8e0407 (fix: laporan)
=======
>>>>>>> 65038198 (feat:)
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
