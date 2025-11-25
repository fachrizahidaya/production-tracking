// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/dashboard_list.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WorkOrderProcessScreen extends StatefulWidget {
  final data;
  final onHandleFilter;
  final filterWidget;
  final handleSearch;
  final search;
  final firstLoading;
  final hasMore;
  final handleRefetch;
  final handleLoadMore;
  final handleFetchData;
  final handleBuildItem;
  final service;
  final isFiltered;

  const WorkOrderProcessScreen(
      {super.key,
      this.data,
      this.onHandleFilter,
      this.filterWidget,
      this.handleSearch,
      this.search,
      this.handleRefetch,
      this.handleLoadMore,
      this.firstLoading,
      this.hasMore,
      this.handleFetchData,
      this.handleBuildItem,
      this.service,
      this.isFiltered});

  @override
  State<WorkOrderProcessScreen> createState() => _WorkOrderProcessScreenState();
}

class _WorkOrderProcessScreenState extends State<WorkOrderProcessScreen> {
  final double width = 14;
  double maxY = 0;
  int? touchedIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WorkOrderProcessScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 800,
          child: DashboardList(
            fetchData: widget.handleFetchData,
            service: widget.service,
            searchQuery: widget.search,
            itemBuilder: widget.handleBuildItem,
            filterWidget: widget.filterWidget,
            handleRefetch: widget.handleRefetch,
            handleLoadMore: widget.handleLoadMore,
            handleSearch: widget.handleSearch,
            dataList: widget.data,
            firstLoading: widget.firstLoading,
            hasMore: widget.hasMore,
            isFiltered: widget.isFiltered,
          ),
        )
      ].separatedBy(const SizedBox(height: 16)),
    );
  }
}
