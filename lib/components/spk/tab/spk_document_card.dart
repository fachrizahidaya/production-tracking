import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/spk/tab/attachment_section.dart';
import 'package:textile_tracking/components/spk/tab/spk_card_content.dart';
import 'package:textile_tracking/components/work-order/item/note/card_content.dart';
import 'package:textile_tracking/helpers/util/format_html.dart';

class SpkDocumentCard extends StatefulWidget {
  final Map<String, dynamic> item;

  const SpkDocumentCard({
    super.key,
    required this.item,
  });

  @override
  State<SpkDocumentCard> createState() => _SpkDocumentCardState();
}

class _SpkDocumentCardState extends State<SpkDocumentCard> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notes = widget.item['notes']?.toString() ?? '';

    final attachments = List<Map<String, dynamic>>.from(
      widget.item['attachments'] ?? [],
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (notes.isNotEmpty) ...[
            CustomTheme().vGap('lg'),
            SpkCardContent(
              notes: notes,
            ),
          ],
          if (attachments.isNotEmpty) ...[
            CustomTheme().vGap('lg'),
            AttachmentSection(
              attachments: attachments,
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: CustomTheme().padding('card'),
      child: Row(
        children: [
          Icon(Icons.description_outlined),
          Expanded(
            child: Text(
              '${widget.item['spk_no']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
