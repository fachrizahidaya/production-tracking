import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/layout/custom_search_bar.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';

class DashboardList<T> extends StatefulWidget {
  final BaseService<T> service;
  final String searchQuery;
  final bool? canCreate;
  final bool? canDelete;
  final Widget Function(T item) itemBuilder;
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

  const DashboardList(
      {super.key,
      required this.service,
      required this.searchQuery,
      required this.itemBuilder,
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
      this.isFetching});

  @override
  State<DashboardList<T>> createState() => _DashboardListState<T>();
}

class _DashboardListState<T> extends State<DashboardList<T>> {
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
          borderRadius: BorderRadius.circular(4),
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
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return CustomCard(
      child: Padding(
        padding: PaddingColumn.screen,
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
            Expanded(
              child: widget.firstLoading
                  ? Center(child: CircularProgressIndicator())
                  : widget.dataList.isEmpty
                      ? isPortrait
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: Center(child: NoData()))
                          : Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      child: Center(child: NoData())),
                                ),
                              ],
                            )
                      : (!isPortrait
                          ? Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    itemCount: widget.dataList.length +
                                        (widget.hasMore ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index == widget.dataList.length) {
                                        return widget.hasMore
                                            ? Padding(
                                                padding: EdgeInsets.all(16),
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              )
                                            : SizedBox.shrink();
                                      }

                                      final item = widget.dataList[index];
                                      return GestureDetector(
                                        onTap: () => widget.onItemTap
                                            ?.call(context, item),
                                        child: widget.itemBuilder(item),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: widget.dataList.length +
                                  (widget.hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == widget.dataList.length) {
                                  return widget.hasMore
                                      ? Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        )
                                      : SizedBox.shrink();
                                }

                                final item = widget.dataList[index];
                                return GestureDetector(
                                  onTap: () =>
                                      widget.onItemTap?.call(context, item),
                                  child: widget.itemBuilder(item),
                                );
                              },
                            )),
            ),
          ],
        ),
      ),
    );
  }
}
