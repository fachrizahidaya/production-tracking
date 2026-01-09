import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ListForm extends StatefulWidget {
  final formKey;
  final id;
  final form;
  final data;
  final attachments;
  final selectWorkOrder;
  final selectMachine;
  final isSubmitting;
  final isFormIncomplete;
  final handleSubmit;
  final handlePickAttachments;

  const ListForm(
      {super.key,
      this.formKey,
      this.id,
      this.form,
      this.data,
      this.selectWorkOrder,
      this.selectMachine,
      this.isSubmitting,
      this.isFormIncomplete,
      this.handleSubmit,
      this.handlePickAttachments,
      this.attachments});

  @override
  State<ListForm> createState() => _ListFormState();
}

class _ListFormState extends State<ListForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.id == null)
              CustomCard(
                  child: SelectForm(
                label: 'Work Order',
                onTap: () => widget.selectWorkOrder(),
                selectedLabel: widget.form?['no_wo'] ?? '',
                selectedValue: widget.form?['wo_id']?.toString() ?? '',
                required: true,
              )),
            CustomCard(
                child: SelectForm(
              label: 'Mesin',
              onTap: () => widget.selectMachine(),
              selectedLabel: widget.form['nama_mesin'] ?? '',
              selectedValue: widget.form['machine_id'].toString(),
              required: true,
            )),
          ].separatedBy(CustomTheme().vGap('xl'))),
    );
  }
}
