// import 'package:textile_tracking/helpers/util/note_editor.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/text/thousand_separator_input_formatter.dart';
import 'package:textile_tracking/helpers/util/attachment_picker.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/note_editor.dart';
import 'package:textile_tracking/helpers/util/qty_range_formatter.dart';
import 'package:textile_tracking/helpers/util/range_formatter.dart';
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
  final greigeQty;

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
      this.weightDozen});

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

  double getTotalItemQty() {
    final items = widget.data?['items'] as List<dynamic>?;

    if (items == null || items.isEmpty) return 0;

    return items.fold<double>(0, (sum, item) {
      final qty = double.tryParse(item['qty']?.toString() ?? '0') ?? 0;
      return sum + qty;
    });
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
    final totalQty = getTotalItemQty();
    if (totalQty == 0) return 0;

    final gradeQty = double.tryParse(
          widget.form['grades']?[index]?['qty']?.toString() ?? '0',
        ) ??
        0;

    return (gradeQty / totalQty) * 100;
  }

  double getRemainingQtyForGrade(int index) {
    final totalQty = getTotalItemQty();
    if (totalQty == 0) return 0;

    final grades = widget.form['grades'] as List<dynamic>?;

    if (grades == null) return totalQty;

    double usedQty = 0;

    for (int i = 0; i < grades.length; i++) {
      if (i == index) continue;

      final qty = double.tryParse(
            grades[i]?['qty']?.toString() ?? '0',
          ) ??
          0;

      usedQty += qty;
    }

    final remaining = totalQty - usedQty;

    return remaining < 0 ? 0 : remaining;
  }

  Widget buildGradeCard(int i) {
    final gradeLabel = getGradeLabel(i);
    final percentage = getGradePercentage(i);
    final maxQty = getRemainingQtyForGrade(i);

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewText(
            viewLabel: 'Grade',
            viewValue: gradeLabel,
          ),
          CustomTheme().vGap('lg'),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextForm(
                  label: 'Jumlah',
                  req: true,
                  isNumber: true,
                  inputFormatters: [
                    QtyRangeFormatter(
                      getBaseQty: getTotalItemQty,
                    ),
                    ThousandsSeparatorInputFormatter(),
                  ],
                  handleChange: (val) =>
                      widget.handleUpdateGrade(i, 'qty', val),
                ),
              ),
              CustomTheme().hGap('xl'),
              Expanded(
                flex: 1,
                child: TextForm(
                  label: 'Max Qty (Pcs)',
                  isDisabled: true,
                  controller: TextEditingController(
                    text: maxQty.toStringAsFixed(2),
                  ),
                ),
              ),
              CustomTheme().hGap('xl'),
              Expanded(
                flex: 1,
                child: TextForm(
                  label: 'Persentase (%)',
                  isDisabled: true,
                  controller: TextEditingController(
                    text: percentage.toStringAsFixed(2),
                  ),
                ),
              ),
              CustomTheme().hGap('xl'),
              Expanded(
                flex: 1,
                child: SelectForm(
                  label: 'Satuan',
                  onTap: () => widget.handleSelectQtyUnit(i),
                  selectedLabel:
                      widget.form['grades']?[i]?['unit']?['name'] ?? '',
                  selectedValue:
                      widget.form['grades']?[i]?['unit_id']?.toString() ?? '',
                  required: true,
                ),
              ),
            ],
          ),
          CustomTheme().vGap('lg'),
          TextForm(
            label: 'Catatan',
            req: false,
            handleChange: (val) => widget.handleUpdateGrade(i, 'notes', val),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final minWeight = widget.greigeQty != null ? widget.greigeQty * 0.9 : null;
    final maxWeight = widget.greigeQty != null ? widget.greigeQty * 1.1 : null;

    double getMaxQtyFromItems() {
      final items = widget.data['items'] as List<dynamic>?;

      if (items == null || items.isEmpty) return 0;

      return items.fold<double>(0, (sum, item) {
        final qty = double.tryParse(item['qty']?.toString() ?? '0') ?? 0;
        return sum + qty;
      });
    }

    void calculateFromBeratLusin(double value) {
      final maxQty = getMaxQtyFromItems();

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

        totalBerat = maxQty == 0 ? 0 : beratLusin / (12 * maxQty);

        widget.gsm.text = gsm.toStringAsFixed(2);
        widget.totalWeight.text = totalBerat.toStringAsFixed(2);
      });
    }

    final List<Map<String, dynamic>> formRows = [
      {
        'label': 'Panjang',
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
        'label': 'Lebar',
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
          'req': widget.withQtyAndWeight == true ? false : true,
          'withSelectUnit': false,
          'staticUnit': 'KG'
        },
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (widget.id == null)
          CustomCard(
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
          )),
        if (widget.form?['wo_id'] != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (widget.withItemGrade == true)
                Column(
                  children: [
                    if ((widget.itemGradeOption ?? []).isNotEmpty &&
                        widget.grades.isNotEmpty &&
                        widget.grades.length >= widget.itemGradeOption.length)
                      for (int i = 0; i < widget.itemGradeOption.length; i++)
                        buildGradeCard(i),
                  ].separatedBy(CustomTheme().vGap('xl')),
                ),
              if (widget.withItemGrade == false)
                CustomCard(
                    child: Column(
                  children: [
                    ...formRows.map((row) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    TextForm(
                                      label: row['label'],
                                      req: row['req'],
                                      isNumber: true,
                                      controller: row['controller'],
                                      handleChange: (value) {
                                        final safeValue = (value == null ||
                                                value.toString().trim().isEmpty)
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
                                        });
                                      },
                                      // validator: (value) {
                                      //   if (value == null || value.trim().isEmpty) {
                                      //     return '${row['label']} wajib diisi';
                                      //   }

                                      // },
                                    ),
                                  ],
                                ),
                              ),
                              if (row['withSelectUnit'] == true)
                                Expanded(
                                  flex: 1,
                                  child: SelectForm(
                                    isDisabled: true,
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
                              if (row['staticUnit'] != null) ...[
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    row['staticUnit'],
                                    style: TextStyle(
                                      fontSize: CustomTheme().fontSize('md'),
                                      fontWeight:
                                          CustomTheme().fontWeight('semibold'),
                                    ),
                                  ),
                                ),
                              ],
                            ].separatedBy(CustomTheme()
                                .hGap(row['staticUnit'] != null ? 'xs' : 'xl')),
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
                                        setState(() {
                                          widget.qty.text = value.toString();
                                          widget.handleChangeInput(
                                              'item_qty', value);
                                          widget.validateQty(value);
                                        });
                                      },
                                      // validator: (value) {
                                      //   if (value == null || value.trim().isEmpty) {
                                      //     return 'Qty wajib diisi';
                                      //   }
                                      // },
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
                                  selectedValue:
                                      widget.form['item_unit_id']?.toString() ??
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
                                      inputFormatters: [
                                        RangeFormatter(
                                            min: minWeight, max: maxWeight),
                                        ThousandsSeparatorInputFormatter()
                                      ],
                                      handleChange: (value) {
                                        setState(() {
                                          widget.qty.text = value.toString();
                                          widget.handleChangeInput(
                                              'qty', value);
                                          widget.validateWeight(value);
                                        });
                                      },
                                      // validator: (value) {
                                      //   if (value == null ||
                                      //       value.trim().isEmpty) {
                                      //     return 'Qty wajib diisi';
                                      //   }
                                      // },
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
                                      widget.form['unit_id']?.toString() ?? '',
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
                )),
              if (widget.forPacking == true)
                CustomCard(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextForm(
                          label: 'Berat 1 Lusin (KG)',
                          req: true,
                          isNumber: true,
                          controller: widget.weightDozen,
                          inputFormatters: [ThousandsSeparatorInputFormatter()],
                          handleChange: (val) {
                            widget.handleChangeInput('weight_per_dozen', val);

                            final cleanValue =
                                val.replaceAll('.', '').replaceAll(',', '');
                            final input = double.tryParse(cleanValue) ?? 0;

                            calculateFromBeratLusin(input);
                          },
                        ),
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
              CustomCard(
                  child: AttachmentPicker(
                attachments: widget.allAttachments,
                onAddAttachment: widget.handlePickAttachments,
                onDeleteAttachment: widget.handleDeleteAttachment,
                onPreviewImage: (isNew, filePath) {
                  widget.showImageDialog(context, isNew, filePath);
                },
              )),
              CustomCard(
                  child: NoteEditor(
                controller: widget.note,
                formKey: 'notes',
                label: 'Catatan',
                form: widget.form,
                onChanged: (value) {
                  widget.handleChangeInput('notes', value);
                },
              )),
            ].separatedBy(CustomTheme().vGap('2xl')),
          ),
      ].separatedBy(CustomTheme().vGap('2xl')),
    );
  }
}
