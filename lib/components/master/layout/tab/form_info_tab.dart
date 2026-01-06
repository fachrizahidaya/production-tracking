import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/layout/card/custom_badge.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/components/master/section/create/create_section.dart';
import 'package:html/parser.dart' as html_parser;

class FormInfoTab extends StatefulWidget {
  final id;
  final data;
  final label;
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

  const FormInfoTab(
      {super.key,
      this.data,
      this.form,
      this.label,
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
  State<FormInfoTab> createState() => _FormInfoTabState();
}

class _FormInfoTabState extends State<FormInfoTab> {
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
    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      padding: CustomTheme().padding('content'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CreateSection(
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
            Row(
              children: [
                Expanded(
                  child: CustomCard(
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
                                  widget.data['greige_qty']
                                      .toString()
                                      .isNotEmpty
                              ? '${NumberFormat("#,###.#").format(double.tryParse(widget.data['greige_qty'].toString()) ?? 0)} ${widget.data['greige_unit']?['code'] ?? ''}'
                              : '-'),
                      ViewText(
                          viewLabel: 'Catatan ${widget.label}',
                          viewValue: htmlToPlainText(widget.data['notes'] is Map
                              ? widget.data['notes'][widget.label]
                              : '-')),
                    ].separatedBy(CustomTheme().vGap('lg')),
                  )),
                ),
              ],
            )
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }
}
