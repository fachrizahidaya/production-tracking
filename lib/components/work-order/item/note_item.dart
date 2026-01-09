import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:html/parser.dart' as html_parser;

class NoteItem extends StatefulWidget {
  final item;

  const NoteItem({super.key, this.item});

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  @override
  Widget build(BuildContext context) {
    String htmlToPlainText(dynamic htmlString) {
      if (htmlString == null) return '';

      if (htmlString is List) {
        return htmlString.join(" ");
      }

      if (htmlString is! String) {
        return htmlString.toString();
      }

      final document = html_parser.parse(htmlString);
      return document.body?.text ?? '';
    }

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewText(
            viewLabel: 'Catatan ${widget.item['label']}',
            viewValue: htmlToPlainText(widget.item['content']),
          ),
        ],
      ),
    );
  }
}
