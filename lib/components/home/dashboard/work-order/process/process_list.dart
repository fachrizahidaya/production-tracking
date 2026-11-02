import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/item_process.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class ProcessList<T> extends StatefulWidget {
  final BaseCrudService<T> service;
  final String searchQuery;

  final Future<void> Function(
    BuildContext context,
    T? currentItem,
  )? onForm;

  final void Function(
    BuildContext context,
    T item,
  )? onItemTap;

  final Future<List<T>> Function(
    Map<String, String> params,
  ) fetchData;

  final dynamic dataList;

  final VoidCallback? handleLoadMore;

  final bool firstLoading;
  final bool hasMore;
  final bool isFetching;
  final bool isLoadMore;
  final bool isMobile;

  const ProcessList({
    super.key,
    required this.service,
    required this.searchQuery,
    required this.fetchData,
    this.onForm,
    this.onItemTap,
    this.dataList,
    this.handleLoadMore,
    this.firstLoading = false,
    this.hasMore = false,
    this.isFetching = false,
    this.isLoadMore = false,
    this.isMobile = true,
  });

  @override
  State<ProcessList<T>> createState() => _ProcessListState<T>();
}

class _ProcessListState<T> extends State<ProcessList<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (!widget.hasMore || widget.isLoadMore) return;
    if (widget.handleLoadMore == null) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 80) {
      widget.handleLoadMore!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> data =
        widget.dataList is List ? List<dynamic>.from(widget.dataList) : [];
    final isTablet = !widget.isMobile;
    final listHeight = isTablet ? 340.0 : 300.0;

    if (widget.firstLoading) {
      return SizedBox(
        height: 120,
        child: Padding(
          padding: CustomTheme().padding('content'),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (data.isEmpty) {
      return SizedBox(
        height: 120,
        child: Padding(
          padding: CustomTheme().padding('content'),
          child: const NoData(),
        ),
      );
    }

    return SizedBox(
      height: listHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = (constraints.maxWidth * (isTablet ? 0.65 : 0.8))
              .clamp(
                isTablet ? 440.0 : 260.0,
                isTablet ? 520.0 : 300.0,
              )
              .toDouble();

          return ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: data.length + (widget.hasMore ? 1 : 0),
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            itemBuilder: (context, index) {
              if (index >= data.length) {
                if (!widget.isLoadMore && widget.handleLoadMore != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    if (!widget.hasMore || widget.isLoadMore) return;
                    widget.handleLoadMore!();
                  });
                }

                return SizedBox(
                  width: cardWidth,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final isLast = index == data.length - 1 && !widget.hasMore;

              return SizedBox(
                width: cardWidth,
                child: Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : 10),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ItemProcess(
                      item: data[index],
                      showTimeline: true,
                      isMobile: widget.isMobile,
                      onTap: widget.onItemTap == null
                          ? null
                          : () => widget.onItemTap!(
                                context,
                                data[index],
                              ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
