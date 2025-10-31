import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/components/master/layout/finish_info_tab.dart';
import 'package:textile_tracking/components/master/layout/finish_item_tab.dart';
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
  final isMaklon;
  final maklon;
  final withMaklonOrMachine;
  final withOnlyMaklon;
  final withNoMaklonOrMachine;

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
      this.attachments,
      this.maklon,
      this.isMaklon = false,
      this.withMaklonOrMachine = false,
      this.withOnlyMaklon = false,
      this.withNoMaklonOrMachine = false});

  @override
  State<ListForm> createState() => _ListFormState();
}

class _ListFormState extends State<ListForm> {
  bool _isMaklon = false;

  @override
  Widget build(BuildContext context) {
    if (widget.withNoMaklonOrMachine == true) {
      return SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: widget.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCard(
                        child: Padding(
                      padding: PaddingColumn.screen,
                      child: SelectForm(
                        label: 'Work Order',
                        onTap: () => widget.selectWorkOrder(),
                        selectedLabel: widget.form?['no_wo'] ?? '',
                        selectedValue: widget.form?['wo_id']?.toString() ?? '',
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
                                  const TabBar(
                                    tabs: [
                                      Tab(text: 'Informasi'),
                                      Tab(text: 'Barang'),
                                    ],
                                  ),
                                  SizedBox(
                                    height: boxHeight,
                                    child: TabBarView(
                                      children: [
                                        FinishInfoTab(data: widget.data),
                                        FinishItemTab(data: widget.data),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
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
                  ].separatedBy(const SizedBox(height: 16)),
                ),
              )));
    }

    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(8),
            child: Form(
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
                        selectedValue: widget.form?['wo_id']?.toString() ?? '',
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
                                const TabBar(
                                  tabs: [
                                    Tab(text: 'Informasi'),
                                    Tab(text: 'Barang'),
                                  ],
                                ),
                                SizedBox(
                                  height: boxHeight,
                                  child: TabBarView(
                                    children: [
                                      FinishInfoTab(data: widget.data),
                                      FinishItemTab(data: widget.data),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    )),
                  if (widget.withOnlyMaklon == true)
                    CustomCard(
                        child: Padding(
                      padding: PaddingColumn.screen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Maklon',
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              Switch(
                                value: _isMaklon,
                                onChanged: (value) {
                                  setState(() {
                                    _isMaklon = value;
                                    widget.form['maklon'] = value;
                                  });
                                },
                                activeColor: Colors.green,
                                inactiveThumbColor: Colors.redAccent,
                              ),
                              Text(_isMaklon ? 'Ya' : 'Tidak'),
                            ].separatedBy(const SizedBox(width: 8)),
                          ),
                          // if (_isMaklon)
                          //   TextForm(
                          //     label: 'Nama Maklon',
                          //     req: false,
                          //     controller: widget.maklon,
                          //     handleChange: (value) {
                          //       setState(() {
                          //         widget.maklon.text = value.toString();
                          //         widget.form['maklon_name'] = value.toString();
                          //       });
                          //     },
                          //   ),
                        ],
                      ),
                    ))
                  else if (widget.withMaklonOrMachine == true)
                    CustomCard(
                        child: Padding(
                            padding: PaddingColumn.screen,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Maklon',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Row(
                                  children: [
                                    Switch(
                                      value: _isMaklon,
                                      onChanged: (value) {
                                        setState(() {
                                          _isMaklon = value;
                                          widget.form['maklon'] = value;
                                        });
                                      },
                                      activeColor: Colors.green,
                                      inactiveThumbColor: Colors.redAccent,
                                    ),
                                    Text(_isMaklon ? 'Ya' : 'Tidak'),
                                  ].separatedBy(const SizedBox(width: 8)),
                                ),
                                if (_isMaklon)
                                  TextForm(
                                    label: 'Nama Maklon',
                                    req: false,
                                    controller: widget.maklon,
                                    handleChange: (value) {
                                      setState(() {
                                        widget.maklon.text = value.toString();
                                        widget.form['maklon_name'] =
                                            value.toString();
                                      });
                                    },
                                  )
                                else
                                  SelectForm(
                                    label: 'Mesin',
                                    onTap: () => widget.selectMachine(),
                                    selectedLabel:
                                        widget.form['nama_mesin'] ?? '',
                                    selectedValue:
                                        widget.form['machine_id'].toString(),
                                    required: false,
                                  ),
                              ],
                            )))
                  else if (widget.isMaklon == true)
                    CustomCard(
                        child: Padding(
                            padding: PaddingColumn.screen,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Maklon',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Switch(
                                      value: _isMaklon,
                                      onChanged: (value) {
                                        setState(() {
                                          _isMaklon = value;
                                          widget.form['maklon'] = value;
                                        });
                                      },
                                      activeColor: Colors.green,
                                      inactiveThumbColor: Colors.redAccent,
                                    ),
                                    Text(_isMaklon ? 'Yes' : 'No'),
                                  ].separatedBy(const SizedBox(width: 8)),
                                ),
                              ],
                            )))
                  else
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
                  if (_isMaklon && widget.withMaklonOrMachine != true)
                    CustomCard(
                        child: Padding(
                      padding: PaddingColumn.screen,
                      child: TextForm(
                        label: 'Nama Maklon',
                        req: false,
                        controller: widget.maklon,
                        handleChange: (value) {
                          setState(() {
                            widget.form['maklon_name'] = value.toString();
                          });
                        },
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
                ].separatedBy(const SizedBox(height: 16)),
              ),
            )));
  }
}
