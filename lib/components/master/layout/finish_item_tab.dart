import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/finish_list_item.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';

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
      color: const Color(0xFFEBEBEB),
      child: items.isEmpty
          ? const Center(child: Text('No Data'))
          : ListView.separated(
              padding: PaddingColumn.screen,
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
