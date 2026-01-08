import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/layout/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class UpdateProcess extends StatefulWidget {
  final id;
  final label;
  final form;
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
      this.isSubmitting});

  @override
  State<UpdateProcess> createState() => _UpdateProcessState();
}

class _UpdateProcessState extends State<UpdateProcess> {
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
          onReturn: () => Navigator.pop(context),
          id: widget.id,
        ),
        body: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                    child: Container(
              padding: CustomTheme().padding('content'),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.data['machine_id'] != null)
                      CustomCard(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectForm(
                            label: 'Mesin',
                            onTap: () async =>
                                await widget.handleSelectMachine(),
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
                                                value: widget.data['maklon'],
                                                onChanged: widget
                                                        .data['can_update']
                                                    ? (value) {
                                                        setState(() {
                                                          widget.data[
                                                              'maklon'] = value;
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
                                    if (widget.data['maklon'] == true)
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
                  ].separatedBy(CustomTheme().vGap('xl'))),
            )))
          ],
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
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Expanded(
                        child: FormButton(
                      label: 'Simpan',
                      isLoading: isSubmitting,
                      onPressed: () async {
                        widget.isSubmitting.value = true;
                        try {
                          await widget
                              .handleUpdate(widget.data['id'].toString());
                        } finally {
                          widget.isSubmitting.value = false;
                        }
                      },
                    ))
                  ].separatedBy(CustomTheme().hGap('xl')),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
