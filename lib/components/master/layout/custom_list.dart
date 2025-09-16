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
      this.filterWidget});

  @override
  State<CustomList<T>> createState() => _CustomListState<T>();
}

class _CustomListState<T> extends State<CustomList<T>> {
  final ScrollController _scrollController = ScrollController();
  final List<T> _dataList = [];
  bool _firstLoading = true;
  bool _isLoadMore = false;
  bool _hasMore = true;
  bool _isFiltered = false;
  String _search = '';
  Map<String, String> params = {'search': '', 'page': '0'};

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

  void _fetchInitial() {
    widget.service
        .fetchItems(isInitialLoad: true, searchQuery: widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant CustomList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _fetchInitial();
    }
  }

  Future<void> _handleSearch(String value) async {
    setState(() {
      params = {'search': value.toString(), 'page': '0'};
    });
    _loadMore();
  }

  Future<void> _handleFilter(String key, String? value) async {
    setState(() {
      params['page'] = '0';
      if (value != null && value.isNotEmpty) {
        params[key] = value;
      } else {
        params.remove(key);
      }
    });

    _isFiltered = params.keys.any((k) =>
        k != 'search' && k != 'page' && (params[k]?.isNotEmpty ?? false));

    _loadMore();
  }

  Future<void> _submitFilter() async {
    Navigator.pop(context);
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
      params = {'search': _search, 'page': '0'};
    });
    _loadMore();
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
          handleSearchChange: _handleSearch,
          showFilter: _openFilter,
        ),
        Expanded(
          child: _firstLoading
              ? const Center(child: CircularProgressIndicator())
              : _dataList.isEmpty
                  ? const Center(child: Text('No Data'))
                  : Stack(
                      children: [
                        RefreshIndicator(
                          onRefresh: _refetch,
                          child: ListView.separated(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(8),
                            itemCount: _hasMore
                                ? _dataList.length + 1
                                : _dataList.length,
                            itemBuilder: (context, index) {
                              if (index >= _dataList.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }

                              final item = _dataList[index];
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
