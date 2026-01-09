import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/list_item.dart';
import 'package:textile_tracking/components/master/theme.dart';

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
    final List<Map<String, dynamic>> items =
        (widget.data?['items'] ?? []).cast<Map<String, dynamic>>();

    return Container(
      child: items.isEmpty
          ? Center(child: Text('No Data'))
          : ListView.separated(
              padding: CustomTheme().padding('content'),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListItem(item: item);
              },
              separatorBuilder: (context, index) => CustomTheme().vGap('2xl'),
            ),
    );
  }
}
