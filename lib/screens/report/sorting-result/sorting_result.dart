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
    const double listHeight = 180;

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
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : widget.items.isEmpty
                        ? NoData()
                        : ListView.builder(
                            controller: widget.scrollController,
                            scrollDirection: Axis.horizontal,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: widget.items.length,
                            padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 360,
                                child: _buildSortingResultCard(
                                    widget.items[index],
                                    isLast: index == widget.items?.length - 1),
                              );
                            },
                          ),
              ),
              const SizedBox(height: 4),
            ],
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
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSortingInfo(
                    'Grade B',
                    '${widget.formatNumber(item.gradeB)} PCS',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSortingInfo(
                    'Grade BS',
                    '${widget.formatNumber(item.gradeBS)} PCS',
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
                    '${widget.formatNumber(item.totalQty)} PCS',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSortingInfo(
                    'Qty WO',
                    '${widget.formatNumber(item.woQty)} PCS',
                  ),
                ),
                Expanded(
                  child: _buildSortingInfo(
                    'Selisih',
                    '${widget.formatNumber(item.diff)}',
                  ),
                ),
              ],
            ),
          ],
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
