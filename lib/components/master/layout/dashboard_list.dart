import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/custom_search_bar.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class DashboardList<T> extends StatefulWidget {
  final BaseCrudService<T> service;
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
  final isLoadMore;

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
      this.isFetching,
      this.isLoadMore});

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
    MediaQuery.of(context).orientation == Orientation.portrait;

    if (widget.firstLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.dataList.isEmpty) {
      return const NoData();
    }

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
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= widget.dataList.length) {
                        if (!widget.isLoadMore) {
                          Future.delayed(Duration.zero, () {
                            widget.handleLoadMore();
                          });
                        }

                        return const SizedBox.shrink();
                      }

                      final item = widget.dataList[index];
                      return Padding(
                        padding: CustomTheme().padding('process-content'),
                        child: GestureDetector(
                          onTap: () => widget.onItemTap?.call(context, item),
                          child: widget.itemBuilder(item),
                        ),
                      );
                    },
                    childCount: widget.hasMore
                        ? widget.dataList.length + 1
                        : widget.dataList.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
