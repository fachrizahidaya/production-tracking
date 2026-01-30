// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/list_item.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: CustomTheme().padding('card'),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: CustomTheme().padding('process-content'),
                  decoration: BoxDecoration(
                    color:
                        CustomTheme().buttonColor('primary').withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 18,
                    color: CustomTheme().buttonColor('primary'),
                  ),
                ),
                Text(
                  'Material',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('md'),
                    fontWeight: CustomTheme().fontWeight('semibold'),
                    color: Colors.grey[800],
                  ),
                ),
              ].separatedBy(CustomTheme().hGap('xl')),
            ),
          ),
          Padding(
            padding: CustomTheme().padding('item-detail'),
            child: widget.data.isEmpty
                ? NoData()
                : Column(
                    children: List.generate(items.length, (index) {
                      return Column(
                        children: [
                          ListItem(item: items[index]),
                          if (index != items.length - 1)
                            const SizedBox(height: 12),
                        ].separatedBy(CustomTheme().vGap('xl')),
                      );
                    }),
                  ),
          ),
        ],
      ),
    );
  }
}
