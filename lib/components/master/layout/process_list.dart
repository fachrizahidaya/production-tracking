import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/custom_floating_button.dart';
import 'package:textile_tracking/components/master/layout/custom_search_bar.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class ProcessList<T> extends StatefulWidget {
  final BaseCrudService<T> service;
  final String searchQuery;
  final canCreate;
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

  const ProcessList(
      {super.key,
      required this.service,
      required this.searchQuery,
      required this.itemBuilder,
      this.canCreate,
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
      this.showActions});

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
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Column(
      children: [
        CustomSearchBar(
          handleSearchChange: widget.handleSearch,
          showFilter: _openFilter,
          isFiltered: widget.isFiltered,
        ),
        Expanded(
          child: !widget.canRead
              ? const Center(child: Text('No Access'))
              : widget.firstLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                      children: [
                        if (widget.dataList.isEmpty)
                          const Center(child: NoData())
                        else
                          RefreshIndicator(
                            onRefresh: () async {
                              widget.handleRefetch();
                            },
                            child: ListView.builder(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(8),
                              itemCount: widget.dataList.length +
                                  (widget.hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (!widget.canRead) {
                                  return const Center(child: Text('No Access'));
                                } else if (index == widget.dataList.length) {
                                  if (widget.hasMore &&
                                      widget.dataList.isNotEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                }

                                final item = widget.dataList[index];
                                return GestureDetector(
                                  onTap: () =>
                                      widget.onItemTap?.call(context, item),
                                  child: widget.itemBuilder(item),
                                );
                              },
                            ),
                          ),
                        if (!isPortrait && widget.canCreate)
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: CustomFloatingButton(
                              onPressed: widget.showActions,
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 256,
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
