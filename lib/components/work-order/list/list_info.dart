import 'package:flutter/material.dart';
import 'package:textile_tracking/components/process/info_tab.dart';
import 'package:html/parser.dart' as html_parser;

class ListInfo extends StatefulWidget {
  final data;

  const ListInfo({
    super.key,
    this.data,
  });

  @override
  State<ListInfo> createState() => _ListInfoState();
}

class _ListInfoState extends State<ListInfo> {
  String htmlToPlainText(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return SingleChildScrollView(
          child: InfoTab(
            data: widget.data,
            isTablet: isTablet,
            label: null,
          ),
        );
      },
    );
  }
}
