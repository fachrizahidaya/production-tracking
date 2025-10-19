import 'dart:io';

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/create/info_tab.dart';
import 'package:textile_tracking/components/dyeing/create/item_tab.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/form/multiline_form.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ListForm extends StatefulWidget {
  final formKey;
  final form;
  final data;
  final id;
  final stenterId;
  final length;
  final width;
  final weight;
  final note;
  final handleSelectWo;
  final handleChangeInput;
  final handleSelectUnit;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;
  final handleSelectMachine;
  final isSubmitting;
  final handleSubmit;
  final isFormIncomplete;
  final isChanged;
  final initialWeight;
  final initialLength;
  final initialWidth;
  final initialNotes;
  final allAttachments;
  final handlePickAttachments;
  final stenterData;

  const ListForm(
      {super.key,
      this.formKey,
      this.id,
      this.handleSelectWo,
      this.form,
      this.data,
      this.length,
      this.width,
      this.weight,
      this.note,
      this.handleChangeInput,
      this.handleSelectUnit,
      this.handleSelectLengthUnit,
      this.handleSelectWidthUnit,
      this.isSubmitting,
      this.handleSelectMachine,
      this.handleSubmit,
      this.isFormIncomplete,
      this.stenterId,
      this.isChanged,
      this.initialWeight,
      this.initialLength,
      this.initialWidth,
      this.initialNotes,
      this.allAttachments,
      this.handlePickAttachments,
      this.stenterData});

  @override
  State<ListForm> createState() => _ListFormState();
}

class _ListFormState extends State<ListForm> {
  late String _initialWeight;
  late String _initialLength;
  late String _initialWidth;
  late String _initialNotes;
  late bool _isChanged;

  @override
  void initState() {
    _initialWeight = widget.initialWeight ?? '';
    _initialLength = widget.initialLength ?? '';
    _initialWidth = widget.initialWidth ?? '';
    _initialNotes = widget.initialNotes ?? '';
    _isChanged = widget.isChanged ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        padding: PaddingColumn.screen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.id == null)
              SelectForm(
                  label: 'Work Order',
                  onTap: () => widget.handleSelectWo(),
                  selectedLabel: widget.form['no_wo'] ?? '',
                  selectedValue: widget.form['wo_id']?.toString() ?? '',
                  required: false),
            if (widget.form?['wo_id'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DefaultTabController(
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
                            ]),
                          )
                        ],
                      )),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextForm(
                          label: 'Panjang',
                          req: false,
                          controller: widget.length,
                          handleChange: (value) {
                            setState(() {
                              widget.length.text = value.toString();
                              widget.handleChangeInput('length', value);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SelectForm(
                            label: 'Satuan Panjang',
                            onTap: () => widget.handleSelectLengthUnit(),
                            selectedLabel:
                                widget.form['nama_satuan_panjang'] ?? '',
                            selectedValue:
                                widget.form['length_unit_id']?.toString() ?? '',
                            required: false),
                      ),
                    ].separatedBy(SizedBox(
                      width: 16,
                    )),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextForm(
                          label: 'Lebar',
                          req: false,
                          controller: widget.width,
                          handleChange: (value) {
                            setState(() {
                              widget.width.text = value.toString();
                              widget.handleChangeInput('width', value);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SelectForm(
                            label: 'Satuan Lebar',
                            onTap: () => widget.handleSelectWidthUnit(),
                            selectedLabel:
                                widget.form['nama_satuan_lebar'] ?? '',
                            selectedValue:
                                widget.form['width_unit_id']?.toString() ?? '',
                            required: false),
                      ),
                    ].separatedBy(SizedBox(
                      width: 16,
                    )),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextForm(
                          label: 'Berat',
                          req: false,
                          controller: widget.weight,
                          handleChange: (value) {
                            setState(() {
                              widget.weight.text = value.toString();
                              widget.handleChangeInput('weight', value);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SelectForm(
                            label: 'Satuan Berat',
                            onTap: () => widget.handleSelectUnit(),
                            selectedLabel:
                                widget.form['nama_satuan_berat'] ?? '',
                            selectedValue:
                                widget.form['weight_unit_id']?.toString() ?? '',
                            required: false),
                      )
                    ].separatedBy(SizedBox(
                      width: 16,
                    )),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Lampiran',
                            style: TextStyle(fontSize: 16),
                          ),
                          CustomTheme().hGap('sm'),
                        ],
                      ),
                      ...List.generate(widget.allAttachments.length, (index) {
                        final item = widget.allAttachments[index];

                        if (item['is_add_button'] == true) {
                          return GestureDetector(
                            onTap: widget.handlePickAttachments,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade300,
                              ),
                              child: const Icon(Icons.add,
                                  size: 36, color: Colors.black54),
                            ),
                          );
                        }

                        final bool isNew =
                            item.containsKey('path'); // new local file
                        final String? filePath =
                            isNew ? item['path'] : item['file_path'];
                        final String fileName = isNew
                            ? item['name']
                            : (item['file_name'] ??
                                filePath?.split('/').last ??
                                '');
                        final String extension =
                            fileName.split('.').last.toLowerCase();

                        Widget previewWidget;
                        if (extension == 'pdf') {
                          previewWidget = const Icon(Icons.picture_as_pdf,
                              color: Colors.red, size: 60);
                        } else if (isNew && filePath != null) {
                          previewWidget =
                              Image.file(File(filePath), fit: BoxFit.cover);
                        } else if (filePath != null) {
                          previewWidget =
                              Image.network(filePath, fit: BoxFit.cover);
                        } else {
                          previewWidget = const Icon(Icons.insert_drive_file);
                        }

                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: previewWidget,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isNew) {
                                      (widget.form['attachments'] as List)
                                          .remove(item);
                                    } else {
                                      (widget.data!['attachments'] as List)
                                          .remove(item);
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close,
                                      color: Colors.white, size: 18),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                  MultilineForm(
                    label: 'Catatan',
                    req: false,
                    controller: widget.note,
                    handleChange: (value) {
                      setState(() {
                        widget.note.text = value.toString();
                        widget.handleChangeInput('notes', value);
                      });
                    },
                  ),
                ].separatedBy(SizedBox(
                  height: 16,
                )),
              ),
            ValueListenableBuilder<bool>(
              valueListenable: widget.isSubmitting,
              builder: (context, isSubmitting, _) {
                return Align(
                  alignment: Alignment.center,
                  child: FormButton(
                    label: 'Submit',
                    onPressed: () async {
                      widget.isSubmitting.value = true;
                      try {
                        await widget.handleSubmit(widget.stenterId.toString());
                        setState(() {
                          _initialWeight = widget.weight.text;
                          _initialLength = widget.length.text;
                          _initialWidth = widget.width.text;
                          _initialNotes = widget.note.text;
                          _isChanged = false;
                        });
                      } finally {
                        widget.isSubmitting.value = false;
                      }
                    },
                    isLoading: isSubmitting,
                    isDisabled: widget.isFormIncomplete,
                  ),
                );
              },
            )
          ].separatedBy(SizedBox(
            height: 16,
          )),
        ),
      ),
    );
  }
}
