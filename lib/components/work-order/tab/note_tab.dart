import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/work-order/item/note_item.dart';

class NoteTab extends StatefulWidget {
  final data;
  const NoteTab({super.key, this.data});

  @override
  State<NoteTab> createState() => _NoteTabState();
}

class _NoteTabState extends State<NoteTab> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items =
        (widget.data?['notes'] ?? []).cast<Map<String, dynamic>>();

    return Container(
      child: items.isEmpty
          ? Center(child: Text('No Data'))
          : ListView.separated(
              padding: CustomTheme().padding('content'),
              separatorBuilder: (context, index) => CustomTheme().vGap('2xl'),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return NoteItem(item: item);
              },
            ),
    );
  }
}
