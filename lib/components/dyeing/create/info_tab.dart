import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/create/create_form.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:html/parser.dart' as html_parser;

class InfoTab extends StatefulWidget {
  final id;
  final label;
  final data;
  final form;
  final formKey;
  final handleSubmit;
  final handleSelectMachine;
  final handleSelectWorkOrder;
  final isLoading;

  const InfoTab(
      {super.key,
      this.data,
      this.form,
      this.formKey,
      this.handleSelectMachine,
      this.handleSelectWorkOrder,
      this.handleSubmit,
      this.id,
      this.isLoading,
      this.label});

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  String htmlToPlainText(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreateForm(
              form: widget.form,
              formKey: widget.formKey,
              handleSubmit: widget.handleSubmit,
              data: widget.data,
              selectWorkOrder: widget.handleSelectWorkOrder,
              selectMachine: widget.handleSelectMachine,
              id: widget.id,
              isLoading: widget.isLoading,
            ),
            if (widget.form?['wo_id'] != null)
              CustomCard(
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
                            viewLabel: 'Tanggal',
                            viewValue: widget.data['wo_date'] != null
                                ? DateFormat("dd MMM yyyy").format(
                                    DateTime.parse(widget.data['wo_date']))
                                : '-'),
                        ViewText(
                            viewLabel: 'Status',
                            viewValue:
                                widget.data['status']?.toString() ?? '-'),
                        ViewText(
                            viewLabel: 'User',
                            viewValue:
                                widget.data['user']?['name']?.toString() ??
                                    '-'),
                        ViewText(
                            viewLabel: 'Jumlah Greige',
                            viewValue: widget.data['greige_qty'] != null &&
                                    widget.data['greige_qty']
                                        .toString()
                                        .isNotEmpty
                                ? '${NumberFormat("#,###.#").format(double.tryParse(widget.data['greige_qty'].toString()) ?? 0)} ${widget.data['greige_unit']?['code'] ?? ''}'
                                : '-'),
                        ViewText(
                            viewLabel: 'Catatan',
                            viewValue: htmlToPlainText(
                                widget.data['notes'] is Map
                                    ? widget.data['notes'][widget.label]
                                    : '-')),
                      ].separatedBy(SizedBox(
                        height: 16,
                      )),
                    ),
                  ],
                ),
              ))
          ],
        ),
      ),
    );
  }
}
