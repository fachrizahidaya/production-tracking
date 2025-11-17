import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/finish_list_item.dart';

class FinishItemTab extends StatefulWidget {
  final dynamic data;

  const FinishItemTab({
    super.key,
    this.data,
  });

  @override
  State<FinishItemTab> createState() => _FinishItemTabState();
}

class _FinishItemTabState extends State<FinishItemTab> {
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
                return FinishListItem(
                  item: item,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            ),
    );
  }
}
