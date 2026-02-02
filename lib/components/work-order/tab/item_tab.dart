// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/list_item.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

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
        (widget.data?['work_orders'] != null
                ? widget.data?['work_orders']?['items']
                : widget.data?['items'] ?? [])
            .cast<Map<String, dynamic>>();

    return TemplateCard(
      title: 'Material',
      icon: Icons.inventory_2_outlined,
      child: widget.data.isEmpty
          ? NoData()
          : Column(
              children: List.generate(items.length, (index) {
                return Column(
                  children: [
                    ListItem(item: items[index]),
                    if (index != items.length - 1) const SizedBox(height: 12),
                  ].separatedBy(CustomTheme().vGap('xl')),
                );
              }),
            ),
    );
  }
}
