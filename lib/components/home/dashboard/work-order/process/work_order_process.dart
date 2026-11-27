// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/custom_search_bar.dart';
import 'package:textile_tracking/components/home/dashboard/card/dashboard_card.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/process/process_list.dart';
import 'package:textile_tracking/helpers/service/base_crud_service.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

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
  final bool isMobile;

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
    this.isMobile = true,
  });

  @override
  State<WorkOrderProcessScreen> createState() => _WorkOrderProcessScreenState();
}

class _WorkOrderProcessScreenState extends State<WorkOrderProcessScreen> {
  void _openFilter() {
    if (widget.filterWidget == null) return;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
        return widget.filterWidget!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: DashboardCard(
            child: CustomSearchBar(
              handleSearchChange: widget.handleSearch ?? (_) {},
              showFilter: _openFilter,
              isFiltered: widget.isFiltered,
              withRefresh: true,
              handleRefetch: widget.handleRefetch,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ProcessList(
          fetchData: widget.handleFetchData,
          service: widget.service,
          searchQuery: widget.search,
          handleLoadMore: widget.handleLoadMore,
          dataList: widget.data,
          firstLoading: widget.firstLoading,
          hasMore: widget.hasMore,
          isLoadMore: widget.isLoadMore,
          isMobile: widget.isMobile,
          onItemTap: (context, item) {
            final id = (item is Map ? item['id'] : null)?.toString();
            if (id == null || id.isEmpty) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkOrderDetail(id: id),
              ),
            );
          },
        ),
      ],
    );
  }
}
