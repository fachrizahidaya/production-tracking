// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/models/report/sorting_result.dart';

class SortingResultComp extends StatefulWidget {
  final formatNumber;
  final items;
  final loading;
  final searchController;
  final scrollController;
  final search;
  final loadResult;
  final showFilter;
  final onSearchChaged;
  final onClearSearch;
  final onSeeAll;

  const SortingResultComp(
      {super.key,
      this.formatNumber,
      this.items,
      this.loading,
      this.searchController,
      this.search,
      this.loadResult,
      this.scrollController,
      this.showFilter,
      this.onSearchChaged,
      this.onClearSearch,
      this.onSeeAll});

  @override
  State<SortingResultComp> createState() => _SortingResultCompState();
}

class _SortingResultCompState extends State<SortingResultComp> {
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    final isTablet = MediaQuery.sizeOf(context).width >= 600;
    final listHeight = isTablet ? 210.0 : 200.0;
=======
    const double listHeight = 180;
>>>>>>> 5ad2d445 (feat: temporarily)
=======
    final isTablet = MediaQuery.sizeOf(context).width >= 600;
    final listHeight = isTablet ? 210.0 : 200.0;
>>>>>>> 5ea4dfbf (fix: responsive size for report)

=======
>>>>>>> 0cdc2803 (feat: top bs, sorting per grade)
=======
    const double listHeight = 180;

>>>>>>> 65038198 (feat:)
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
                      'Hasil Sortir per WO',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: widget.onSeeAll,
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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 65038198 (feat:)
              ),
              SizedBox(
                height: 8,
              ),
              // Row(
              //   children: [
              //     Expanded(
              //         flex: 5,
              //         child: Container(
              //           decoration: CustomTheme().cardTheme(),
              //           child: TextField(
              //               controller: widget.searchController,
              //               textInputAction: TextInputAction.search,
              //               decoration: InputDecoration(
              //                 hintText: 'Cari...',
              //                 prefixIcon: Icon(Icons.search),
              //                 suffixIcon:
              //                     widget.searchController.text.isNotEmpty
              //                         ? IconButton(
              //                             onPressed: widget.onClearSearch,
              //                             icon: const Icon(Icons.close),
              //                           )
              //                         : null,
              //                 border: InputBorder.none,
              //                 contentPadding: EdgeInsets.all(12),
              //               ),
              //               onChanged: widget.onSearchChaged),
              //         )),
              //     SizedBox(
              //       width: 8,
              //     ),
              //     Expanded(
              //       child: InkWell(
              //         onTap: widget.showFilter,
              //         child: Container(
              //           decoration: CustomTheme().cardTheme(),
              //           child: Padding(
              //             padding: EdgeInsets.all(12),
              //             child: Icon(
              //               Icons.tune_outlined,
              //               size: 18,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 8,
              // ),
              SizedBox(
                height:
                    widget.loading || widget.items.isEmpty ? 120 : listHeight,
                child: widget.loading
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                    ? const Center(
=======
                    ? Center(
>>>>>>> 5ad2d445 (feat: temporarily)
=======
                    ? const Center(
>>>>>>> 2261585c (fix: report axis horizontal)
=======
                    ? Center(
>>>>>>> 65038198 (feat:)
                        child: CircularProgressIndicator(),
                      )
                    : widget.items.isEmpty
                        ? NoData()
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 2261585c (fix: report axis horizontal)
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              // Keep the next card partially visible so the
                              // horizontal scrolling behavior is discoverable.
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 5ea4dfbf (fix: responsive size for report)
                              final cardWidth = (constraints.maxWidth *
                                      (isTablet ? 0.65 : 0.8))
                                  .clamp(
                                    isTablet ? 440.0 : 260.0,
                                    isTablet ? 520.0 : 300.0,
                                  )
<<<<<<< HEAD
=======
                              final cardWidth = (constraints.maxWidth * 0.8)
                                  .clamp(260.0, 300.0)
>>>>>>> 2261585c (fix: report axis horizontal)
=======
>>>>>>> 5ea4dfbf (fix: responsive size for report)
                                  .toDouble();

                              return ListView.builder(
                                controller: widget.scrollController,
                                scrollDirection: Axis.horizontal,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: widget.items.length,
                                padding: const EdgeInsets.fromLTRB(0, 6, 0, 12),
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    width: cardWidth,
                                    child: _buildSortingResultCard(
                                      widget.items[index],
                                      isLast: index == widget.items.length - 1,
                                    ),
                                  );
                                },
<<<<<<< HEAD
=======
=======
>>>>>>> 65038198 (feat:)
                        : ListView.builder(
                            controller: widget.scrollController,
                            scrollDirection: Axis.horizontal,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: widget.items.length,
                            padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                            itemBuilder: (context, index) {
                              return SizedBox(
<<<<<<< HEAD
<<<<<<< HEAD
                                width: 360,
                                child: _buildSortingResultCard(
                                    widget.items[index],
                                    isLast: index == widget.items?.length - 1),
>>>>>>> 5ad2d445 (feat: temporarily)
=======
>>>>>>> 2261585c (fix: report axis horizontal)
=======
                                width: 280,
=======
                                width: 360,
>>>>>>> 183ac4f1 (fix: report)
                                child: _buildSortingResultCard(
                                    widget.items[index],
                                    isLast: index == widget.items?.length - 1),
>>>>>>> 65038198 (feat:)
                              );
                            },
                          ),
              ),
              const SizedBox(height: 4),
            ],
<<<<<<< HEAD
=======
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: widget.loading || widget.items.isEmpty
                      ? 120
                      : (widget.items.length.clamp(1, 3).toDouble() * 106) + 6,
                  child: widget.loading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : widget.items.isEmpty
                          ? NoData()
                          : ListView.builder(
                              controller: widget.scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.items.length +
                                  (widget.loadingMore ? 1 : 0),
                              padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                              itemBuilder: (context, index) {
                                if (index >= widget.items.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                final item = widget.items[index];

                                return _buildSortingResultCard(item);
                              },
                            ),
                )
              ],
            ),
>>>>>>> 0cdc2803 (feat: top bs, sorting per grade)
=======
>>>>>>> 65038198 (feat:)
          )),
    );
  }

  Widget _buildSortingResultCard(SortingResultItem item, {isLast = false}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 0, isLast ? 16 : 0, 12),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: CustomTheme().cardTheme(),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.woNo,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildSortingInfo(
                    'Grade A',
                    '${widget.formatNumber(item.gradeA)} PCS',
                  ),
<<<<<<< HEAD
                ],
              ),
<<<<<<< HEAD
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildSortingInfo(
                    'Grade A',
                    '${widget.formatNumber(item.gradeA)} PCS',
                  ),
=======
>>>>>>> 65038198 (feat:)
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSortingInfo(
                    'Grade B',
<<<<<<< HEAD
<<<<<<< HEAD
                    '${widget.formatNumber(item.gradeB)} PCS',
=======
                    widget.formatNumber(item.gradeB),
>>>>>>> 65038198 (feat:)
=======
                    '${widget.formatNumber(item.gradeB)} PCS',
>>>>>>> 183ac4f1 (fix: report)
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSortingInfo(
                    'Grade BS',
<<<<<<< HEAD
<<<<<<< HEAD
                    '${widget.formatNumber(item.gradeBS)} PCS',
=======
                    widget.formatNumber(item.gradeBS),
>>>>>>> 65038198 (feat:)
=======
                    '${widget.formatNumber(item.gradeBS)} PCS',
>>>>>>> 183ac4f1 (fix: report)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildSortingInfo(
                    'Total Qty',
<<<<<<< HEAD
<<<<<<< HEAD
                    '${widget.formatNumber(item.totalQty)} PCS',
=======
                    widget.formatNumber(item.totalQty),
>>>>>>> 65038198 (feat:)
=======
                    '${widget.formatNumber(item.totalQty)} PCS',
>>>>>>> 183ac4f1 (fix: report)
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSortingInfo(
                    'Qty WO',
<<<<<<< HEAD
<<<<<<< HEAD
                    '${widget.formatNumber(item.woQty)} PCS',
                  ),
                ),
<<<<<<< HEAD
<<<<<<< HEAD
                const SizedBox(width: 12),
=======
>>>>>>> 5ad2d445 (feat: temporarily)
=======
                const SizedBox(width: 12),
>>>>>>> 2261585c (fix: report axis horizontal)
                Expanded(
                  child: _buildSortingInfo(
                    'Selisih',
                    '${widget.formatNumber(item.diff)}',
=======
                    widget.formatNumber(item.woQty),
=======
                    '${widget.formatNumber(item.woQty)} PCS',
>>>>>>> 183ac4f1 (fix: report)
                  ),
                ),
                Expanded(
                  child: _buildSortingInfo(
                    'Selisih',
<<<<<<< HEAD
                    widget.formatNumber(item.diff),
>>>>>>> 65038198 (feat:)
=======
                    '${widget.formatNumber(item.diff)}',
>>>>>>> 183ac4f1 (fix: report)
                  ),
                ),
              ],
            ),
          ],
<<<<<<< HEAD
=======
              SizedBox(
                height: 8,
              ),
              _buildSortingRow('Grade A', item.gradeA),
              SizedBox(
                height: 8,
              ),
              _buildSortingRow(
                'Grade B',
                item.gradeB,
              ),
              SizedBox(height: 8),
              _buildSortingRow(
                'Grade BS',
                item.gradeBS,
              ),
              SizedBox(
                height: 8,
              ),
              _buildSortingRow(
                'Total Qty',
                item.totalQty,
              ),
              SizedBox(
                height: 8,
              ),
              _buildSortingRow(
                'Qty WO',
                item.woQty,
              ),
              SizedBox(
                height: 8,
              ),
              _buildSortingRow(
                'Selisih',
                item.diff,
              ),
            ],
          ),
>>>>>>> 0cdc2803 (feat: top bs, sorting per grade)
=======
>>>>>>> 65038198 (feat:)
        ),
      ),
    );
  }

  Widget _buildSortingInfo(
    String label,
    dynamic value,
  ) {
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
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
