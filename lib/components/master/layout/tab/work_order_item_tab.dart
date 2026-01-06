import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/finish_list_item.dart';
import 'package:textile_tracking/components/master/theme.dart';

class WorkOrderItemTab extends StatefulWidget {
  final dynamic data;

  const WorkOrderItemTab({
    super.key,
    this.data,
  });

  @override
  State<WorkOrderItemTab> createState() => _WorkOrderItemTabState();
}

class _WorkOrderItemTabState extends State<WorkOrderItemTab> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items =
        (widget.data?['items'] ?? []).cast<Map<String, dynamic>>();

    return Container(
      child: items.isEmpty
          ? const Center(child: Text('No Data'))
          : ListView.separated(
              padding: CustomTheme().padding('content'),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return FinishListItem(
                  item: item,
                );
              },
              separatorBuilder: (context, index) => CustomTheme().vGap('2xl'),
            ),
    );
  }
}
