import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:html/parser.dart' as html_parser;

class ListInfo extends StatefulWidget {
  final data;
  final existingAttachment;

  const ListInfo({super.key, this.data, this.existingAttachment});

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
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
              child: Padding(
                  padding: PaddingColumn.screen,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data['wo_no']?.toString() ?? '-',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              'Dibuat pada ${widget.data['wo_date'] != null ? DateFormat("dd MMMM yyyy").format(DateTime.parse(widget.data['wo_date'])) : '-'} oleh ${widget.data['user']?['name'] ?? ''}')
                        ].separatedBy(SizedBox(
                          height: 4,
                        )),
                      ),
                      CustomBadge(title: widget.data['status'] ?? '-'),
                    ],
                  )),
            ),
            CustomCard(
              child: Padding(
                  padding: PaddingColumn.screen,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ViewText(
                              viewLabel: 'Qty Greige',
                              viewValue: widget.data['greige_qty'] != null &&
                                      widget.data['greige_qty']
                                          .toString()
                                          .isNotEmpty
                                  ? '${NumberFormat("#,###.#").format(double.tryParse(widget.data['greige_qty'].toString()) ?? 0)} ${widget.data['greige_unit']?['code'] ?? ''}'
                                  : '-'),
                          ViewText(
                              viewLabel: 'Catatan',
                              viewValue:
                                  htmlToPlainText(widget.data?['notes'] ?? '-'))
                        ].separatedBy(SizedBox(
                          height: 8,
                        )),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
