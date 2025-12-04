// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/multiline_form.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:html/parser.dart' as html_parser;

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
  final dyeingData;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;

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
      this.handlePickAttachments,
      this.dyeingData,
      this.handleSelectLengthUnit,
      this.handleSelectWidthUnit});

  @override
  State<ListForm> createState() => _ListFormState();
}

class _ListFormState extends State<ListForm> {
  @override
  void initState() {
    super.initState();
  }

  void showImageDialog(BuildContext context, bool isNew, String filePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(10),
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: isNew
                  ? Image.file(
                      File(filePath),
                      fit: BoxFit.contain,
                    )
                  : Image.network(
                      filePath,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String htmlToPlainText(String htmlString) {
      final document = html_parser.parse(htmlString);
      return document.body?.text ?? '';
    }

    return Form(
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
                  required: true),
            )),
          if (widget.form?['wo_id'] != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomCard(
                    child: Padding(
                  padding: PaddingColumn.screen,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextForm(
                              label: 'Panjang',
                              req: false,
                              isNumber: true,
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
                                    widget.form['length_unit_id']?.toString() ??
                                        '',
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
                              isNumber: true,
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
                                    widget.form['width_unit_id']?.toString() ??
                                        '',
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
                              label: 'Qty Hasil Dyeing',
                              req: true,
                              isNumber: true,
                              controller: widget.qty,
                              handleChange: (value) {
                                setState(() {
                                  widget.qty.text = value.toString();
                                  widget.handleChangeInput('qty', value);
                                });
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SelectForm(
                                label: 'Satuan',
                                onTap: () => widget.handleSelectUnit(),
                                selectedLabel: widget.form['nama_satuan'] ?? '',
                                selectedValue:
                                    widget.form['unit_id']?.toString() ?? '',
                                required: true),
                          )
                        ].separatedBy(SizedBox(
                          width: 16,
                        )),
                      ),
                    ].separatedBy(SizedBox(
                      height: 8,
                    )),
                  ),
                )),
                CustomCard(
                    child: Padding(
                  padding: PaddingColumn.screen,
                  child: Wrap(
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

                        final bool isNew = item.containsKey('path');
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
                              child: GestureDetector(
                                onTap: () {
                                  if (['png', 'jpg', 'jpeg', 'gif']
                                          .contains(extension) &&
                                      filePath != null) {
                                    showImageDialog(context, isNew, filePath);
                                  }
                                },
                                child: previewWidget,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Hapus Lampiran'),
                                      content: const Text(
                                          'Apakah Anda yakin ingin menghapus lampiran ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
                                          child: const Text('Hapus',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    setState(() {
                                      if (isNew) {
                                        (widget.form['attachments'] as List)
                                            .remove(item);
                                      } else {
                                        (widget.data!['attachments'] as List)
                                            .remove(item);
                                      }
                                    });

                                    if (!isNew && item['id'] != null) {
                                      try {} catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "Gagal menghapus dari server: $e")),
                                          );
                                        }
                                      }
                                    }
                                  }
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
                )),
                CustomCard(
                    child: Padding(
                  padding: PaddingColumn.screen,
                  child: MultilineForm(
                    label: 'Catatan',
                    req: false,
                    controller: widget.note,
                    handleChange: (value) {
                      setState(() {
                        widget.note.text = htmlToPlainText(value.toString());
                        widget.handleChangeInput('notes', value);
                      });
                    },
                  ),
                ))
              ].separatedBy(SizedBox(
                height: 16,
              )),
            ),
        ],
      ),
    );
  }
}
