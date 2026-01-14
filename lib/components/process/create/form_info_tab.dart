import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/create/create_section.dart';
import 'package:textile_tracking/components/process/finish/work_order_item_tab.dart';
import 'package:textile_tracking/components/process/info_tab.dart';
import 'package:textile_tracking/helpers/util/format_html.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

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
              if (widget.form?['wo_id'] != null) ...[
                InfoTab(
                  data: widget.data,
                  label: widget.label,
                  isTablet: isTablet,
                  withNote: true,
                ),
              ],
              WorkOrderItemTab(
                data: widget.data,
              )
            ].separatedBy(CustomTheme().vGap('2xl')),
          ),
        );
      },
    );
  }
}
