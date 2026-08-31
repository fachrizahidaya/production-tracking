// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dashboard_card.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/process/process_list.dart';
import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class WorkOrderProcessScreen extends StatefulWidget {
  final dynamic data;
  final Widget? filterWidget;
  final Function(String)? handleSearch;
  final String search;
  final bool firstLoading;
  final bool hasMore;
  final VoidCallback? handleRefetch;
  final VoidCallback? handleLoadMore;
  final Future<List<dynamic>> Function(
    Map<String, String> params,
  ) handleFetchData;
  final BaseCrudService service;
  final bool isFiltered;
  final bool isLoadMore;

  const WorkOrderProcessScreen({
    super.key,
    this.data,
    this.filterWidget,
    this.handleSearch,
    this.search = '',
    this.handleRefetch,
    this.handleLoadMore,
    this.firstLoading = false,
    this.hasMore = false,
    required this.handleFetchData,
    required this.service,
    this.isFiltered = false,
    this.isLoadMore = false,
  });

  @override
  State<WorkOrderProcessScreen> createState() => _WorkOrderProcessScreenState();
}

class _WorkOrderProcessScreenState extends State<WorkOrderProcessScreen> {
  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: ProcessList(
        fetchData: widget.handleFetchData,
        service: widget.service,
        searchQuery: widget.search,
        filterWidget: widget.filterWidget,
        handleRefetch: widget.handleRefetch,
        handleLoadMore: widget.handleLoadMore,
        handleSearch: widget.handleSearch,
        dataList: widget.data,
        firstLoading: widget.firstLoading,
        hasMore: widget.hasMore,
        isFiltered: widget.isFiltered,
        isLoadMore: widget.isLoadMore,
      ),
    );
  }
}
