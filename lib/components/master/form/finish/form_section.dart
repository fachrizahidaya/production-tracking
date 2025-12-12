import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/note_editor.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/layout/attachment_picker.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class FormSection extends StatefulWidget {
  final id;
  final data;
  final form;
  final withItemGrade;
  final withQtyAndWeight;
  final itemGradeOption;
  final handleSelectQtyUnit;
  final length;
  final width;
  final weight;
  final note;
  final handleChangeInput;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;
  final handleSelectUnit;
  final qty;
  final grades;
  final allAttachments;
  final handleSelectWo;
  final handleUpdateGrade;
  final handlePickAttachments;
  final handleDeleteAttachment;
  final handleSelectQtyUnitItem;
  final showImageDialog;

  const FormSection(
      {super.key,
      this.allAttachments,
      this.data,
      this.form,
      this.grades,
      this.handleChangeInput,
      this.handlePickAttachments,
      this.handleSelectLengthUnit,
      this.handleSelectQtyUnit,
      this.handleSelectQtyUnitItem,
      this.handleSelectUnit,
      this.handleSelectWidthUnit,
      this.handleSelectWo,
      this.handleUpdateGrade,
      this.id,
      this.itemGradeOption,
      this.length,
      this.note,
      this.qty,
      this.showImageDialog,
      this.weight,
      this.width,
      this.withItemGrade,
      this.withQtyAndWeight,
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
        'value': 'length'
      },
      {
        'label': 'Lebar',
        'controller': widget.width,
        'onSelect': widget.handleSelectWidthUnit,
        'selectedLabel': widget.form['nama_satuan_lebar'] ?? '',
        'selectedValue': widget.form['width_unit_id']?.toString() ?? '',
        'unitLabel': 'Satuan Lebar',
        'value': 'width'
      },
      {
        'label': 'Berat',
        'controller': widget.weight,
        'onSelect': widget.handleSelectUnit,
        'selectedLabel': widget.form['nama_satuan_berat'] ?? '',
        'selectedValue': widget.form['weight_unit_id']?.toString() ?? '',
        'unitLabel': 'Satuan Berat',
        'value': 'weight'
      },
    ];

    List<Map<String, dynamic>> buildGradeRowConfig(int i) {
      final gradeLabel = (widget.itemGradeOption.firstWhere(
            (e) =>
                e['value'].toString() ==
                widget.grades[i]['item_grade_id'].toString(),
            orElse: () => {'label': ''},
          )['label']) ??
          '';

      return [
        {
          'flex': 2,
          'child': ViewText(
            viewLabel: 'Grade',
            viewValue: gradeLabel,
          )
        },
        {
          'flex': 2,
          'child': TextForm(
            label: 'Jumlah',
            req: true,
            isNumber: true,
            handleChange: (val) => widget.handleUpdateGrade(i, 'qty', val),
          )
        },
        {
          'flex': 2,
          'child': SelectForm(
            label: 'Satuan',
            onTap: () => widget.handleSelectQtyUnit(i),
            selectedLabel: widget.form['grades']?[i]?['unit']?['name'] ?? '',
            selectedValue:
                widget.form['grades']?[i]?['unit_id']?.toString() ?? '',
            required: true,
          )
        },
        {
          'flex': 3,
          'child': TextForm(
            label: 'Catatan',
            req: false,
            handleChange: (val) => widget.handleUpdateGrade(i, 'notes', val),
          )
        },
      ];
    }

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
                required: true),
          )),
        if (widget.form?['wo_id'] != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (widget.withItemGrade == true)
                CustomCard(
                    child: Padding(
                  padding: PaddingColumn.screen,
                  child: Column(
                    children: [
                      if ((widget.itemGradeOption ?? []).isNotEmpty &&
                          widget.grades.isNotEmpty &&
                          widget.grades.length >= widget.itemGradeOption.length)
                        for (int i = 0; i < widget.itemGradeOption.length; i++)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: buildGradeRowConfig(i)
                                .map((col) => Expanded(
                                      flex: col['flex'],
                                      child: col['child'],
                                    ))
                                .toList()
                                .separatedBy(const SizedBox(width: 16)),
                          ),
                    ].separatedBy(const SizedBox(height: 16)),
                  ),
                )),
              if (widget.withItemGrade == false)
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
                                      req: true,
                                      isNumber: true,
                                      controller: row['controller'],
                                      handleChange: (value) {
                                        setState(() {
                                          row['controller'].text =
                                              value.toString();
                                          widget.handleChangeInput(
                                            row['label']
                                                .toString()
                                                .toLowerCase(),
                                            value,
                                          );
                                        });
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
                                      required: true,
                                    ),
                                  ),
                                ].separatedBy(const SizedBox(width: 16)),
                              );
                            }),
                            if (widget.withQtyAndWeight == true)
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextForm(
                                      label: 'Jumlah',
                                      req: true,
                                      isNumber: true,
                                      controller: widget.qty,
                                      handleChange: (value) {
                                        setState(() {
                                          widget.qty.text = value.toString();
                                          widget.handleChangeInput(
                                              'item_qty', value);
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SelectForm(
                                      label: 'Satuan',
                                      onTap: widget.handleSelectQtyUnitItem,
                                      selectedLabel:
                                          widget.form['nama_satuan'] ?? '',
                                      selectedValue:
                                          widget.form['unit_id']?.toString() ??
                                              '',
                                      required: true,
                                    ),
                                  )
                                ].separatedBy(const SizedBox(width: 16)),
                              ),
                          ].separatedBy(const SizedBox(height: 8)),
                        ))),
              CustomCard(
                  child: Padding(
                padding: PaddingColumn.screen,
                child: AttachmentPicker(
                  attachments: widget.allAttachments,
                  onAddAttachment: widget.handlePickAttachments,
                  onDeleteAttachment: widget.handleDeleteAttachment,
                  onPreviewImage: (isNew, filePath) {
                    widget.showImageDialog(context, isNew, filePath);
                  },
                ),
              )),
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
              )),
            ],
          ),
      ],
    );
  }
}
