import 'package:flutter/material.dart';

class SimpleList<T> extends StatefulWidget {
  final Future<List<T>> Function(Map<String, String> params) fetchData;
  final Widget Function(T item) itemBuilder;
  final void Function(BuildContext context, T item)? onItemTap;

  const SimpleList({
    super.key,
    required this.fetchData,
    required this.itemBuilder,
    this.onItemTap,
  });

  @override
  State<SimpleList<T>> createState() => _SimpleListState<T>();
}

class _SimpleListState<T> extends State<SimpleList<T>> {
  final ScrollController _scrollController = ScrollController();
  final List<T> _dataList = [];
  bool _firstLoading = true;
  bool _isLoadMore = false;
  bool _hasMore = true;
  Map<String, String> params = {'page': '0'};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent > 0 &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isLoadMore &&
          _hasMore) {
        _loadMore();
      }
    });
    _loadMore();
  }

  Future<void> _loadMore() async {
    if (!_hasMore && params['page'] != '0') return;

    setState(() {
      _isLoadMore = true;
    });

    if (params['page'] == '0') {
      setState(() {
        _dataList.clear();
        _firstLoading = true;
        _hasMore = true;
      });
    }

    String newPage = (int.parse(params['page'] ?? '0') + 1).toString();
    params['page'] = newPage;

    final loadData = await widget.fetchData(params);

    if (loadData.isEmpty) {
      setState(() {
        _firstLoading = false;
        _isLoadMore = false;
        _hasMore = false;
      });
    } else {
      setState(() {
        _dataList.addAll(loadData);
        _firstLoading = false;
        _isLoadMore = false;
      });
    }
  }

  Future<void> _refetch() async {
    setState(() {
      params = {'page': '0'};
    });
    _loadMore();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _dataList.isEmpty
        ? const Center(child: Text('No Data'))
        : RefreshIndicator(
            onRefresh: _refetch,
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: _hasMore ? _dataList.length + 1 : _dataList.length,
              itemBuilder: (context, index) {
                if (index >= _dataList.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(),
                  );
                }

                final item = _dataList[index];
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
