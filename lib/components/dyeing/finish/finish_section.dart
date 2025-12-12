import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/finish/form_tab.dart';
import 'package:textile_tracking/components/dyeing/finish/info_tab.dart';
import 'package:textile_tracking/components/dyeing/finish/item_tab.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class FinishSection extends StatefulWidget {
  final id;
  final processId;
  final form;
  final formKey;
  final dyeingId;
  final dyeingData;
  final woData;
  final handleSubmit;
  final handleChangeInput;
  final isSubmitting;
  final firstLoading;
  final lengthController;
  final widthController;
  final noteController;
  final qtyController;
  final selectUnit;
  final selectWidthUnit;
  final selectLengthUnit;
  final selectWorkOrder;

  const FinishSection(
      {super.key,
      this.id,
      this.dyeingData,
      this.dyeingId,
      this.firstLoading,
      this.form,
      this.formKey,
      this.handleChangeInput,
      this.handleSubmit,
      this.isSubmitting,
      this.lengthController,
      this.noteController,
      this.processId,
      this.qtyController,
      this.selectLengthUnit,
      this.selectUnit,
      this.selectWidthUnit,
      this.selectWorkOrder,
      this.widthController,
      this.woData});

  @override
  State<FinishSection> createState() => _FinishSectionState();
}

class _FinishSectionState extends State<FinishSection> {
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
          title: 'Selesai Dyeing',
          onReturn: () {
            Navigator.pop(context);
          },
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(tabs: [
                Tab(
                  text: 'Form',
                ),
                Tab(
                  text: 'Informasi',
                ),
                Tab(
                  text: 'Barang',
                ),
              ]),
            ),
            Expanded(
              child: TabBarView(children: [
                InfoTab(
                  data: widget.woData,
                  id: widget.id,
                  isLoading: widget.firstLoading,
                  form: widget.form,
                  formKey: widget.formKey,
                  handleSubmit: widget.handleSubmit,
                  handleSelectMachine: null,
                  handleSelectWorkOrder: widget.selectWorkOrder,
                  handleSelectLengthUnit: widget.selectLengthUnit,
                  handleChangeInput: widget.handleChangeInput,
                  handleSelectUnit: widget.selectUnit,
                  handleSelectWidthUnit: widget.selectWidthUnit,
                  qty: widget.qtyController,
                  dyeingData: widget.dyeingData,
                  dyeingId: widget.dyeingId,
                  length: widget.lengthController,
                  width: widget.widthController,
                  note: widget.noteController,
                ),
                FormTab(
                  data: widget.woData,
                ),
                ItemTab(
                  data: widget.woData,
                ),
              ]),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: PaddingColumn.screen,
            color: Colors.white,
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
                      label: 'Selesai',
                      isDisabled: widget.form?['wo_id'] == null ||
                              widget.form?['qty'] == null ||
                              widget.form?['unit_id'] == null
                          ? true
                          : false,
                      isLoading: isSubmitting,
                      onPressed: () async {
                        widget.isSubmitting.value = true;
                        try {
                          if (!widget.formKey.currentState!.validate()) {
                            return;
                          }

                          await widget.handleSubmit(
                              widget.dyeingData['id'] != null
                                  ? widget.dyeingData['id'].toString()
                                  : widget.processId);
                        } finally {
                          widget.isSubmitting.value = false;
                        }
                      },
                    ))
                  ].separatedBy(SizedBox(
                    width: 16,
                  )),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
