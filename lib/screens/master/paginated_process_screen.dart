import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/button/custom_floating_button.dart';
import 'package:textile_tracking/components/master/dialog/action_dialog.dart';
import 'package:textile_tracking/components/process/process_list.dart';

typedef FetchFunction = Future<List<dynamic>> Function(
  Map<String, String> params,
);

typedef ItemTapCallback = void Function(
  BuildContext context,
  dynamic item,
);

class PaginatedProcessScreen extends StatefulWidget {
  final String title;
  final FetchFunction fetchData;
  final Widget Function(dynamic item) itemBuilder;
  final ItemTapCallback onItemTap;
  final Widget filterWidget;
  final void Function(Map<String, String> params)? onParamsChanged;
  final Map<String, String> initialParams;

  final bool canRead;
  final bool canUpdate;
  final bool canDelete;

  final List<DialogActionItem> fabActions;

  const PaginatedProcessScreen(
      {super.key,
      required this.title,
      required this.fetchData,
      required this.itemBuilder,
      required this.onItemTap,
      required this.filterWidget,
      required this.canRead,
      required this.canUpdate,
      required this.canDelete,
      required this.fabActions,
      this.onParamsChanged,
      required this.initialParams});

  @override
  State<PaginatedProcessScreen> createState() => _PaginatedProcessScreenState();
}

class _PaginatedProcessScreenState extends State<PaginatedProcessScreen> {
  final List<dynamic> _dataList = [];
  late Map<String, String> params;

  bool _firstLoading = true;
  bool _hasMore = true;
  bool _isLoadMore = false;
  bool _showFab = true;
  bool _isFiltered = false;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    params = Map.of(widget.initialParams);
    _loadMore();
  }

  bool _checkIsFiltered() {
    const filterKeys = ['status', 'user_id', 'start_date', 'end_date'];
    return filterKeys.any(
      (k) => params[k] != null && params[k]!.isNotEmpty,
    );
  }

  Future<void> _handleSearch(String value) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        params['search'] = value;
        params['page'] = '0';
      });
      _loadMore();
    });
  }

  Future<void> _loadMore() async {
    if (!_hasMore) return;

    _isLoadMore = true;

    if (params['page'] == '0') {
      setState(() {
        _dataList.clear();
        _firstLoading = true;
        _hasMore = true;
      });
    }

    params['page'] = (int.parse(params['page']!) + 1).toString();

    final items = await widget.fetchData(params);

    setState(() {
      _firstLoading = false;
      _isLoadMore = false;

      if (items.isEmpty) {
        _hasMore = false;
      } else {
        _dataList.addAll(items);
      }
    });
  }

  void _refetch() {
    setState(() {
      params['page'] = '0';
      _isFiltered = _checkIsFiltered();
    });
    _loadMore();
  }

  void updateParam(String key, String value) {
    setState(() {
      params['page'] = '0';

      if (value.isEmpty) {
        params.remove(key);
      } else {
        params[key] = value;
      }

      _isFiltered = _checkIsFiltered();
    });

    widget.onParamsChanged?.call(params);
    _loadMore();
  }

  void submitFilter() {
    Navigator.pop(context);
    _loadMore();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFf9fafc),
        appBar: CustomAppBar(title: widget.title),
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.reverse) {
              if (_showFab) setState(() => _showFab = false);
            } else if (notification.direction == ScrollDirection.forward) {
              if (!_showFab) setState(() => _showFab = true);
            }
            return false;
          },
          child: ProcessList(
            fetchData: widget.fetchData,
            itemBuilder: widget.itemBuilder,
            onItemTap: widget.onItemTap,
            filterWidget: widget.filterWidget,
            dataList: _dataList,
            firstLoading: _firstLoading,
            isFiltered: _isFiltered,
            hasMore: _hasMore,
            isLoadMore: _isLoadMore,
            handleLoadMore: _loadMore,
            handleRefetch: _refetch,
            handleSearch: _handleSearch,
            canRead: widget.canRead,
          ),
        ),
        floatingActionButton: AnimatedSlide(
          duration: const Duration(milliseconds: 200),
          offset: _showFab ? Offset.zero : const Offset(0, 1),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _showFab ? 1 : 0,
            child: CustomFloatingButton(
              icon: const Icon(Icons.add, size: 72, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => ActionDialog(actions: widget.fabActions),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
