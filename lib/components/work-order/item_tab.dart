import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/layout/tab_list.dart';
import 'package:production_tracking/components/work-order/list_item.dart';
import 'package:production_tracking/helpers/util/padding_column.dart';

class ItemTab extends StatefulWidget {
  final data;
  final handleSpk;
  final refetch;
  final hasMore;

  const ItemTab(
      {super.key, this.data, this.handleSpk, this.refetch, this.hasMore});

  @override
  State<ItemTab> createState() => _ItemTabState();
}

class _ItemTabState extends State<ItemTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEBEBEB),
      padding: PaddingColumn.screen,
      child: widget.data == null || widget.data!['items'] == null
          ? const Center(child: Text('No Data'))
          : TabList<Map<String, dynamic>>(
              fetchData: (params) async {
                final attachments = widget.data!['items'] as List<dynamic>;
                return attachments.cast<Map<String, dynamic>>();
              },
              itemBuilder: (item) => ListItem(
                item: item,
                handleSpk: widget.handleSpk,
              ),
              handleRefetch: widget.refetch,
              dataList: widget.data!['items'],
              hasMore: widget.hasMore,
            ),
    );
  }
}
