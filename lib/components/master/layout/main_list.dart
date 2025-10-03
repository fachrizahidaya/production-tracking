import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/custom_floating_button.dart';
import 'package:textile_tracking/components/master/layout/custom_search_bar.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:textile_tracking/screens/dyeing/create_dyeing.dart';
import 'package:textile_tracking/screens/dyeing/finish_dyeing.dart';
import 'package:textile_tracking/screens/dyeing/rework_dyeing.dart';

class MainList<T> extends StatefulWidget {
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

  const MainList(
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
      this.canDelete});

  @override
  State<MainList<T>> createState() => _MainListState<T>();
}

class _MainListState<T> extends State<MainList<T>> {
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
              : !widget.canRead
                  ? const Center(child: Text('No Access'))
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
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 16),
                              ),
                            ),
                            if (widget.canCreate!)
                              Positioned(
                                bottom: 16,
                                right: 16,
                                child: CustomFloatingButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              leading: const Icon(Icons.add,
                                                  color: Colors.blue),
                                              title:
                                                  const Text("Create Dyeing"),
                                              onTap: () {
                                                Navigator.pop(
                                                    context); // close bottom sheet
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const CreateDyeing(),
                                                  ),
                                                );
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green),
                                              title:
                                                  const Text("Finish Dyeing"),
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const FinishDyeing(),
                                                  ),
                                                );
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.replay_circle_filled,
                                                  color: Colors.orange),
                                              title:
                                                  const Text("Rework Dyeing"),
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ReworkDyeing(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                  // () => Navigator.of(context)
                                  //     .push(MaterialPageRoute(
                                  //   builder: (context) => CreateDyeing(),
                                  // ))
                                  ,
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
