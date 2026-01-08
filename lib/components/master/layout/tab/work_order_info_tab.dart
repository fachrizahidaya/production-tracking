import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/layout/card/custom_badge.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/master/theme.dart';
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
    return Container(
      padding: CustomTheme().padding('content'),
      child: widget.data.isEmpty
          ? Center(child: Text('No Data'))
          : CustomCard(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.data['wo_no']?.toString() ?? '-',
                      style: TextStyle(
                          fontSize: CustomTheme().fontSize('2xl'),
                          fontWeight: CustomTheme().fontWeight('bold')),
                    ),
                    CustomBadge(
                      title: widget.data['status'] ?? '-',
                      withDifferentColor: true,
                      withStatus: true,
                      status: widget.data['status'],
                      color: widget.data['status'] == 'Diproses'
                          ? Color(0xFFfff3c6)
                          : Color(0xffd1fae4),
                    ),
                  ].separatedBy(CustomTheme().hGap('xl')),
                ),
                ViewText(
                    viewLabel: 'Jumlah Greige',
                    viewValue: widget.data['greige_qty'] != null &&
                            widget.data['greige_qty'].toString().isNotEmpty
                        ? '${NumberFormat("#,###.#").format(double.tryParse(widget.data['greige_qty'].toString()) ?? 0)} ${widget.data['greige_unit']?['code'] ?? ''}'
                        : 'No Data'),
                ViewText(
                    viewLabel: 'Catatan ${widget.label}',
                    viewValue: widget.data['notes'] != null
                        ? htmlToPlainText(widget.data['notes'])
                        : 'No Data'),
              ].separatedBy(CustomTheme().vGap('xl')),
            )),
    );
  }
}
