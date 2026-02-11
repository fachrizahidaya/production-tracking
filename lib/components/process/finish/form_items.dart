// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/helpers/util/attachment_picker.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/note_editor.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class FormItems extends StatefulWidget {
  final id;
  final form;
  final withItemGrade;
  final withQtyAndWeight;
  final forDyeing;
  final forPacking;
  final itemGradeOption;
  final handleSelectQtyUnit;
  final length;
  final width;
  final weight;
  final weightDozen;
  final gsm;
  final totalWeight;
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
  final handleSelectQtyUnitDyeing;
  final showImageDialog;
  final validateWeight;
  final validateQty;
  final weightWarning;
  final qtyWarning;
  final label;
  final data;
  final processData;
  final greigeQty;
  final handleTotalItemQty;
  final handleRemainingQtyForGrade;

  const FormItems(
      {super.key,
      this.allAttachments,
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
      this.withItemGrade = false,
      this.withQtyAndWeight = false,
      this.handleDeleteAttachment,
      this.validateWeight,
      this.weightWarning,
      this.validateQty,
      this.qtyWarning,
      this.forDyeing = false,
      this.label,
      this.handleSelectQtyUnitDyeing,
      this.data,
      this.forPacking = false,
      this.greigeQty,
      this.gsm,
      this.totalWeight,
      this.weightDozen,
      this.handleRemainingQtyForGrade,
      this.handleTotalItemQty,
      this.processData});

  @override
  State<FormItems> createState() => _FormItemsState();
}

class _FormItemsState extends State<FormItems> {
  double beratLusin = 0;
  double gsm = 0;
  double totalBerat = 0;

  @override
  void initState() {
    super.initState();
  }

  String getGradeLabel(int i) {
    return widget.itemGradeOption.firstWhere(
          (e) =>
              e['value'].toString() ==
              widget.grades[i]['item_grade_id'].toString(),
          orElse: () => {'label': ''},
        )['label'] ??
        '';
  }

  double getGradePercentage(int index) {
    final totalQty = widget.handleTotalItemQty();
    if (totalQty == 0) return 0;

    final gradeQty = double.tryParse(
          widget.form['grades']?[index]?['qty']?.toString() ?? '0',
        ) ??
        0;

    return (gradeQty / totalQty) * 100;
  }

  double getMaxQtyFromGrades() {
    final grades = widget.form['grades'] as List<dynamic>?;

    if (grades == null || grades.isEmpty) return 0;

    return grades.fold<double>(0, (sum, grade) {
      final qty = double.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
      return sum + qty;
    });
  }

  void calculateFromBeratLusin(double value) {
    final maxQty = getMaxQtyFromGrades();

    final size = widget.data['items'][0]['variants'][1]['value'];
    final panjang = int.tryParse(size.split('X')[0]) ?? 0;
    final lebar = int.tryParse(size.split('X')[1]) ?? 0;

    setState(() {
      beratLusin = value;

      if (panjang == 0 || lebar == 0) {
        gsm = 0;
      } else {
        gsm = (beratLusin * 10000000) / (12 * panjang * lebar);
      }

      totalBerat = maxQty == 0 ? 0 : (beratLusin / 12) * maxQty;

      widget.gsm.text = gsm.toStringAsFixed(2);
      widget.totalWeight.text = totalBerat.toStringAsFixed(2);

      widget.handleChangeInput('gsm', gsm.toStringAsFixed(2));
      widget.handleChangeInput(
        'total_weight',
        totalBerat.toStringAsFixed(2),
      );
    });
  }

  Widget buildGradeCard(int i) {
    final gradeLabel = getGradeLabel(i);
    final percentage = getGradePercentage(i);
    final maxQty = widget.handleRemainingQtyForGrade(i);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          gradeLabel,
          style: TextStyle(
              fontSize: 16, fontWeight: CustomTheme().fontWeight('semibold')),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: TextForm(
                label: 'Qty (PCS)',
                req: true,
                isNumber: true,
                handleChange: (val) {
                  widget.handleUpdateGrade(i, 'qty', val);
                  setState(() {
                    final input =
                        double.tryParse(widget.weightDozen.text.toString()) ??
                            0;
                    if (input > 0) {
                      calculateFromBeratLusin(input);
                    }
                  });
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: TextForm(
                label: 'Max Qty (PCS)',
                isDisabled: true,
                controller: TextEditingController(
                  text: maxQty.toInt().toString(),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: TextForm(
                label: 'Persentase (%)',
                isDisabled: true,
                controller: TextEditingController(
                  text: percentage.round().toString(),
                ),
              ),
            ),
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
        TextForm(
          label: 'Catatan',
          req: false,
          handleChange: (val) => widget.handleUpdateGrade(i, 'notes', val),
        ),
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }

  Widget _buildFormField(Map<String, dynamic> row) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: row['staticUnit'] != null ? 4 : 3,
              child: TextForm(
                label: row['label'],
                req: row['req'],
                isNumber: true,
                controller: row['controller'],
                handleChange: (value) {
                  final safeValue =
                      (value == null || value.toString().trim().isEmpty)
                          ? '0'
                          : value.toString();

                  setState(() {
                    row['controller'].text = safeValue;
                    widget.handleChangeInput(row['value'], safeValue);

                    if (row['value'] == 'length') {
                      widget.handleChangeInput('length_unit_id', 4);
                    }

                    if (row['value'] == 'width') {
                      widget.handleChangeInput('width_unit_id', 4);
                    }

                    if (row['value'] == 'weight') {
                      widget.validateWeight(value);
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '${row['label']} wajib diisi';
                  }
                  return null;
                },
              ),
            ),
            if (row['withSelectUnit'] == true) ...[
              CustomTheme().hGap('xl'),
              Expanded(
                flex: 1,
                child: SelectForm(
                  label: row['unitLabel'],
                  onTap: row['onSelect'],
                  selectedLabel: row['selectedLabel'],
                  selectedValue: row['selectedValue'],
                  required: row['req'],
                ),
              ),
            ],
          ],
        ),
        if (row['value'] == 'weight' && widget.weightWarning != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.weightWarning!,
              style: TextStyle(
                color: CustomTheme().colors('warning'),
                fontSize: CustomTheme().fontSize('sm'),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> formRows = [
      {
        'label': 'Panjang (CM)',
        'controller': widget.length,
        'onSelect': widget.handleSelectLengthUnit,
        'selectedLabel': widget.form['nama_satuan_panjang'] ?? '',
        'selectedValue': widget.form['length_unit_id']?.toString() ?? '',
        'unitLabel': 'Satuan Panjang',
        'value': 'length',
        'req': false,
        'withSelectUnit': false,
        'staticUnit': 'CM'
      },
      {
        'label': 'Lebar (CM)',
        'controller': widget.width,
        'onSelect': widget.handleSelectWidthUnit,
        'selectedLabel': widget.form['nama_satuan_lebar'] ?? '',
        'selectedValue': widget.form['width_unit_id']?.toString() ?? '',
        'unitLabel': 'Satuan Lebar',
        'value': 'width',
        'req': false,
        'withSelectUnit': false,
        'staticUnit': 'CM'
      },
      if (widget.forDyeing == false)
        {
          'label': 'Berat',
          'controller': widget.weight,
          'onSelect': widget.handleSelectUnit,
          'selectedLabel': widget.form['nama_satuan_berat'] ?? '',
          'selectedValue': widget.form['weight_unit_id']?.toString() ?? '',
          'unitLabel': 'Satuan Berat',
          'value': 'weight',
          'req': true,
          'withSelectUnit': true,
          'staticUnit': 'KG'
        },
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (widget.id == null)
          TemplateCard(
            title: 'Work Order',
            icon: Icons.paste_outlined,
            child: SelectForm(
              label: 'Work Order',
              onTap: () => widget.handleSelectWo(),
              selectedLabel: widget.form['no_wo'] ?? '',
              selectedValue: widget.form['wo_id']?.toString() ?? '',
              required: true,
              validator: (value) {
                if ((value == null || value.isEmpty)) {
                  return 'Work Order wajib dipilih';
                }
                return null;
              },
            ),
          ),
        if (widget.processData['rework'] == true)
          TemplateCard(
              title: 'Referensi Rework',
              icon: Icons.replay_outlined,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ViewText(
                      viewLabel: 'No. Dyeing',
                      viewValue: widget.processData['rework_reference']
                              ['dyeing_no'] ??
                          '-'),
                  ViewText(
                      viewLabel: 'Mesin',
                      viewValue: widget.processData['rework_reference']
                              ['machine']['name'] ??
                          '-'),
                ].separatedBy(CustomTheme().hGap('xl')),
              )),
        if (widget.form?['wo_id'] != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (widget.withItemGrade == true)
                TemplateCard(
                  title: 'Grades',
                  icon: Icons.grade_outlined,
                  child: Column(
                    children: [
                      if ((widget.itemGradeOption ?? []).isNotEmpty &&
                          widget.grades.isNotEmpty &&
                          widget.grades.length >= widget.itemGradeOption.length)
                        for (int i = 0; i < widget.itemGradeOption.length; i++)
                          buildGradeCard(i),
                    ].separatedBy(CustomTheme().vGap('2xl')),
                  ),
                ),
              if (widget.withItemGrade == false)
                TemplateCard(
                  title: 'Informasi Proses',
                  icon: Icons.list_alt_outlined,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: _buildFormField(formRows.firstWhere(
                              (e) => e['value'] == 'length',
                            )),
                          ),
                          CustomTheme().hGap('xl'),
                          Expanded(
                            child: _buildFormField(formRows.firstWhere(
                              (e) => e['value'] == 'width',
                            )),
                          ),
                        ],
                      ),
                      ...formRows
                          .where((row) =>
                              row['value'] != 'length' &&
                              row['value'] != 'width')
                          .map((row) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: row['staticUnit'] != null ? 4 : 3,
                                  child: Column(
                                    children: [
                                      TextForm(
                                        label: row['label'],
                                        req: row['req'],
                                        isNumber: true,
                                        controller: row['controller'],
                                        handleChange: (value) {
                                          final safeValue = (value == null ||
                                                  value
                                                      .toString()
                                                      .trim()
                                                      .isEmpty)
                                              ? '0'
                                              : value.toString();

                                          setState(() {
                                            row['controller'].text = safeValue;
                                            widget.handleChangeInput(
                                              row['value'],
                                              safeValue,
                                            );

                                            if (row['value'] == 'length') {
                                              widget.handleChangeInput(
                                                  'length_unit_id', 4);
                                            }

                                            if (row['value'] == 'width') {
                                              widget.handleChangeInput(
                                                  'width_unit_id', 4);
                                            }

                                            if (widget.withQtyAndWeight ==
                                                    false &&
                                                row['value'] == 'weight') {
                                              widget.validateWeight(value);
                                            }
                                            if (widget.withQtyAndWeight ==
                                                    true &&
                                                row['value'] == 'weight') {
                                              widget.validateWeight(value);
                                            }
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return '${row['label']} wajib diisi';
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                if (row['withSelectUnit'] == true)
                                  Expanded(
                                    flex: 1,
                                    child: SelectForm(
                                      isDisabled: false,
                                      label: row['unitLabel'],
                                      onTap: row['onSelect'],
                                      selectedLabel: row['selectedLabel'],
                                      selectedValue: row['selectedValue'],
                                      required: row['req'],
                                      validator: (value) {
                                        if ((value == null || value.isEmpty)) {
                                          return '${row['unitLabel']} wajib dipilih';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                              ].separatedBy(CustomTheme().hGap('xl')),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      if (row['value'] == 'weight' &&
                                          widget.weightWarning != null)
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                widget.weightWarning ?? '-',
                                                style: TextStyle(
                                                  color: CustomTheme()
                                                      .colors('warning'),
                                                  fontSize: CustomTheme()
                                                      .fontSize('sm'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 1, child: Container())
                              ].separatedBy(CustomTheme().hGap('xl')),
                            ),
                          ],
                        );
                      }),
                      if (widget.withQtyAndWeight == true)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      TextForm(
                                        label: 'Qty Hasil ${widget.label}',
                                        req: true,
                                        isNumber: true,
                                        controller: widget.qty,
                                        handleChange: (value) {
                                          final safeValue = (value == null ||
                                                  value
                                                      .toString()
                                                      .trim()
                                                      .isEmpty)
                                              ? '0'
                                              : value.toString();

                                          setState(() {
                                            widget.qty.text = safeValue;
                                            widget.handleChangeInput(
                                                'item_qty', safeValue);
                                            widget.validateQty(safeValue);
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Qty wajib diisi';
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SelectForm(
                                    label: 'Satuan',
                                    onTap: widget.handleSelectQtyUnitItem,
                                    selectedLabel:
                                        widget.form['nama_satuan'] ?? '',
                                    selectedValue: widget.form['item_unit_id']
                                            ?.toString() ??
                                        '',
                                    required: true,
                                    validator: (value) {
                                      if ((value == null || value.isEmpty)) {
                                        return 'Satuan wajib dipilih';
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              ].separatedBy(CustomTheme().hGap('xl')),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      if (widget.qtyWarning != null)
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                widget.qtyWarning ?? '-',
                                                style: TextStyle(
                                                  color: CustomTheme()
                                                      .colors('warning'),
                                                  fontSize: CustomTheme()
                                                      .fontSize('sm'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 1, child: Container())
                              ].separatedBy(CustomTheme().hGap('xl')),
                            ),
                          ],
                        ),
                      if (widget.forDyeing == true)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      TextForm(
                                        label: 'Qty Hasil ${widget.label}',
                                        req: true,
                                        isNumber: true,
                                        controller: widget.qty,
                                        handleChange: (value) {
                                          final safeValue = (value == null ||
                                                  value
                                                      .toString()
                                                      .trim()
                                                      .isEmpty)
                                              ? '0'
                                              : value.toString();

                                          setState(() {
                                            widget.qty.text = safeValue;
                                            widget.handleChangeInput(
                                                'qty', safeValue);
                                            widget.validateWeight(safeValue);
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Qty wajib diisi';
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SelectForm(
                                    label: 'Satuan',
                                    onTap: widget.handleSelectQtyUnitDyeing,
                                    selectedLabel:
                                        widget.form['nama_satuan'] ?? '',
                                    selectedValue:
                                        widget.form['unit_id']?.toString() ??
                                            '',
                                    required: true,
                                    validator: (value) {
                                      if ((value == null || value.isEmpty)) {
                                        return 'Satuan wajib dipilih';
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              ].separatedBy(CustomTheme().hGap('xl')),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      if (widget.weightWarning != null)
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                widget.weightWarning ?? '-',
                                                style: TextStyle(
                                                  color: CustomTheme()
                                                      .colors('warning'),
                                                  fontSize: CustomTheme()
                                                      .fontSize('sm'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 1, child: Container())
                              ].separatedBy(CustomTheme().hGap('xl')),
                            ),
                          ],
                        ),
                    ].separatedBy(CustomTheme().vGap('lg')),
                  ),
                ),
              if (widget.forPacking == true)
                TemplateCard(
                  title: 'GSM & Total Berat',
                  icon: Icons.scale_outlined,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextForm(
                            label: 'Berat 1 Lusin (KG)',
                            req: true,
                            isNumber: true,
                            controller: widget.weightDozen,
                            handleChange: (val) {
                              final safeValue =
                                  (val == null || val.toString().trim().isEmpty)
                                      ? '0'
                                      : val.toString();
                              widget.weightDozen.text = safeValue;
                              widget.handleChangeInput(
                                  'weight_per_dozen', safeValue);

                              final cleanValue =
                                  val.replaceAll('.', '').replaceAll(',', '');
                              final input = double.tryParse(cleanValue) ?? 0;

                              calculateFromBeratLusin(input);
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Berat wajib diisi';
                              }
                            }),
                      ),
                      CustomTheme().hGap('xl'),
                      Expanded(
                        flex: 1,
                        child: TextForm(
                          label: 'GSM',
                          isDisabled: true,
                          controller: widget.gsm,
                          handleChange: (value) {
                            setState(() {
                              widget.gsm.text = value.toString();
                              widget.handleChangeInput('gsm', value);
                            });
                          },
                        ),
                      ),
                      CustomTheme().hGap('xl'),
                      Expanded(
                        flex: 1,
                        child: TextForm(
                          label: 'Total Berat (KG)',
                          isDisabled: true,
                          controller: widget.totalWeight,
                          handleChange: (value) {
                            setState(() {
                              widget.totalWeight.text = value.toString();
                              widget.handleChangeInput('total_weight', value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              AttachmentPicker(
                attachments: widget.allAttachments,
                onAddAttachment: widget.handlePickAttachments,
                onDeleteAttachment: widget.handleDeleteAttachment,
                onPreviewImage: (isNew, filePath) {
                  widget.showImageDialog(context, isNew, filePath);
                },
              ),
              NoteEditor(
                controller: widget.note,
                formKey: 'notes',
                label: 'Catatan',
                form: widget.form,
                onChanged: (value) {
                  widget.handleChangeInput('notes', value);
                },
              )
            ].separatedBy(CustomTheme().vGap('2xl')),
          ),
      ].separatedBy(CustomTheme().vGap('2xl')),
    );
  }
}
