import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/custom_search_bar.dart';
import 'package:textile_tracking/components/master/card/item_process.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class ProcessList<T> extends StatefulWidget {
  final BaseCrudService<T> service;
  final String searchQuery;

  final Future<void> Function(
    BuildContext context,
    T? currentItem,
  )? onForm;

  final void Function(
    BuildContext context,
    T item,
  )? onItemTap;

  final Future<List<T>> Function(
    Map<String, String> params,
  ) fetchData;

  final Widget? filterWidget;

  final dynamic dataList;

  final VoidCallback? handleRefetch;
  final VoidCallback? handleLoadMore;
  final handleSearch;

  final bool firstLoading;
  final bool hasMore;
  final bool isFiltered;
  final bool isFetching;
  final bool isLoadMore;

  const ProcessList({
    super.key,
    required this.service,
    required this.searchQuery,
    required this.fetchData,
    this.onForm,
    this.onItemTap,
    this.filterWidget,
    this.dataList,
    this.handleRefetch,
    this.handleLoadMore,
    this.handleSearch,
    this.firstLoading = false,
    this.hasMore = false,
    this.isFiltered = false,
    this.isFetching = false,
    this.isLoadMore = false,
  });

  @override
  State<ProcessList<T>> createState() => _ProcessListState<T>();
}

class _ProcessListState<T> extends State<ProcessList<T>> {
  int? _expandedIndex;

  void _openFilter() {
    if (widget.filterWidget == null) return;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
        return widget.filterWidget!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> data =
        widget.dataList is List ? List<dynamic>.from(widget.dataList) : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        /// SEARCH + FILTER
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomSearchBar(
                handleSearchChange: widget.handleSearch,
                showFilter: _openFilter,
                isFiltered: widget.isFiltered,
                withRefresh: true,
                handleRefetch: widget.handleRefetch,
              ),
              const Divider(height: 1),
            ],
          ),
        ),

        /// LOADING
        if (widget.firstLoading)
          Padding(
            padding: CustomTheme().padding('content'),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )

        /// EMPTY
        else if (data.isEmpty)
          Padding(
            padding: CustomTheme().padding('content'),
            child: const NoData(),
          )

        /// DATA
        else
          Padding(
            padding: CustomTheme().padding('content'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: data.asMap().entries.map<Widget>((entry) {
                final index = entry.key;
                final item = entry.value;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == data.length - 1 ? 0 : 24,
                  ),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    child: ItemProcess(
                      item: item,
                      showTimeline: true,
                      isExpanded: _expandedIndex == index,
                      onExpandChanged: (expanded) {
                        if (!mounted) return;

                        setState(() {
                          _expandedIndex = expanded ? index : null;
                        });
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

        /// LOAD MORE
        if (widget.isLoadMore)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),

        if (widget.hasMore && !widget.firstLoading)
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: widget.isLoadMore ? null : widget.handleLoadMore,
                child: const Text('Muat Lebih Banyak'),
              ),
            ),
          ),
      ],
    );
  }
}
