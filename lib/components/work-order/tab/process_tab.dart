import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
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
    final List<Map<String, dynamic>> items =
        (widget.data?['processes'] ?? []).cast<Map<String, dynamic>>();

    return Container(
      child: items.isEmpty
          ? Center(child: Text('No Data'))
          : GridView.builder(
              padding: CustomTheme().padding('content'),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 520, // adjust
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ProcessItem(item: items[index]);
              },
            ),
    );
  }
}
