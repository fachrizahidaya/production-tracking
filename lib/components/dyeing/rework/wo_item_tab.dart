import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/list_item.dart';
import 'package:textile_tracking/components/master/theme.dart';

class WoItemTab extends StatefulWidget {
  final dynamic data;

  const WoItemTab({
    super.key,
    this.data,
  });

  @override
  State<WoItemTab> createState() => _WoItemTabState();
}

class _WoItemTabState extends State<WoItemTab> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items =
        (widget.data?['items'] ?? []).cast<Map<String, dynamic>>();

    return SizedBox(
      height: 500,
      child: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (context, index) => CustomTheme().vGap('2xl'),
        itemBuilder: (context, index) {
          final item = items[index];
          return ListItem(
            item: item,
          );
        },
      ),
    );
  }
}
