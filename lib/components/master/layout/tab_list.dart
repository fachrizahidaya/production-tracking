import 'package:flutter/material.dart';

class TabList<T> extends StatefulWidget {
  final Future<List<T>> Function(Map<String, String> params) fetchData;
  final Widget Function(T item) itemBuilder;
  final void Function(BuildContext context, T item)? onItemTap;
  final handleRefetch;
  final dataList;
  final hasMore;

  const TabList(
      {super.key,
      required this.fetchData,
      required this.itemBuilder,
      this.onItemTap,
      this.handleRefetch,
      this.dataList,
      this.hasMore});

  @override
  State<TabList<T>> createState() => _TabListState<T>();
}

class _TabListState<T> extends State<TabList<T>> {
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

  @override
  Widget build(BuildContext context) {
    return widget.dataList.isEmpty
        ? const Center(child: Text('No Data'))
        : RefreshIndicator(
            onRefresh: widget.handleRefetch,
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: widget.hasMore
                  ? widget.dataList.length + 1
                  : widget.dataList.length,
              itemBuilder: (context, index) {
                if (index >= widget.dataList.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(),
                  );
                }

                final item = widget.dataList[index];
                return GestureDetector(
                  onTap: () => widget.onItemTap?.call(context, item),
                  child: widget.itemBuilder(item),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            ),
          );
  }
}
