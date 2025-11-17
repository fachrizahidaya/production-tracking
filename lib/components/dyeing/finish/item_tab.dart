import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/create/list_item.dart';

class ItemTab extends StatefulWidget {
  final dynamic data;

  const ItemTab({
    super.key,
    this.data,
  });

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
          ? const Center(child: Text('No Data'))
          : ListView.separated(
              padding: EdgeInsets.only(top: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListItem(
                  item: item,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            ),
    );
  }
}
