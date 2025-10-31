import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/create/info_tab.dart';
import 'package:textile_tracking/components/dyeing/create/item_tab.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
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
    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: widget.formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.id == null)
                      CustomCard(
                          child: Padding(
                        padding: PaddingColumn.screen,
                        child: SelectForm(
                          label: 'Work Order',
                          onTap: () => widget.selectWorkOrder(),
                          selectedLabel: widget.form?['no_wo'] ?? '',
                          selectedValue:
                              widget.form?['wo_id']?.toString() ?? '',
                          required: false,
                        ),
                      )),
                    if (widget.form?['wo_id'] != null)
                      CustomCard(
                          child: Padding(
                        padding: PaddingColumn.screen,
                        child: DefaultTabController(
                            length: 2,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final isPortrait =
                                    MediaQuery.of(context).orientation ==
                                        Orientation.portrait;
                                final screenHeight =
                                    MediaQuery.of(context).size.height;

                                final boxHeight = isPortrait
                                    ? screenHeight * 0.45
                                    : screenHeight * 0.7;
                                return Column(
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
                                        height: boxHeight,
                                        child: TabBarView(children: [
                                          InfoTab(
                                            data: widget.data,
                                          ),
                                          ItemTab(
                                            data: widget.data,
                                          )
                                        ]))
                                  ],
                                );
                              },
                            )),
                      )),
                    CustomCard(
                        child: Padding(
                      padding: PaddingColumn.screen,
                      child: SelectForm(
                        label: 'Mesin',
                        onTap: () => widget.selectMachine(),
                        selectedLabel: widget.form['nama_mesin'] ?? '',
                        selectedValue: widget.form['machine_id'].toString(),
                        required: false,
                      ),
                    )),
                    // ValueListenableBuilder<bool>(
                    //   valueListenable: widget.isSubmitting,
                    //   builder: (context, isSubmitting, _) {
                    //     return Align(
                    //       alignment: Alignment.center,
                    //       child: FormButton(
                    //         label: 'Simpan',
                    //         isLoading: isSubmitting,
                    //         onPressed: () async {
                    //           widget.isSubmitting.value = true;
                    //           try {
                    //             await widget.handleSubmit();
                    //           } finally {
                    //             widget.isSubmitting.value = false;
                    //           }
                    //         },
                    //         isDisabled: widget.isFormIncomplete,
                    //       ),
                    //     );
                    //   },
                    // ),
                  ].separatedBy(SizedBox(
                    height: 16,
                  ))),
            )));
  }
}
