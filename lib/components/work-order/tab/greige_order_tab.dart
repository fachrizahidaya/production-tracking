import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/work-order/item/greige_order_item.dart';

class GreigeOrderTab extends StatefulWidget {
  final dynamic data;

  const GreigeOrderTab({super.key, this.data});

  @override
  State<GreigeOrderTab> createState() => _GreigeOrderTabState();
}

class _GreigeOrderTabState extends State<GreigeOrderTab> {
  @override
  Widget build(BuildContext context) {
    const greigeProcessKeys = {'warping', 'sizing', 'weaving', 'shearing'};
    final List<Map<String, dynamic>> items =
        (widget.data?['processes'] as List? ?? [])
            .whereType<Map<String, dynamic>>()
            .where((item) => greigeProcessKeys.contains(item['key']))
            .toList();

    return items.isEmpty
        ? const Center(child: NoData())
        : GridView.builder(
            padding: CustomTheme().padding('content'),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 520,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GreigeOrderItem(
                item: items[index],
              );
            },
          );
  }
}
