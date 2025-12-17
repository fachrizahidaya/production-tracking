import 'package:flutter/material.dart';
import 'package:textile_tracking/components/work-order/item/process_item.dart';

class ProcessTab extends StatefulWidget {
  final data;

  const ProcessTab({super.key, this.data});

  @override
  State<ProcessTab> createState() => _ProcessTabState();
}

class _ProcessTabState extends State<ProcessTab> {
  @override
  Widget build(BuildContext context) {
    final rawData = widget.data ?? {};

    final List<Map<String, dynamic>> items = [];

    const processKeys = [
      'dyeing',
      'press',
      'tumbler',
      'stenter',
      'long_sitting',
      'long_hemming',
      'cross_cutting',
      'sewing',
      'embroidery',
      'printing',
      'sorting',
      'packing',
    ];

    for (final key in processKeys) {
      final value = rawData[key];

      if (value == null) continue;

      if (value is List) {
        for (final item in value) {
          if (item is Map<String, dynamic>) {
            items.add({
              'process': key,
              'data': item,
            });
          }
        }
      } else if (value is Map<String, dynamic>) {
        items.add({
          'process': key,
          'data': value,
        });
      }
    }

    return items.isEmpty
        ? const Center(child: Text('No Data'))
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ProcessItem(item: items[index]);
            },
          );
  }
}
