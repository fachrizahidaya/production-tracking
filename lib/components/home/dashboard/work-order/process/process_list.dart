import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/custom_search_bar.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/card/item_process.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class ProcessList<T> extends StatefulWidget {
  final BaseCrudService<T> service;
  final String searchQuery;
  final bool? canCreate;
  final bool? canDelete;
  final Future<void> Function(BuildContext context, T? currentItem)? onForm;
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
  final showActions;
  final isFetching;
  final isLoadMore;

  const ProcessList(
      {super.key,
      required this.service,
      required this.searchQuery,
      this.canCreate = false,
      this.onForm,
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
      this.canDelete,
      this.showActions,
      this.isFetching,
      this.isLoadMore});

  @override
  State<ProcessList<T>> createState() => _ProcessListState<T>();
}

class _ProcessListState<T> extends State<ProcessList<T>> {
  final ScrollController _scrollController = ScrollController();
  double minHeight = 640;
  double maxHeight = 1820;
  bool hasExpandedItem = false;
  int? _expandedIndex;

  double get _currentHeight => _expandedIndex != null ? maxHeight : minHeight;

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
          borderRadius: BorderRadius.circular(12),
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
    MediaQuery.of(context).orientation == Orientation.portrait;

    return CustomCard(
      child: Column(
        children: [
          CustomSearchBar(
            handleSearchChange: widget.handleSearch,
            showFilter: _openFilter,
            isFiltered: widget.isFiltered,
            withRefresh: true,
            handleRefetch: widget.handleRefetch,
          ),
          Divider(),
          widget.dataList.isEmpty
              ? NoData()
              : widget.firstLoading
                  ? Center(child: CircularProgressIndicator())
                  : AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: _currentHeight,
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification is OverscrollNotification) {
                            if (notification.metrics.axis == Axis.horizontal) {
                              return true;
                            }
                            return false;
                          }
                          return true;
                        },
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              CustomTheme().hGap('xl'),
                          itemCount: widget.hasMore
                              ? widget.dataList.length + 1
                              : widget.dataList.length,
                          itemBuilder: (context, index) {
                            if (index >= widget.dataList.length) {
                              if (!widget.isLoadMore) {
                                Future.microtask(widget.handleLoadMore);
                              }
                              return const SizedBox(width: 80);
                            }

                            final item = widget.dataList[index];
                            return ItemProcess(
                              item: item,
                              showTimeline: true,
                              isExpanded: _expandedIndex == index,
                              onExpandChanged: (expanded) {
                                setState(() {
                                  _expandedIndex = expanded ? index : null;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    )
        ],
      ),
    );
  }
}
