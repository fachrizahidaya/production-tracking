// ignore_for_file: file_names, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/update/detail_work_order.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class UpdateProcess extends StatefulWidget {
  final id;
  final label;
  final form;
  final formKey;
  final data;
  final handleUpdate;
  final handleSelectMachine;
  final withMaklon;
  final maklon;
  final qtyItem;
  final handleChangeInput;
  final withQtyAndWeight;
  final handleSelectQtyItemUnit;
  final length;
  final width;
  final weight;
  final handleSelectUnit;
  final handleSelectWidthUnit;
  final handleSelectLengthUnit;
  final isSubmitting;
  final forDyeing;

  const UpdateProcess(
      {super.key,
      this.label,
      this.id,
      this.form,
      this.withMaklon,
      this.handleSelectMachine,
      this.data,
      this.maklon,
      this.handleChangeInput,
      this.qtyItem,
      this.handleSelectQtyItemUnit,
      this.withQtyAndWeight,
      this.length,
      this.weight,
      this.width,
      this.handleUpdate,
      this.handleSelectUnit,
      this.handleSelectWidthUnit,
      this.handleSelectLengthUnit,
      this.isSubmitting,
      this.formKey,
      this.forDyeing});

  @override
  State<UpdateProcess> createState() => _UpdateProcessState();
}

class _UpdateProcessState extends State<UpdateProcess> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  bool _isMaklon = false;

  @override
  void initState() {
    super.initState();
    _isMaklon = widget.data['maklon'] ?? false;
  }

  Future<void> _handleCancel(BuildContext context) async {
    if (context.mounted) {
      showConfirmationDialog(
          context: context,
          isLoading: _isLoading,
          onConfirm: () async {
            await Future.delayed(const Duration(milliseconds: 200));
            Navigator.pop(context);
            Navigator.pop(context);
          },
          title: 'Batal Edit Proses ${widget.label}',
          message: 'Anda yakin ingin kembali? Semua perubahan tidak disimpan',
          buttonBackground: CustomTheme().buttonColor('danger'));
    }
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (context.mounted) {
      showConfirmationDialog(
          context: context,
          isLoading: widget.isSubmitting,
          onConfirm: () async {
            await Future.delayed(const Duration(milliseconds: 200));
            widget.isSubmitting.value = true;
            try {
              if (_isMaklon == true) {
                widget.form['machine_id'] = null;
                widget.form['nama_mesin'] = null;
                widget.form['maklon'] = true;
              } else if (_isMaklon == false) {
                widget.form['maklon_name'] = null;
                widget.form['maklon'] = false;
              }

              await widget.handleUpdate(widget.data['id'].toString());
            } finally {
              widget.isSubmitting.value = false;
            }
          },
          title: 'Edit Proses ${widget.label}',
          message: 'Anda yakin ingin mengubah proses?',
          buttonBackground: CustomTheme().buttonColor('primary'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFf9fafc),
          appBar: CustomAppBar(
            title: 'Edit ${widget.label}',
            onReturn: () => _handleCancel(context),
            id: widget.id,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
              padding: CustomTheme().padding('content'),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.data['machine_id'] != null && _isMaklon == false)
                      CustomCard(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectForm(
                            label: 'Mesin',
                            onTap: () => widget.handleSelectMachine(),
                            selectedLabel: widget.form['nama_mesin'] ?? '',
                            selectedValue: widget.form['machine_id'].toString(),
                            required: false,
                          )
                        ].separatedBy(CustomTheme().vGap('lg')),
                      )),
                    if (widget.data['maklon'] != null)
                      CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (widget.withMaklon == true)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Maklon',
                                            style: TextStyle(
                                                fontSize: CustomTheme()
                                                    .fontSize('lg')),
                                          ),
                                          Row(
                                            children: [
                                              Switch(
                                                value: _isMaklon,
                                                onChanged: widget
                                                        .data['can_update']
                                                    ? (value) {
                                                        setState(() {
                                                          _isMaklon = value;
                                                          widget.form[
                                                              'maklon'] = value;
                                                        });
                                                      }
                                                    : null,
                                                activeColor: Colors.green,
                                                inactiveThumbColor:
                                                    Colors.redAccent,
                                              ),
                                              Text(widget.data['maklon']
                                                  ? 'Ya'
                                                  : 'Tidak'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    if (_isMaklon == true)
                                      TextForm(
                                        label: 'Nama Maklon',
                                        req: false,
                                        controller: widget.maklon,
                                        handleChange: (value) {
                                          setState(() {
                                            widget.maklon.text =
                                                value.toString();
                                            widget.form['maklon_name'] =
                                                value.toString();
                                          });
                                        },
                                      ),
                                  ].separatedBy(CustomTheme().vGap('lg')),
                                ),
                              ].separatedBy(CustomTheme().vGap('lg')),
                            ),
                          ].separatedBy(CustomTheme().vGap('lg')),
                        ),
                      ),
                    DetailWorkOrder(
                      data: widget.data['work_orders'],
                      form: widget.form,
                      withQtyAndWeight: widget.withQtyAndWeight,
                      label: widget.label,
                      forDyeing: widget.forDyeing,
                      withNote: true,
                    )
                  ].separatedBy(CustomTheme().vGap('xl'))),
            )),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              color: Colors.white,
              padding: CustomTheme().padding('content'),
              child: ValueListenableBuilder<bool>(
                valueListenable: widget.isSubmitting,
                builder: (context, isSubmitting, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: CancelButton(
                          label: 'Batal',
                          onPressed: () => _handleCancel(context),
                          customHeight: 48.0,
                        ),
                      ),
                      Expanded(
                          child: FormButton(
                        label: 'Simpan',
                        onPressed: () {
                          _handleSubmit(context);
                        },
                        customHeight: 48.0,
                      ))
                    ].separatedBy(CustomTheme().hGap('xl')),
                  );
                },
              ),
            ),
          ),
        ));
  }
}
