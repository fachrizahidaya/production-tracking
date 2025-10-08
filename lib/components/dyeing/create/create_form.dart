import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/helpers/util/margin_search.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CreateForm extends StatefulWidget {
  final formKey;
  final form;
  final handleSubmit;
  final data;
  final selectWorkOrder;
  final selectMachine;
  final id;

  const CreateForm(
      {super.key,
      this.formKey,
      this.form,
      this.handleSubmit,
      this.data,
      this.selectWorkOrder,
      this.selectMachine,
      this.id});

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  bool get _isFormIncomplete {
    final woId = widget.form?['wo_id'];
    final machineId = widget.form?['machine_id'];

    return woId == null || machineId == null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MarginSearch.screen,
      child: CustomCard(
          child: Form(
              key: widget.formKey,
              child: SingleChildScrollView(
                padding: PaddingColumn.screen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.id == null)
                      SelectForm(
                        label: 'Work Order',
                        onTap: () => widget.selectWorkOrder(),
                        selectedLabel: widget.form?['no_wo'] ?? '',
                        selectedValue: widget.form?['wo_id']?.toString() ?? '',
                        required: false,
                      ),
                    if (widget.form?['wo_id'] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ViewText(
                              viewLabel: 'Nomor',
                              viewValue:
                                  widget.data['wo_no']?.toString() ?? '-'),
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
                              viewValue:
                                  widget.data['notes']?.toString() ?? '-'),
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
                                  widget.data['status']?.toString() ?? '-')
                        ].separatedBy(SizedBox(height: 16)),
                      ),
                    SelectForm(
                      label: 'Mesin',
                      onTap: () => widget.selectMachine(),
                      selectedLabel: widget.form['nama_mesin'] ?? '',
                      selectedValue: widget.form['machine_id'].toString(),
                      required: false,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: FormButton(
                        label: 'Simpan',
                        onPressed: () {
                          widget.handleSubmit();
                        },
                        isDisabled: _isFormIncomplete,
                      ),
                    )
                  ].separatedBy(SizedBox(
                    height: 16,
                  )),
                ),
              ))),
    );
  }
}
