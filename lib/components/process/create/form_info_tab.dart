import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/create/create_section.dart';
import 'package:textile_tracking/helpers/util/format_html.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class FormInfoTab extends StatefulWidget {
  final id;
  final data;
  final processData;
  final label;
  final form;
  final formKey;
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
      this.processData,
      this.form,
      this.label,
      this.formKey,
      this.handleSelectMachine,
      this.handleSelectWorkOrder,
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
                              : 'No Data'),
                      ViewText(
                          viewLabel: 'Catatan ${widget.label}',
                          viewValue: widget.data['notes'] is Map
                              ? htmlToPlainText(
                                  widget.data['notes'][widget.label])
                              : 'No Data'),
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
