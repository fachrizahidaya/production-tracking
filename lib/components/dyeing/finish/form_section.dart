import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/note_editor.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/layout/attachment_picker.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class FormSection extends StatefulWidget {
  final id;
  final form;
  final data;
  final length;
  final width;
  final qty;
  final note;
  final allAttachments;
  final handleChangeInput;
  final handleSelectWo;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;
  final handleSelectUnit;
  final handlePickAttachments;
  final handleDeleteAttachment;
  final showImageDialog;

  const FormSection(
      {super.key,
      this.id,
      this.allAttachments,
      this.data,
      this.form,
      this.handleChangeInput,
      this.handlePickAttachments,
      this.handleSelectLengthUnit,
      this.handleSelectUnit,
      this.handleSelectWidthUnit,
      this.handleSelectWo,
      this.length,
      this.note,
      this.qty,
      this.showImageDialog,
      this.width,
      this.handleDeleteAttachment});

  @override
  State<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> formRows = [
      {
        'label': 'Panjang',
        'controller': widget.length,
        'onSelect': widget.handleSelectLengthUnit,
        'selectedLabel': widget.form['nama_satuan_panjang'] ?? '',
        'selectedValue': widget.form['length_unit_id']?.toString() ?? '',
        'unitLabel': 'Satuan Panjang',
        'value': 'length',
        'req': false
      },
      {
        'label': 'Lebar',
        'controller': widget.width,
        'onSelect': widget.handleSelectWidthUnit,
        'selectedLabel': widget.form['nama_satuan_lebar'] ?? '',
        'selectedValue': widget.form['width_unit_id']?.toString() ?? '',
        'unitLabel': 'Satuan Lebar',
        'value': 'width',
        'req': false
      },
      {
        'label': 'Qty Hasil Dyeing',
        'controller': widget.qty,
        'onSelect': widget.handleSelectUnit,
        'selectedLabel': widget.form['nama_satuan'] ?? '',
        'selectedValue': widget.form['unit_id']?.toString() ?? '',
        'unitLabel': 'Satuan',
        'value': 'qty',
        'req': true
      },
    ];

    return Column(
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
              required: true,
              validator: (value) {
                if ((value == null || value.isEmpty)) {
                  return 'is required';
                }
                return null;
              },
            ),
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
                    ...formRows.map((row) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextForm(
                              label: row['label'],
                              req: row['req'],
                              isNumber: true,
                              controller: row['controller'],
                              handleChange: (value) {
                                setState(() {
                                  row['controller'].text = value.toString();
                                  widget.handleChangeInput(
                                    row['value'],
                                    value,
                                  );
                                });
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Must filled';
                                }
                                return null;
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SelectForm(
                              label: row['unitLabel'],
                              onTap: row['onSelect'],
                              selectedLabel: row['selectedLabel'],
                              selectedValue: row['selectedValue'],
                              required: row['req'],
                              validator: (value) {
                                if ((value == null || value.isEmpty)) {
                                  return 'is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ].separatedBy(const SizedBox(width: 16)),
                      );
                    }),
                  ].separatedBy(SizedBox(
                    height: 8,
                  )),
                ),
              )),
              CustomCard(
                  child: Padding(
                      padding: PaddingColumn.screen,
                      child: AttachmentPicker(
                          attachments: widget.allAttachments,
                          onAddAttachment: widget.handlePickAttachments,
                          onDeleteAttachment: widget.handleDeleteAttachment,
                          onPreviewImage: (isNew, filePath) {
                            widget.showImageDialog(context, isNew, filePath);
                          }))),
              CustomCard(
                child: Padding(
                  padding: PaddingColumn.screen,
                  child: NoteEditor(
                    controller: widget.note,
                    formKey: 'notes',
                    label: 'Catatan',
                    form: widget.form,
                    onChanged: (value) =>
                        widget.handleChangeInput('notes', value),
                  ),
                ),
              )
            ].separatedBy(SizedBox(
              height: 16,
            )),
          ),
      ],
    );
  }
}
