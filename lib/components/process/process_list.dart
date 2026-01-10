import 'package:flutter/material.dart';
import 'package:textile_tracking/components/process/custom_search_bar.dart';
import 'package:textile_tracking/components/master/text/no_access.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';

class ProcessList<T> extends StatefulWidget {
  final Widget Function(T item) itemBuilder;
  final void Function(BuildContext context, T item)? onItemTap;
  final Future<List<T>> Function(Map<String, String> params) fetchData;
  final Widget? filterWidget;
  final dataList;
  final handleRefetch;
  final handleLoadMore;
  final handleSearch;
  final firstLoading;
  final hasMore;
  final isFiltered;
  final canRead;
  final isLoadMore;

  const ProcessList(
      {super.key,
      required this.itemBuilder,
      this.onItemTap,
      required this.fetchData,
      this.filterWidget,
      this.handleRefetch,
      this.handleLoadMore,
      this.handleSearch,
      this.dataList,
      this.firstLoading,
      this.hasMore,
      this.isFiltered,
      this.canRead,
      this.isLoadMore});

  @override
  State<ProcessList<T>> createState() => _ProcessListState<T>();
}

class _ProcessListState<T> extends State<ProcessList<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openFilter() {
    if (widget.filterWidget != null) {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enableDrag: true,
        isDismissible: true,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return widget.filterWidget!;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.canRead) {
      return NoAccess();
    }

    return Column(
      children: [
        CustomSearchBar(
          handleSearchChange: widget.handleSearch,
          showFilter: _openFilter,
          isFiltered: widget.isFiltered,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => widget.handleRefetch(),
            child: widget.dataList.isEmpty
                ? NoData()
                : widget.firstLoading == true
                    ? Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        controller: _scrollController,
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: CustomTheme().padding('content'),
                        separatorBuilder: (context, index) =>
                            CustomTheme().vGap('2xl'),
                        itemCount: widget.hasMore
                            ? widget.dataList.length + 1
                            : widget.dataList.length,
                        itemBuilder: (context, index) {
                          if (index >= widget.dataList.length) {
                            if (!widget.isLoadMore) {
                              Future.delayed(Duration.zero, () {
                                widget.handleLoadMore();
                              });
                            }

                            return const SizedBox.shrink();
                          }

                          final item = widget.dataList[index];
                          return GestureDetector(
                            onTap: () => widget.onItemTap?.call(context, item),
                            child: widget.itemBuilder(item),
                          );
                        },
                      ),
          ),
        ),
      ],
    );
  }
}
