// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
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
  final forSewing;
  final forHemming;
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
  final qtyItem;
  final grades;
  final allAttachments;
  final handleSelectWo;
  final handleSelectFinishedMaterial;
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
  final handleTotalItemQty;
  final handleRemainingQtyForGrade;
  final dyeingLotNo;
  final weightGood;
  final weightDefect;
  final woData;

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
      this.gsm,
      this.totalWeight,
      this.weightDozen,
      this.handleRemainingQtyForGrade,
      this.handleTotalItemQty,
      this.processData,
      this.qtyItem,
      this.dyeingLotNo,
      this.forHemming,
      this.forSewing,
      this.handleSelectFinishedMaterial,
      this.weightDefect,
      this.weightGood,
      this.woData});

  @override
  State<FormItems> createState() => _FormItemsState();
}

class _FormItemsState extends State<FormItems> {
  double beratLusin = 0;
  double gsm = 0;
  double totalBerat = 0;
  late List<Map<String, dynamic>> _grades;

  @override
  void initState() {
    super.initState();
    _grades = (widget.processData['grades'] ?? [])
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();
    _initGradeControllers();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final good = parseSafe(widget.form['good_weight']);
      final defect = parseSafe(widget.form['bs_weight']);

      if (good > 0 || defect > 0) {
        calculateLongHemmingWeight();
      }
    });
  }

  void _initGradeControllers() {
    for (int i = 0; i < _grades.length; i++) {
      _ensureController(i);

      final qty = _grades[i]['qty']?.toString() ?? '0';

      widget.qtyItem[i].text = qty;
    }
  }

  void _ensureController(int index) {
    while (widget.qtyItem.length <= index) {
      widget.qtyItem.add(TextEditingController(text: '0'));
    }
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
    final grades = widget.form['grades'];

    if (grades == null || grades is! List || grades.isEmpty) {
      return 0;
    }

    if (index < 0 || index >= grades.length) {
      return 0;
    }

    final totalQty = widget.handleTotalItemQty();
    if (totalQty == 0) return 0;

    final gradeQty =
        double.tryParse(grades[index]?['qty']?.toString() ?? '0') ?? 0;

    return (gradeQty / totalQty) * 100;
  }

  double getMaxQtyFromGrades() {
    final grades = widget.woData['grades'] as List<dynamic>?;

    if (grades == null || grades.isEmpty) return 0;

    return grades.fold<double>(0, (sum, grade) {
      final qty = double.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
      return sum + qty;
    });
  }

  void calculateFromBeratLusin(double value) {
    final maxQty =
        widget.woData['processes'][10]['data'][0]['grades'][0]['qty'];

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

  double parseSafe(dynamic val) {
    final cleaned = val
        ?.toString()
        .replaceAll('.', '') // remove thousand
        .replaceAll(',', '.'); // normalize decimal

    return double.tryParse(cleaned ?? '') ?? 0;
  }

  void calculateLongHemmingWeight() {
    final good = parseSafe(widget.form['good_weight']);
    final defect = parseSafe(widget.form['bs_weight']);

    final total = good + defect;

    setState(() {
      widget.handleChangeInput('weight', total.toStringAsFixed(2));
      widget.weight.value = TextEditingValue(
        text: total.toStringAsFixed(2),
        selection: TextSelection.collapsed(
          offset: total.toStringAsFixed(2).length,
        ),
      );
    });
  }

  Widget buildGradeCard(int i) {
    final gradeLabel = getGradeLabel(i);
    final percentage = getGradePercentage(i);
    final maxQty = widget.handleRemainingQtyForGrade(i);

    final items = widget.data?['items'] ?? [];

    _ensureController(i);

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
              flex: 1,
              child: TextForm(
                label: 'Qty (PCS)',
                req: true,
                isNumber: true,
                isDisabled: i == 2 ? true : false,
                controller: widget.qtyItem[i],
                handleChange: (val) {
                  if (val == null || val.trim().isEmpty) {
                    widget.qtyItem[i].text = '0';
                    widget.qtyItem[i].selection = TextSelection.fromPosition(
                      TextPosition(offset: widget.qtyItem[i].text.length),
                    );
                  }

                  final safeValue =
                      (val == null || val.trim().isEmpty) ? '0' : val;

                  widget.handleUpdateGrade(i, 'qty', safeValue);

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
              child: Column(
                children: [_buildFinishedItem(items, i)],
              ),
            )
            // Expanded(
            //   flex: 1,
            //   child: TextForm(
            //     label: 'Max Qty (PCS)',
            //     isDisabled: true,
            //     controller: TextEditingController(
            //       text: maxQty.toInt().toString(),
            //     ),
            //   ),
            // ),
            // Expanded(
            //   flex: 1,
            //   child: TextForm(
            //     label: 'Catatan',
            //     req: false,
            //     handleChange: (val) =>
            //         widget.handleUpdateGrade(i, 'notes', val),
            //   ),
            // ),
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
        // Row(
        //   children: [
        //     Expanded(
        //       flex: 1,
        //       child: TextForm(
        //         label: 'Persentase (%)',
        //         isDisabled: true,
        //         controller: TextEditingController(
        //           text: percentage.round().toString(),
        //         ),
        //       ),
        //     ),
        //   ].separatedBy(CustomTheme().hGap('xl')),
        // ),
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
              flex: row['staticUnit'] != null ? 3 : 2,
              child: TextForm(
                label: row['label'],
                req: row['req'],
                isNumber: true,
                controller: row['controller'],
                handleChange: (value) {
                  final safeValue =
                      (value == null || value.toString().trim().isEmpty)
                          ? ''
                          : value.toString();

                  setState(() {
                    widget.handleChangeInput(row['value'], safeValue);

                    // if (row['value'] == 'length') {
                    //   widget.handleChangeInput('length_unit_id', 3);
                    // }

                    // if (row['value'] == 'width') {
                    //   widget.handleChangeInput('width_unit_id', 3);
                    // }

                    if (row['value'] == 'weight') {
                      widget.handleChangeInput('weight_unit_id', 2);
                      widget.validateWeight(safeValue);
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
            padding: EdgeInsets.only(top: 4),
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
      // {
      //   'label': 'Panjang (CM)',
      //   'controller': widget.length,
      //   'onSelect': widget.handleSelectLengthUnit,
      //   'selectedLabel': widget.form['nama_satuan_panjang'] ?? '',
      //   'selectedValue': widget.form['length_unit_id']?.toString() ?? '',
      //   'unitLabel': 'Satuan Panjang',
      //   'value': 'length',
      //   'req': false,
      //   'withSelectUnit': false,
      //   'staticUnit': 'CM'
      // },
      // {
      //   'label': 'Lebar (CM)',
      //   'controller': widget.width,
      //   'onSelect': widget.handleSelectWidthUnit,
      //   'selectedLabel': widget.form['nama_satuan_lebar'] ?? '',
      //   'selectedValue': widget.form['width_unit_id']?.toString() ?? '',
      //   'unitLabel': 'Satuan Lebar',
      //   'value': 'width',
      //   'req': false,
      //   'withSelectUnit': false,
      //   'staticUnit': 'CM'
      // },
      if (widget.label == 'Long Hemming')
        {
          'label': 'Berat Tidak Cacat (KG)',
          'controller': widget.weightGood,
          'value': 'good_weight',
          'req': true,
          'withSelectUnit': false,
          'staticUnit': 'KG',
          'selectedLabel': widget.form['nama_satuan_berat_good'] ?? '',
          'selectedValue': widget.form['good_weight_unit_id']?.toString() ?? '',
        },
      if (widget.label == 'Long Hemming')
        {
          'label': 'Berat Cacat (KG)',
          'controller': widget.weightDefect,
          'value': 'bs_weight',
          'req': true,
          'withSelectUnit': false,
          'staticUnit': 'KG',
          'selectedLabel': widget.form['nama_satuan_berat_bs'] ?? '',
          'selectedValue': widget.form['bs_weight_unit_id']?.toString() ?? '',
        },
      if (widget.forDyeing == false)
        {
          'label': 'Berat (KG)',
          'controller': widget.weight,
          'onSelect': widget.handleSelectUnit,
          'selectedLabel': widget.form['nama_satuan_berat'] ?? '',
          'selectedValue': widget.form['weight_unit_id']?.toString() ?? '',
          'unitLabel': 'Satuan Berat',
          'value': 'weight',
          'req': true,
          'withSelectUnit': false,
          'staticUnit': 'KG',
          'isDisabled': widget.label == 'Long Hemming' ? true : false
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
                if (value == null || value.trim().isEmpty) {
                  return 'Work Order wajib dipilih';
                }
                return null;
              },
            ),
          ),
        if (widget.data != null)
          TemplateCard(
              title: 'Work Order',
              icon: Icons.sort_outlined,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.data != null
                                ? '${widget.data['wo_no']}'
                                : '-',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        if (widget.data != null &&
            (widget.label != 'Long Hemming' &&
                widget.label != 'Cross Cutting' &&
                widget.label != 'Sewing' &&
                widget.label != 'Sorting' &&
                widget.label != 'Packing'))
          TemplateCard(
              title: 'Mesin',
              icon: Icons.sort_outlined,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.data != null
                                ? '${widget.processData['machine']['code']} ${widget.processData['machine']['name']}'
                                : '-',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        if (widget.processData['rework'] == true)
          TemplateCard(
              title: 'Referensi Rework',
              icon: Icons.replay_outlined,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildReworkReference()],
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
              if (widget.label == 'Long Hemming' ||
                  widget.label == 'Cross Cutting' ||
                  widget.label == 'Sewing')
                TemplateCard(
                    title: 'Informasi Mesin',
                    icon: Icons.invert_colors_on_outlined,
                    child: _buildMachine()),
              if (widget.withItemGrade == false && widget.label != 'Packing')
                TemplateCard(
                  title: 'Informasi Proses',
                  icon: Icons.list_alt_outlined,
                  child: Column(
                    children: [
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //     Expanded(
                      //       child: _buildFormField(formRows.firstWhere(
                      //         (e) => e['value'] == 'length',
                      //       )),
                      //     ),
                      //     CustomTheme().hGap('xl'),
                      //     Expanded(
                      //       child: _buildFormField(formRows.firstWhere(
                      //         (e) => e['value'] == 'width',
                      //       )),
                      //     ),
                      //   ],
                      // ),
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
                                  flex: row['staticUnit'] != null ? 3 : 2,
                                  child: Column(
                                    children: [
                                      TextForm(
                                        label: row['label'],
                                        req: row['req'],
                                        isDisabled: row['isDisabled'] ?? false,
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
                                            widget.handleChangeInput(
                                                row['value'], safeValue);

                                            if (row['value'] == 'good_weight') {
                                              widget.handleChangeInput(
                                                  'good_weight_unit_id', 2);
                                            }
                                            if (row['value'] == 'bs_weight') {
                                              widget.handleChangeInput(
                                                  'bs_weight_unit_id', 2);
                                            }
                                            if (row['value'] == 'weight') {
                                              widget.handleChangeInput(
                                                  'weight_unit_id', 2);
                                              widget.validateWeight(safeValue);
                                            }
                                            if (widget.label ==
                                                'Long Hemming') {
                                              calculateLongHemmingWeight();
                                            }
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return '${row['label']} wajib diisi';
                                          }
                                          return null;
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
                                        if (value == null ||
                                            value.trim().isEmpty) {
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
                                            SizedBox(width: 8),
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
                      if (widget.label == 'Packing')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TemplateCard(
                              title: 'Qty Packing',
                              icon: Icons.layers_outlined,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextForm(
                                    label: 'Total Qty',
                                    req: false,
                                    controller: widget.qty,
                                    handleChange: (value) {
                                      widget.handleChangeInput('qty', value);
                                    },
                                  ),
                                ].separatedBy(CustomTheme().vGap('lg')),
                              ),
                            ),
                          ].separatedBy(CustomTheme().vGap('lg')),
                        ),
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
                                      if (value == null ||
                                          value.trim().isEmpty) {
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
                                            SizedBox(width: 8),
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
                                    selectedLabel: widget.label == 'Dyeing'
                                        ? 'KG'
                                        : widget.form['nama_satuan'] ?? '',
                                    selectedValue: widget.label == 'Dyeing'
                                        ? '2'
                                        : widget.form['unit_id']?.toString() ??
                                            '',
                                    required: true,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
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
                                            SizedBox(width: 8),
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
              if (widget.forDyeing == true ||
                  widget.forHemming == true ||
                  widget.forSewing == true)
                TemplateCard(
                  title: 'Material Setelah ${widget.label}',
                  icon: Icons.inventory_2_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: SelectForm(
                                label: widget.label == 'Sorting'
                                    ? 'Material Finish'
                                    : 'Material Semi Finish',
                                onTap: () =>
                                    widget.handleSelectFinishedMaterial(),
                                selectedLabel: widget.form['nama_item'] ?? '',
                                selectedCode: widget.form['sku_item'] ?? '',
                                selectedValue: widget.form['finished_item_id']
                                        ?.toString() ??
                                    '',
                                isWithCode: true,
                                required: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Material wajib dipilih';
                                  }
                                  return null;
                                },
                              )),
                        ].separatedBy(CustomTheme().hGap('xl')),
                      ),
                    ].separatedBy(CustomTheme().vGap('lg')),
                  ),
                ),
              if (widget.label == 'Packing')
                TemplateCard(
                  title: 'Qty Sorting',
                  icon: Icons.sort_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [_buildSortingQty()],
                            ),
                          ),
                        ].separatedBy(CustomTheme().hGap('xl')),
                      ),
                    ].separatedBy(CustomTheme().vGap('lg')),
                  ),
                ),
              if (widget.label == 'Packing')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TemplateCard(
                      title: 'Qty Packing',
                      icon: Icons.layers_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextForm(
                            label: 'Total Qty',
                            req: false,
                            controller: widget.qty,
                            handleChange: (value) {
                              widget.handleChangeInput('qty', value);
                            },
                          ),
                        ].separatedBy(CustomTheme().vGap('lg')),
                      ),
                    ),
                  ].separatedBy(CustomTheme().vGap('lg')),
                ),
              if (widget.forDyeing == true)
                TemplateCard(
                  title: 'Lot Celup',
                  icon: Icons.invert_colors_on_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                TextForm(
                                  label: 'No. Lot Celup',
                                  controller: widget.dyeingLotNo,
                                  handleChange: (value) {
                                    widget.handleChangeInput(
                                        'lot_celup_no', value);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ].separatedBy(CustomTheme().hGap('xl')),
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

                              final normalized = safeValue.replaceAll(',', '.');
                              final input = double.tryParse(normalized) ?? 0;

                              calculateFromBeratLusin(input);
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Berat 1 lusin wajib diisi';
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

  Widget _buildMachine() {
    final machines = widget.processData['machines'] as List? ?? [];

    if (machines.isEmpty) return NoData();

    return Wrap(
      alignment: WrapAlignment.start, // ⬅️ ini penting
      runAlignment: WrapAlignment.start,
      spacing: 8, // horizontal gap
      runSpacing: 8, // vertical gap antar baris
      children: machines.map((machine) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            '${machine['code']} - ${machine['name']}',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSortingQty() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  widget.woData['processes'][10]['data'][0]['grades'][0]
                              ['qty'] !=
                          null
                      ? '${widget.woData['processes'][10]['data'][0]['grades'][0]['qty']}'
                      : '-',
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildReworkReference() {
    final items = [
      {
        'label': 'No. Dyeing',
        'value': widget.processData['rework_reference']?['dyeing_no'] ?? '-',
        'icon': Icons.description_outlined,
      },
      {
        'label': 'Mesin',
        'value':
            '${widget.processData['rework_reference']?['machine']?['code'] ?? ''} '
                '${widget.processData['rework_reference']?['machine']?['name'] ?? '-'}',
        'icon': Icons.description_outlined,
      },
      {
        'label': 'Qty Hasil Dyeing',
        'value':
            '${widget.processData['rework_reference']?['work_orders']?['greige_qty'] ?? '-'} '
                '${widget.processData['rework_reference']?['work_orders']?['greige_unit']?['code'] ?? ''}',
        'icon': Icons.description_outlined,
      },
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map((item) {
            return Container(
              padding: CustomTheme().padding('card'),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // 🔥 prevent full width
                children: [
                  Icon(item['icon'] as IconData, size: 16, color: Colors.grey),
                  SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['label'].toString(),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        item['value'].toString(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ].separatedBy(CustomTheme().vGap('sm')),
                  ),
                ],
              ),
            );
          })
          .toList()
          .separatedBy(CustomTheme().hGap('md')),
    );
  }

  Widget _buildFinishedItem(List items, int i) {
    final item = (items.length > i) ? items[i] : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Material Finish'),
        Container(
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item != null && item['item_code'] != null
                          ? item['item_code'].toString()
                          : '-',
                    ),
                    Text(
                      item != null && item['item_name'] != null
                          ? item['item_name'].toString()
                          : '-',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ].separatedBy(CustomTheme().vGap('md')),
    );
  }
}
