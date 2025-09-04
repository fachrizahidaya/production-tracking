import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/layout/custom_card.dart';
import 'package:production_tracking/helpers/util/padding_column.dart';

class CustomList<T> extends StatefulWidget {
  final Future<List<T>> Function({bool isInitialLoad, String? searchQuery})?
      fetchItems;
  final List<T>? initialItems;
  final Function(T? currentItem) onTapItem;
  final Widget Function(T item) itemBuilder;
  final String? searchQuery;

  const CustomList(
      {super.key,
      this.fetchItems,
      this.initialItems,
      required this.onTapItem,
      required this.itemBuilder,
      this.searchQuery});

  @override
  State<CustomList<T>> createState() => _CustomListState<T>();
}

class _CustomListState<T> extends State<CustomList<T>> {
  late List<T> _items;
  bool _isLoading = false;
  bool _hasMoreData = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _items = widget.initialItems ?? [];
    if (widget.fetchItems != null) {
      _handleFetchItem(isInitialLoad: true);
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMoreData &&
          widget.fetchItems != null) {
        _handleFetchItem();
      }
    });
    super.initState();
  }

  Future<void> _handleFetchItem(
      {bool isInitialLoad = false, String? searchQuery}) async {
    if (isInitialLoad) {
      setState(() {
        _items.clear();
        _hasMoreData = true;
      });
    }

    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newItems = await widget.fetchItems!(
          isInitialLoad: isInitialLoad,
          searchQuery: searchQuery ?? widget.searchQuery);

      setState(() {
        _items.addAll(newItems);
        _hasMoreData = newItems.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        _hasMoreData = false;
      });

      throw Exception('Error fetch item: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didUpdateWidget(CustomList<T> oldWidget) {
    if (oldWidget.searchQuery != widget.searchQuery) {
      _handleFetchItem(isInitialLoad: true, searchQuery: widget.searchQuery);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: PaddingColumn.screen,
              itemCount: _items.length + (_hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _items.length) {
                  final item = _items[index];

                  return Padding(
                    padding: PaddingColumn.screen,
                    child: GestureDetector(
                      onTap: () => widget.onTapItem,
                      child: CustomCard(child: widget.itemBuilder(item)),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              })
        ],
      ),
    );
  }
}
