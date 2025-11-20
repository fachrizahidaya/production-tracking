import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/components/master/form/create/create_form.dart';
import 'package:html/parser.dart' as html_parser;

class FinishInfoTab extends StatefulWidget {
  final id;
  final data;
  final form;
  final formKey;
  final handleSubmit;
  final handleSelectMachine;
  final handleSelectWorkOrder;
  final isLoading;
  final maklon;
  final isMaklon;
  final withMaklonOrMachine;
  final withOnlyMaklon;
  final withNoMaklonOrMachine;

  const FinishInfoTab(
      {super.key,
      this.data,
      this.form,
      this.formKey,
      this.handleSelectMachine,
      this.handleSelectWorkOrder,
      this.handleSubmit,
      this.id,
      this.isLoading,
      this.isMaklon,
      this.maklon,
      this.withMaklonOrMachine,
      this.withNoMaklonOrMachine,
      this.withOnlyMaklon});

  @override
  State<FinishInfoTab> createState() => _FinishInfoTabState();
}

class _FinishInfoTabState extends State<FinishInfoTab> {
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
              formKey: widget.formKey,
              form: widget.form,
              maklon: widget.maklon,
              isMaklon: widget.isMaklon,
              handleSubmit: widget.handleSubmit,
              data: widget.data,
              selectWorkOrder: widget.handleSelectWorkOrder,
              selectMachine: widget.handleSelectMachine,
              id: widget.id,
              isLoading: widget.isLoading,
              withMaklonOrMachine: widget.withMaklonOrMachine,
              withOnlyMaklon: widget.withOnlyMaklon,
              withNoMaklonOrMachine: widget.withNoMaklonOrMachine,
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
                            viewLabel: 'User',
                            viewValue:
                                widget.data['user']?['name']?.toString() ??
                                    '-'),
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
                            viewValue:
                                widget.data['status']?.toString() ?? '-'),
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
