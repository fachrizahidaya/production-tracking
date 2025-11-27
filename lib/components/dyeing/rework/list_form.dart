// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/create/info_tab.dart';
import 'package:textile_tracking/components/dyeing/create/item_tab.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ListForm extends StatefulWidget {
  final formKey;
  final form;
  final data;
  final id;
  final dyeingId;
  final length;
  final width;
  final qty;
  final note;
  final handleSelectWo;
  final handleChangeInput;
  final handleSelectUnit;
  final handleSelectMachine;
  final isSubmitting;
  final handleSubmit;
  final isFormIncomplete;
  final isChanged;
  final initialQty;
  final initialLength;
  final initialWidth;
  final initialNotes;
  final allAttachments;
  final handlePickAttachments;

  const ListForm(
      {super.key,
      this.formKey,
      this.id,
      this.handleSelectWo,
      this.form,
      this.data,
      this.length,
      this.width,
      this.qty,
      this.note,
      this.handleChangeInput,
      this.handleSelectUnit,
      this.isSubmitting,
      this.handleSelectMachine,
      this.handleSubmit,
      this.isFormIncomplete,
      this.dyeingId,
      this.isChanged,
      this.initialQty,
      this.initialLength,
      this.initialWidth,
      this.initialNotes,
      this.allAttachments,
      this.handlePickAttachments});

  @override
  State<ListForm> createState() => _ListFormState();
}

class _ListFormState extends State<ListForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: widget.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (widget.id == null)
                    CustomCard(
                        child: Padding(
                      padding: PaddingColumn.screen,
                      child: SelectForm(
                          label: 'Work Order',
                          onTap: () => widget.handleSelectWo(),
                          selectedLabel: widget.form['no_wo'] ?? '',
                          selectedValue: widget.form['wo_id']?.toString() ?? '',
                          required: false),
                    )),
                  if (widget.form?['wo_id'] != null)
                    CustomCard(
                        child: Padding(
                      padding: PaddingColumn.screen,
                      child: DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              TabBar(tabs: [
                                Tab(
                                  text: 'Informasi',
                                ),
                                Tab(
                                  text: 'Barang',
                                ),
                              ]),
                              SizedBox(
                                  height: 400,
                                  child: TabBarView(children: [
                                    InfoTab(
                                      data: widget.data,
                                    ),
                                    ItemTab(
                                      data: widget.data,
                                    )
                                  ]))
                            ],
                          )),
                    )),
                  CustomCard(
                      child: Padding(
                    padding: PaddingColumn.screen,
                    child: SelectForm(
                      label: 'Mesin',
                      onTap: () => widget.handleSelectMachine(),
                      selectedLabel: widget.form['nama_mesin'] ?? '',
                      selectedValue: widget.form['machine_id'].toString(),
                      required: false,
                    ),
                  )),
                ].separatedBy(SizedBox(
                  height: 16,
                )),
              ),
            )));
  }
}
