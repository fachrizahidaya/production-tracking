import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/finish/work_order_item_tab.dart';
import 'package:textile_tracking/components/process/info_tab.dart';
import 'package:textile_tracking/components/work-order/tab/attachment_tab.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:html/parser.dart' as html_parser;

class WorkOrderInfoTab extends StatefulWidget {
  final data;
  final label;

  const WorkOrderInfoTab({super.key, this.data, this.label});

  @override
  State<WorkOrderInfoTab> createState() => _WorkOrderInfoTabState();
}

class _WorkOrderInfoTabState extends State<WorkOrderInfoTab> {
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return SingleChildScrollView(
          padding: CustomTheme().padding('content'),
          child: widget.data == null
              ? NoData()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoTab(
                      data: widget.data,
                      isTablet: isTablet,
                      label: widget.label,
                      withNote: true,
                    ),
                    WorkOrderItemTab(
                      data: widget.data,
                    ),
                    AttachmentTab(
                      existingAttachment: widget.data['attachments'] ?? [],
                    ),
                  ].separatedBy(CustomTheme().vGap('2xl')),
                ),
        );
      },
    );
  }
}
