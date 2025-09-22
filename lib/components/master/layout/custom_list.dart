import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/button/custom_floating_button.dart';
import 'package:production_tracking/components/master/layout/custom_search_bar.dart';
import 'package:production_tracking/helpers/service/base_service.dart';

class CustomList<T> extends StatefulWidget {
  final BaseService<T> service;
  final String searchQuery;
  final bool? canUpdate;
  final bool? canCreate;
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

  const CustomList(
      {super.key,
      required this.service,
      required this.searchQuery,
      required this.itemBuilder,
      this.canUpdate = false,
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
      this.isFiltered});

  @override
  State<CustomList<T>> createState() => _CustomListState<T>();
}

class _CustomListState<T> extends State<CustomList<T>> {
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
    return Column(
      children: [
        CustomSearchBar(
          handleSearchChange: widget.handleSearch,
          showFilter: _openFilter,
          isFiltered: widget.isFiltered,
        ),
        Expanded(
          child: widget.firstLoading
              ? const Center(child: CircularProgressIndicator())
              : widget.dataList.isEmpty
                  ? const Center(child: Text('No Data'))
                  : Stack(
                      children: [
                        RefreshIndicator(
                          onRefresh: () async {
                            widget.handleRefetch();
                          },
                          child: ListView.separated(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(8),
                            itemCount: widget.dataList.length +
                                (widget.hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == widget.dataList.length) {
                                // Show loader only if hasMore = true
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }

                              final item = widget.dataList[index];
                              return GestureDetector(
                                onTap: () =>
                                    widget.onItemTap?.call(context, item),
                                child: widget.itemBuilder(item),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                          ),
                        ),
                        if (widget.canCreate!)
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: CustomFloatingButton(
                              onPressed: () =>
                                  widget.onForm?.call(context, null),
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                          ),
                      ],
                    ),
        ),
      ],
    );
  }
}
