import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/rework/create_form.dart';
import 'package:textile_tracking/components/dyeing/rework/wo_item_tab.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/info_tab.dart';
import 'package:textile_tracking/helpers/util/format_html.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ReworkInfoTab extends StatefulWidget {
  final id;
  final label;
  final data;
  final form;
  final formKey;
  final handleSubmit;
  final handleSelectMachine;
  final handleSelectWorkOrder;
  final isLoading;

  const ReworkInfoTab(
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
  State<ReworkInfoTab> createState() => _ReworkInfoTabState();
}

class _ReworkInfoTabState extends State<ReworkInfoTab> {
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
                InfoTab(
                  data: widget.data,
                  label: widget.label,
                  isTablet: isTablet,
                  withNote: true,
                ),
              WoItemTab(
                data: widget.data,
              )
            ].separatedBy(CustomTheme().vGap('xl')),
          ),
        );
      },
    );
  }
}
