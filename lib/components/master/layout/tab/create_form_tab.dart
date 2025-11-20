import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:html/parser.dart' as html_parser;

class CreateFormTab extends StatefulWidget {
  final data;

  const CreateFormTab({super.key, this.data});

  @override
  State<CreateFormTab> createState() => _CreateFormTabState();
}

class _CreateFormTabState extends State<CreateFormTab> {
  String htmlToPlainText(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: widget.data.isEmpty
          ? Center(child: Text('No Data'))
          : CustomCard(
              child: Padding(
              padding: PaddingColumn.screen,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ViewText(
                          viewLabel: 'Nomor',
                          viewValue: widget.data['wo_no']?.toString() ?? '-'),
                      ViewText(
                          viewLabel: 'User',
                          viewValue:
                              widget.data['user']?['name']?.toString() ?? '-'),
                      ViewText(
                          viewLabel: 'Tanggal',
                          viewValue: widget.data['wo_date'] != null
                              ? DateFormat("dd MMM yyyy").format(
                                  DateTime.parse(widget.data['wo_date']))
                              : '-'),
                      ViewText(
                          viewLabel: 'Catatan',
                          viewValue: htmlToPlainText(
                              widget.data['notes']?.toString() ?? '-')),
                      ViewText(
                          viewLabel: 'Jumlah Greige',
                          viewValue: widget.data['greige_qty'] != null &&
                                  widget.data['greige_qty']
                                      .toString()
                                      .isNotEmpty
                              ? '${NumberFormat("#,###.#").format(double.tryParse(widget.data['greige_qty'].toString()) ?? 0)} ${widget.data['greige_unit']?['code'] ?? ''}'
                              : '-'),
                      ViewText(
                          viewLabel: 'Status',
                          viewValue: widget.data['status']?.toString() ?? '-'),
                    ].separatedBy(SizedBox(
                      height: 16,
                    )),
                  ),
                ],
              ),
            )),
    );
  }
}
