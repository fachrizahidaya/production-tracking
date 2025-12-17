import 'dart:async';

import 'package:flutter/material.dart';

mixin PaginatedFilterMixin<T extends StatefulWidget> on State<T> {
  bool firstLoading = true;
  bool hasMore = true;
  bool isLoadMore = false;
  bool isFiltered = false;

  String search = '';
  Timer? debounce;

  final List<dynamic> dataList = [];
  Map<String, String> params = {'page': '0'};

  Future<void> fetchData(Map<String, String> params);

  List<String> get filterKeys => [
        'status',
        'user_id',
        'start_date',
        'end_date',
      ];

  void handleSearch(String value) {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      search = value;
      params['search'] = value;
      resetAndLoad();
    });
  }

  void handleFilter(String key, String value) {
    params['page'] = '0';

    if (value.isNotEmpty) {
      params[key] = value;
    } else {
      params.remove(key);
    }

    isFiltered = _checkIsFiltered();
    resetAndLoad();
  }

  bool _checkIsFiltered() {
    for (final key in filterKeys) {
      if (params[key] != null && params[key]!.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  void resetAndLoad() {
    params['page'] = '0';
    loadMore();
  }

  Future<void> loadMore() async {
    if (!hasMore) return;

    isLoadMore = true;

    if (params['page'] == '0') {
      dataList.clear();
      firstLoading = true;
      hasMore = true;
    }

    final nextPage = (int.parse(params['page'] ?? '0') + 1).toString();
    params['page'] = nextPage;

    await fetchData(params);

    if (!mounted) return;

    isLoadMore = false;
    firstLoading = false;
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }
}
