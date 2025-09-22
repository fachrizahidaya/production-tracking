import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/layout/simple_list.dart';
import 'package:production_tracking/components/work-order/attachment_item.dart';
import 'package:production_tracking/helpers/util/padding_column.dart';

class AttachmentTab extends StatefulWidget {
  final Map<String, dynamic>? data;

  const AttachmentTab({super.key, this.data});

  @override
  State<AttachmentTab> createState() => _AttachmentTabState();
}

class _AttachmentTabState extends State<AttachmentTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEBEBEB),
      padding: PaddingColumn.screen,
      child: widget.data == null || widget.data!['attachments'] == null
          ? const Center(child: Text('No Data'))
          : SimpleList<Map<String, dynamic>>(
              fetchData: (params) async {
                final attachments =
                    widget.data!['attachments'] as List<dynamic>;
                return attachments.cast<Map<String, dynamic>>();
              },
              itemBuilder: (item) => AttachmentItem(
                    item: item,
                  )),
    );
  }
}
