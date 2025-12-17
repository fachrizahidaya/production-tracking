import 'package:flutter/material.dart';
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
    final Map<String, dynamic> notesMap =
        Map<String, dynamic>.from(widget.data?['notes'] ?? {});

    final List<Map<String, String>> items = notesMap.entries
        .map((e) => {
              'label': e.key,
              'value': e.value?.toString() ?? '',
            })
        .toList();

    return Container(
      child: items.isEmpty
          ? Center(child: Text('No Data'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return NoteItem(item: item);
              },
            ),
    );
  }
}
