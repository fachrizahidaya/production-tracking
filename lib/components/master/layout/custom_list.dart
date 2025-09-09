import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/button/custom_floating_button.dart';
import 'package:production_tracking/components/master/text/no_data.dart';
import 'package:production_tracking/helpers/service/base_service.dart';
import 'package:provider/provider.dart';

class CustomList<T> extends StatefulWidget {
  final BaseService<T> service;
  final String searchQuery;
  final bool? canUpdate;
  final bool? canCreate;
  final Widget Function(T item) itemBuilder;
  final Future<void> Function(BuildContext context, T? currentItem)? onForm;

  const CustomList({
    super.key,
    required this.service,
    required this.searchQuery,
    required this.itemBuilder,
    this.canUpdate = false,
    this.canCreate = false,
    this.onForm,
  });

  @override
  State<CustomList<T>> createState() => _CustomListState<T>();
}

class _CustomListState<T> extends State<CustomList<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.service.fetchItems(isInitialLoad: true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !widget.service.isLoading &&
          widget.service.hasMoreData) {
        widget.service.fetchItems();
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      widget.service.fetchItems(
        isInitialLoad: true,
        searchQuery: widget.searchQuery,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ChangeNotifierProvider.value(
          value: widget.service,
          child: Consumer<BaseService<T>>(
            builder: (context, service, _) {
              if (service.isLoading && service.items.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (service.items.isEmpty) {
                return const Center(
                  child: NoData(),
                );
              }

              return RefreshIndicator(
                  onRefresh: service.refetchItems,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount:
                        service.items.length + (service.hasMoreData ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < service.items.length) {
                        final item = service.items[index];
                        return GestureDetector(
                          onTap: widget.canUpdate == true
                              ? () => widget.onForm?.call(context, item)
                              : null,
                          child: widget.itemBuilder(item),
                        );
                      } else {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ));
            },
          ),
        ),
        if (widget.canCreate == true)
          Positioned(
            bottom: 16,
            right: 16,
            child: CustomFloatingButton(
                onPressed: () => widget.onForm?.call(context, null),
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          )
      ],
    );
  }
}
