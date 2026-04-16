// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/result/to_double.dart';
import 'package:textile_tracking/helpers/util/attachment_picker.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
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
  final reworkLongHemming;
  final combing;
  final spraying;
  final itemTypeOption;
  final defects;
  final defectQty;
  final handleSelectItemType;
  final handleUpdateDefect;
  final packingQty;
  final weightGradeA;
  final finishedItem;

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
      this.woData,
      this.reworkLongHemming,
      this.combing,
      this.spraying,
      this.itemTypeOption,
      this.defects,
      this.defectQty,
      this.handleSelectItemType,
      this.handleUpdateDefect,
      this.packingQty,
      this.weightGradeA,
      this.finishedItem});

  @override
  State<FormItems> createState() => _FormItemsState();
}

class _FormItemsState extends State<FormItems> {
  double beratLusin = 0;
  double gsm = 0;
  double beratGradeA = 0;
  double totalBerat = 0;
  late List<Map<String, dynamic>> _grades;
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

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

  String capitalizeWords(String text) {
    return text.toLowerCase().split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
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

  String getDefectLabel(int i) {
    return widget.itemTypeOption.firstWhere(
          (e) =>
              e['id'].toString() ==
              widget.defects[i]['defect_type_id'].toString(),
          orElse: () => {'name': ''},
        )['name'] ??
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
    final grades =
        double.tryParse(widget.form['qty']?.toString() ?? '0') ?? 0.0;

    return grades;
  }

  double getMaxTotalQty() {
    final data = widget.woData['processes'][10]['data'][0];

    final gradesList = data['grades'] ?? [];

    int totalQty = 0;

    // 🔹 Ambil dari grades
    for (var grade in gradesList) {
      final qty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
      totalQty += qty;
    }

    // 🔹 Tambahan field lain
    final spraying = int.tryParse(data['spraying']?.toString() ?? '0') ?? 0;

    final reworkLongHemming =
        int.tryParse(data['rework_long_hemming']?.toString() ?? '0') ?? 0;

    final combing = int.tryParse(data['combing']?.toString() ?? '0') ?? 0;

    totalQty += spraying + reworkLongHemming + combing;

    return totalQty.toDouble();
  }

  int customRound(double value) {
    final decimal = value - value.floor();

    if (decimal > 0.5) {
      return value.ceil();
    } else {
      return value.floor();
    }
  }

  void calculateGsm(double value) {
    final size = widget.woData['items'][0]['variants'][1]['value'];
    final panjang = int.tryParse(size.split('X')[0]) ?? 0;
    final lebar = int.tryParse(size.split('X')[1]) ?? 0;

    setState(() {
      beratLusin = value;
      final rawGsm = (beratLusin * 10000000) / (12 * panjang * lebar);

      final roundedGsm = customRound(rawGsm);

      if (panjang == 0 || lebar == 0) {
        gsm = 0;
      } else {
        gsm = roundedGsm.toDouble();
      }

      widget.gsm.text = roundedGsm.toString();

      widget.handleChangeInput('gsm', roundedGsm.toString());
    });
  }

  void calculateBeratA(double value) {
    final maxQty = getMaxQtyFromGrades();

    setState(() {
      beratLusin = value;

      beratGradeA = maxQty == 0 ? 0 : (beratLusin / 12) * maxQty;

      widget.weightGradeA.text = beratGradeA.toStringAsFixed(2);

      widget.handleChangeInput(
        'weight_grade_a',
        beratGradeA.toStringAsFixed(2),
      );
    });
  }

  void calculateTotalBerat(double value) {
    final maxQty = getMaxTotalQty();

    setState(() {
      beratLusin = value;

      totalBerat = maxQty == 0 ? 0 : (beratLusin / 12) * maxQty;

      widget.totalWeight.text = totalBerat.toStringAsFixed(2);

      widget.handleChangeInput(
        'total_weight',
        totalBerat.toStringAsFixed(2),
      );
    });
  }

  double parseSafe(dynamic val) {
    if (val == null) return 0;

    String str = val.toString().trim();

    if (str.isEmpty) return 0;

    // Jika ada koma, anggap format Indonesia (1.000,5)
    if (str.contains(',')) {
      str = str.replaceAll('.', ''); // hapus ribuan
      str = str.replaceAll(',', '.'); // ubah desimal ke titik
    }

    return double.tryParse(str) ?? 0;
  }

  double _calculateTotalVermak() {
    final spraying = parseSafe(widget.spraying.text);
    final combing = parseSafe(widget.combing.text);
    final rework = parseSafe(widget.reworkLongHemming.text);

    return spraying + combing + rework;
  }

  double _calculateTotalQtySorting() {
    double totalGrades = 0;

    for (var grade in _grades) {
      final qty = parseSafe(grade['qty']);
      totalGrades += qty;
    }

    return totalGrades + _calculateTotalVermak();
  }

  /// 📊 Update total_sorting field dengan hasil perhitungan
  void _updateTotalSorting() {
    final total = _calculateTotalQtySorting();
    widget.handleChangeInput('total_sorting', total.toString());
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

  void _ensureDefectController(int index) {
    while (widget.defectQty.length <= index) {
      widget.defectQty.add(TextEditingController(text: '0'));
    }
  }

  void _recalculateGradeBS() {
    final totalBs = widget.defects.fold<int>(
      0,
      (int sum, defect) {
        final qty = int.tryParse(
                (defect['qty']?.toString() ?? '0').replaceAll(',', '')) ??
            0;
        return sum + qty;
      },
    );

    final grades = List<Map<String, dynamic>>.from(_grades);
    final index =
        grades.indexWhere((g) => g['item_grade_id'].toString() == '3');

    if (index != -1) {
      grades[index]['qty'] = totalBs;
      _grades = grades;
      widget.form['grades'] = _grades;

      if (index < widget.qtyItem.length) {
        widget.qtyItem[index].text = totalBs.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> formRows = [
      if (widget.label == 'Long Hemming')
        {
          'label': 'Berat Bagus (KG)',
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
          'label': 'Berat BS (KG)',
          'controller': widget.weightDefect,
          'value': 'bs_weight',
          'req': true,
          'withSelectUnit': false,
          'staticUnit': 'KG',
          'selectedLabel': widget.form['nama_satuan_berat_bs'] ?? '',
          'selectedValue': widget.form['bs_weight_unit_id']?.toString() ?? '',
        },
      if (widget.forDyeing == false &&
          widget.label != 'Long Hemming' &&
          widget.label != 'Cross Cutting' &&
          widget.label != 'Sewing')
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
        Row(
          children: [
            if (widget.id == null)
              Expanded(
                child: TemplateCard(
                  title: 'Work Order',
                  icon: Icons.description_outlined,
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
              ),
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.id != null)
              Expanded(
                child: TemplateCard(
                    title: 'Work Order',
                    icon: Icons.description_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Work Order'),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
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
                      ].separatedBy(CustomTheme().vGap('lg')),
                    )),
              ),
            if (widget.data != null &&
                (widget.label != 'Long Hemming' &&
                    widget.label != 'Cross Cutting' &&
                    widget.label != 'Sewing' &&
                    widget.label != 'Sorting' &&
                    widget.label != 'Packing'))
              Expanded(
                child: TemplateCard(
                    title: 'Mesin',
                    icon: Icons.local_laundry_service_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mesin'),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
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
                      ].separatedBy(CustomTheme().vGap('lg')),
                    )),
              ),
            if (widget.data != null && widget.forDyeing == true)
              Expanded(
                child: TemplateCard(
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
              ),
            if (widget.data != null &&
                widget.label != 'Dyeing' &&
                widget.label != 'Long Hemming' &&
                widget.label != 'Cross Cutting' &&
                widget.label != 'Sewing' &&
                widget.label != 'Sorting' &&
                widget.label != 'Packing')
              Expanded(
                child: TemplateCard(
                  title: 'Berat',
                  icon: Icons.scale_outlined,
                  child: Column(
                    children: [
                      Column(
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
                                      label: 'Berat',
                                      req: true,
                                      isDisabled: false,
                                      isNumber: true,
                                      initialValue:
                                          widget.form['weight']?.toString() ??
                                              '0',
                                      controller: widget.weight,
                                      handleChange: (value) {
                                        final safeValue = (value == null ||
                                                value.toString().trim().isEmpty)
                                            ? '0'
                                            : value.toString();
                                        widget.handleChangeInput(
                                            'weight', safeValue);

                                        setState(() {
                                          widget.validateWeight(safeValue);
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Berat wajib diisi';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
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
                            ].separatedBy(CustomTheme().hGap('xl')),
                          ),
                        ],
                      )
                    ].separatedBy(CustomTheme().hGap('xl')),
                  ),
                ),
              ),
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
        if (widget.data != null &&
            (widget.label == 'Long Hemming' ||
                widget.label == 'Cross Cutting' ||
                widget.label == 'Sewing'))
          TemplateCard(
              title: 'Mesin',
              icon: Icons.local_laundry_service_outlined,
              child: _buildMachine()),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.data != null &&
                widget.withItemGrade == false &&
                widget.label != 'Packing' &&
                widget.label != 'Press' &&
                widget.label != 'Tumbler' &&
                widget.label != 'Stenter' &&
                widget.label != 'Long Slitting')
              Expanded(
                child: TemplateCard(
                  title: widget.label == 'Cross Cutting' ||
                          widget.label == 'Sewing'
                      ? 'Qty'
                      : 'Berat',
                  icon: Icons.list_alt_outlined,
                  child: Column(
                    children: [
                      if (widget.label == 'Long Hemming')
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    TextForm(
                                      label: 'Berat Bagus',
                                      initialValue: widget.form['good_weight']
                                              ?.toString() ??
                                          '0',
                                      req: false,
                                      isNumber: true,
                                      // isSorting: true,
                                      controller: widget.weightGood,
                                      handleChange: (value) {
                                        final safeValue = (value == null ||
                                                value.toString().trim().isEmpty)
                                            ? '0'
                                            : value.toString();

                                        widget.handleChangeInput(
                                            'good_weight', safeValue);

                                        setState(() {
                                          widget.validateWeight(safeValue);
                                        });
                                        calculateLongHemmingWeight();
                                      },
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Berat wajib diisi';
                                        }
                                        return null;
                                      },
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
                                                        widget.weightWarning ??
                                                            '-',
                                                        style: TextStyle(
                                                          color: CustomTheme()
                                                              .colors(
                                                                  'warning'),
                                                          fontSize:
                                                              CustomTheme()
                                                                  .fontSize(
                                                                      'sm'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ].separatedBy(CustomTheme().hGap('xl')),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TextForm(
                                  label: 'Berat BS',
                                  req: false,
                                  initialValue:
                                      widget.form['bs_weight']?.toString() ??
                                          '0',
                                  isNumber: true,
                                  isSorting: true,
                                  controller: widget.weightDefect,
                                  handleChange: (value) {
                                    final safeValue = (value == null ||
                                            value.toString().trim().isEmpty)
                                        ? '0'
                                        : value.toString();

                                    widget.handleChangeInput(
                                        'bs_weight', safeValue);
                                    calculateLongHemmingWeight();
                                  },
                                ),
                              ),
                            ].separatedBy(CustomTheme().hGap('xl'))),
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
                                        initialValue: widget.form['item_qty']
                                                ?.toString() ??
                                            '0',
                                        controller: widget.qty,
                                        handleChange: (value) {
                                          final safeValue = (value == null ||
                                                  value.trim().isEmpty)
                                              ? '0'
                                              : value;

                                          // ✅ langsung pakai raw value ("1000.25")
                                          widget.handleChangeInput(
                                              'item_qty', safeValue);

                                          setState(() {
                                            widget.validateQty(safeValue);
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Qty wajib diisi';
                                          }
                                          return null;
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
                                        label: 'Berat Hasil ${widget.label}',
                                        req: true,
                                        isNumber: true,
                                        initialValue:
                                            widget.form['qty']?.toString() ??
                                                '0',
                                        controller: widget.qty,
                                        handleChange: (value) {
                                          final safeValue =
                                              (value == null || value.isEmpty)
                                                  ? '0'
                                                  : value;

                                          widget.handleChangeInput(
                                              'qty', safeValue);

                                          setState(() {
                                            widget.validateWeight(safeValue);
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Berat wajib diisi';
                                          }
                                          return null;
                                        },
                                      )
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
                              ].separatedBy(CustomTheme().hGap('xl')),
                            ),
                          ],
                        ),
                    ].separatedBy(CustomTheme().vGap('lg')),
                  ),
                ),
              ),
            if (widget.data != null &&
                (widget.forDyeing == true ||
                    widget.forSewing == true ||
                    widget.forHemming == true))
              Expanded(
                child: TemplateCard(
                  title: 'Produk Setelah ${widget.label}',
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
                                    ? 'Produk Jadi'
                                    : 'Produk Setengah Jadi',
                                onTap: () =>
                                    widget.handleSelectFinishedMaterial(),
                                selectedLabel:
                                    widget.form['nama_greige_item'] ?? '',
                                selectedCode:
                                    widget.form['sku_greige_item'] ?? '',
                                selectedValue:
                                    widget.form['greige_item_id']?.toString() ??
                                        '',
                                isWithCode: true,
                                required: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Produk wajib dipilih';
                                  }
                                  return null;
                                },
                              )),
                        ].separatedBy(CustomTheme().hGap('xl')),
                      ),
                    ].separatedBy(CustomTheme().vGap('lg')),
                  ),
                ),
              )
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.processData['rework'] == true)
              Expanded(
                child: TemplateCard(
                    title: 'Referensi Rework',
                    icon: Icons.replay_outlined,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [_buildReworkReference()],
                        ),
                      ],
                    )),
              ),
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
        if (widget.form?['wo_id'] != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (widget.label == 'Sorting')
                TemplateCard(
                  title: 'Perbaikan',
                  icon: Icons.replay_outlined,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextForm(
                          label: 'Semprotan',
                          req: false,
                          isNumber: true,
                          initialValue:
                              widget.form['spraying']?.toString() ?? '0',
                          controller: widget.spraying,
                          handleChange: (value) {
                            final safeValue = (value == null ||
                                    value.toString().trim().isEmpty)
                                ? '0'
                                : value.toString();

                            widget.handleChangeInput('spraying', safeValue);
                            setState(() {});
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextForm(
                          label: 'Permak Long Hemming',
                          req: false,
                          isNumber: true,
                          initialValue:
                              widget.form['rework_long_hemming']?.toString() ??
                                  '0',
                          controller: widget.reworkLongHemming,
                          handleChange: (value) {
                            final safeValue = (value == null ||
                                    value.toString().trim().isEmpty)
                                ? '0'
                                : value.toString();

                            widget.handleChangeInput(
                                'rework_long_hemming', safeValue);
                            setState(() {});
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextForm(
                          label: 'Sisiran',
                          req: false,
                          isNumber: true,
                          initialValue:
                              widget.form['rework_sisiran']?.toString() ?? '0',
                          controller: widget.combing,
                          handleChange: (value) {
                            final safeValue = (value == null ||
                                    value.toString().trim().isEmpty)
                                ? '0'
                                : value.toString();

                            widget.handleChangeInput('combing', safeValue);
                            setState(() {});
                          },
                        ),
                      ),
                    ].separatedBy(CustomTheme().hGap('xl')),
                  ),
                ),
              if (widget.label == 'Sorting')
                Container(child: _buildMultiTipeUpdate()),
              if (widget.withItemGrade == true)
                TemplateCard(
                  title: 'Grade Material',
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
              if (widget.label == 'Sorting')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TemplateCard(
                      title: 'Ringkasan Sortir',
                      icon: Icons.summarize_outlined,
                      child: _grades.length >= 3
                          ? Row(
                              children: [
                                // Grade A
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Grade A',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${formatNumber((_grades[0]['qty'] ?? '0').toString())}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                // Grade B
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Grade B',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${formatNumber((_grades[1]['qty'] ?? '0').toString())}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                // Grade BS
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tipe BS (BS-an)',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${formatNumber((_grades[2]['qty'] ?? '0').toString())}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                // Perbaikan
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Perbaikan',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${formatNumber(_calculateTotalVermak().toString())}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                // Total Qty Sorting
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hasil Sortir',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${formatNumber(_calculateTotalQtySorting().toString())}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'Loading grades...',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ),
                            ),
                    ),
                  ].separatedBy(CustomTheme().vGap('lg')),
                ),
              if (widget.label == 'Packing')
                TemplateCard(
                  title: 'Produk Jadi',
                  icon: Icons.inventory_2_outlined,
                  child: _buildFinishedMaterial(),
                ),
              if (widget.label == 'Packing')
                TemplateCard(
                  title: 'Rincian Hasil Sortir',
                  icon: Icons.sort_outlined,
                  child: _buildSortingQty(),
                ),
              if (widget.label == 'Packing')
                TemplateCard(
                  title: 'Informasi Packing',
                  icon: Icons.layers_outlined,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TextForm(
                              label: 'Total Packing (PCS)',
                              req: true,
                              isNumber: true,
                              isSorting: true,
                              initialValue:
                                  widget.processData['qty']?.toString() ?? '0',
                              controller: widget.packingQty,
                              handleChange: (value) {
                                final safeValue = (value == null ||
                                        value.toString().trim().isEmpty)
                                    ? '0'
                                    : value.toString();

                                widget.handleChangeInput('qty', safeValue);

                                setState(() {
                                  final input = double.tryParse(
                                        widget.weightDozen.text
                                            .replaceAll('.', '')
                                            .replaceAll(',', '.'),
                                      ) ??
                                      0;
                                  if (input > 0) {
                                    calculateBeratA(input);
                                  }
                                });
                                setState(() {
                                  widget.validateQty(safeValue);
                                });
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Total packing wajib diisi';
                                }
                                return null;
                              },
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
                              ].separatedBy(CustomTheme().hGap('xl')),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextForm(
                            label: 'Berat 1 Lusin (KG)',
                            req: true,
                            isNumber: true,
                            isSorting: true,
                            initialValue:
                                widget.form['weight_per_dozen']?.toString() ??
                                    '0',
                            controller: widget.weightDozen,
                            handleChange: (val) {
                              final safeValue =
                                  (val == null || val.toString().trim().isEmpty)
                                      ? '0'
                                      : val.toString();

                              // widget.weightDozen.text = safeValue;
                              widget.handleChangeInput(
                                  'weight_per_dozen', safeValue);

                              // final normalized = safeValue.replaceAll(',', '.');
                              setState(() {
                                final input = double.tryParse(
                                      widget.weightDozen.text
                                          .replaceAll('.', '')
                                          .replaceAll(',', '.'),
                                    ) ??
                                    0;

                                calculateGsm(input);
                                calculateBeratA(input);
                                calculateTotalBerat(input);
                              });
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Berat 1 lusin wajib diisi';
                              }
                            }),
                      ),
                    ].separatedBy(CustomTheme().hGap('xl')),
                  ),
                ),
              if (widget.forPacking == true)
                TemplateCard(
                  title: 'Gramasi & Total Berat',
                  icon: Icons.scale_outlined,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextForm(
                          label: 'Gramasi',
                          isDisabled: true,
                          isNumber: true,
                          // isSorting: true,
                          controller: widget.gsm,
                          handleChange: (value) {
                            setState(() {
                              // widget.gsm.text = value.toString();
                              widget.handleChangeInput('gsm', value);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: TextForm(
                          label: 'Berat Grade A (KG)',
                          req: false,
                          isDisabled: true,
                          isNumber: true,
                          // isSorting: true,
                          controller: widget.weightGradeA,
                          handleChange: (value) {
                            setState(() {
                              // widget.weightGradeA.text = value.toString();
                              widget.handleChangeInput('weight_grade_a', value);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: TextForm(
                          label: 'Total Berat Kesuluruhan (KG)',
                          isDisabled: true,
                          isNumber: true,
                          // isSorting: true,
                          controller: widget.totalWeight,
                          handleChange: (value) {
                            setState(() {
                              // widget.totalWeight.text = value.toString();
                              widget.handleChangeInput('total_weight', value);
                            });
                          },
                        ),
                      ),
                    ].separatedBy(CustomTheme().hGap('xl')),
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
            ].separatedBy(CustomTheme().vGap('lg')),
          ),
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }

/*
Multi Mesin
*/
  Widget _buildMachine() {
    final machines = widget.processData['machines'] as List? ?? [];

    if (machines.isEmpty) return NoData();

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: machines.map((machine) {
        return Container(
          width: machines.length > 1
              ? (MediaQuery.of(context).size.width - 80) / 2
              : double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${machine['machine'] != null ? '${machine['machine']['code']} - ${machine['machine']['name']}' : '-'}',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              CustomBadge(
                title: machine['status'] != null ? machine['status'] : '-',
                status: machine['status'] == 'Selesai' ? 'Selesai' : 'Diproses',
                withStatus: true,
              )
            ],
          ),
        );
      }).toList(),
    );
  }

/*
Qty Sorting
*/
  Widget _buildSortingQty() {
    final gradesList = widget.processData['sorting']?['grades'] ?? [];

    double getTotalAdditionalProcess() {
      final data = widget.processData['sorting'];

      if (data == null) return 0;

      final rework = double.tryParse(
            data['rework_long_hemming']?.toString() ?? '0',
          ) ??
          0;

      final spraying = double.tryParse(
            data['spraying']?.toString() ?? '0',
          ) ??
          0;

      final combing = double.tryParse(
            data['combing']?.toString() ?? '0',
          ) ??
          0;

      return rework + spraying + combing;
    }

    final total = getTotalAdditionalProcess();

    // Calculate total quantity
    int totalQty = 0;
    for (var grade in gradesList) {
      final qty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
      totalQty += qty;
    }

    final grandTotal = totalQty + total;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Loop through grades
        ...gradesList.asMap().entries.map((entry) {
          final grade = entry.value;
          final gradeName = grade['item_grade']['code']?.toString() ?? '-';
          final gradeQty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
          final gradeUnit = grade['unit']?['code']?.toString() ?? '';

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8), // 👈 gap
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grade $gradeName',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: CustomTheme().fontWeight('semibold'),
                      ),
                    ),
                    Text(
                      '${formatNumber(gradeQty.toString())} $gradeUnit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: CustomTheme().fontWeight('bold'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perbaikan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: CustomTheme().fontWeight('semibold'),
                  ),
                ),
                Text(
                  '${formatNumber(total.toString())} PCS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: CustomTheme().fontWeight('bold'),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16),
        // Total
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: CustomTheme().fontWeight('bold'),
                  ),
                ),
                Text(
                  '${formatNumber(grandTotal.toStringAsFixed(0))} ${gradesList.isNotEmpty ? gradesList[0]['unit']['code']?.toString() ?? '' : ''}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: CustomTheme().fontWeight('bold'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

/*
Grades
*/
  Widget buildGradeCard(int i) {
    final gradeLabel = getGradeLabel(i);
    final items = widget.data?['items'] ?? [];

    _ensureController(i);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grade Column
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grade',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: CustomTheme().fontWeight('semibold'),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  gradeLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: CustomTheme().fontWeight('semibold'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),

          // Produk Jadi Column
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Produk Jadi',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: CustomTheme().fontWeight('semibold'),
                  ),
                ),
                SizedBox(height: 4),
                _buildFinishedItemCompact(items, i),
              ],
            ),
          ),

          // Qty Column
          Expanded(
            flex: 2,
            child: TextForm(
              label: 'Qty (PCS)',
              req: false,
              isDisabled: i == 2 ? true : false,
              isGrade: true,
              isNumber: true,
              isSorting: true,
              initialValue: _grades[i]['qty']?.toString() ?? '0',
              controller: widget.qtyItem[i],
              handleChange: (val) {
                if (val == null || val.trim().isEmpty) {
                  widget.qty[i].text = '0';
                  widget.qty[i].selection = TextSelection.fromPosition(
                    TextPosition(offset: widget.qty[i].text.length),
                  );
                }

                final safeValue =
                    (val == null || val.trim().isEmpty) ? '0' : val;

                setState(() {
                  _grades[i]['qty'] = safeValue;
                });

                widget.handleUpdateGrade(i, 'qty', safeValue);
              },
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }

/*
Rework
*/
  Widget _buildReworkReference() {
    final items = [
      {
        'label': 'No. Dyeing',
        'value': widget.processData['rework_reference']?['dyeing_no'] ?? '-',
        'icon': Icons.description_outlined,
      },
      {
        'label': 'Tanggal',
        'value': DateFormat("dd MMM yyyy").format(DateTime.parse(
            widget.data['rework_reference']?['start_time'] ??
                DateTime.now().toString())),
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
        spacing: 16,
        runSpacing: 16,
        children: items.map((item) {
          return Container(
            padding: CustomTheme().padding('card'),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['label'].toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      item['value'].toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ].separatedBy(CustomTheme().vGap('md')),
                ),
              ],
            ),
          );
        }).toList());
  }

/*
Produk Jadi Compact (for table display)
*/
  Widget _buildFinishedItemCompact(List items, int i) {
    final item = (items.length > i) ? items[i] : null;
    final gradeLabel = getGradeLabel(i);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item != null && item['item_code'] != null
              ? item['item_code'].toString()
              : gradeLabel == 'Grade B'
                  ? widget.finishedItem[0]['code']
                  : '-',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Text(
          item != null && item['item_name'] != null
              ? item['item_name'].toString()
              : gradeLabel == 'Grade B'
                  ? widget.finishedItem[0]['label']
                  : '-',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

/*
Select Tipe BS
*/
  void _showSelectDefectTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.5,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Text(
                  'Pilih Tipe BS',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('xl'),
                    fontWeight: CustomTheme().fontWeight('bold'),
                    height: 1,
                  ),
                ),
              ),
              Divider(),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var option in widget.itemTypeOption ?? [])
                            ListTile(
                              title: Text(option['name'] ?? ''),
                              onTap: () {
                                final exists = widget.defects.any(
                                  (d) =>
                                      d['defect_type_id'].toString() ==
                                      option['id'].toString(),
                                );

                                if (!exists) {
                                  setState(() {
                                    widget.defects.add({
                                      'defect_type_id': option['id'],
                                      'qty': '0',
                                    });
                                    widget.defectQty.add(
                                      TextEditingController(text: '0'),
                                    );
                                    widget.form['defects'] = widget.defects;
                                  });
                                }

                                Navigator.pop(context);
                                _showDefectQtyDialog(widget.defects.length - 1);
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*
Input Qty Tipe BS
*/
  void _showDefectQtyDialog(int index) {
    final controller = TextEditingController(
      text: widget.defects[index]['qty']?.toString() ?? '0',
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.4,
            maxHeight: MediaQuery.of(context).size.height * 0.4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: Text(
                          '${getDefectLabel(index)} - Input Qty',
                          style: TextStyle(
                            fontSize: CustomTheme().fontSize('xl'),
                            fontWeight: CustomTheme().fontWeight('bold'),
                            height: 1,
                          ),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: TextForm(
                          label: 'Qty',
                          req: true,
                          isNumber: true,
                          initialValue:
                              widget.defects[index]['qty']?.toString() ?? '0',
                          controller: controller,
                          handleChange: (value) {
                            final safeValue =
                                (value == null || value.trim().isEmpty)
                                    ? '0'
                                    : value;

                            widget.defects[index]['qty'] = toDouble(safeValue);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: CancelButton(
                          label: 'Batal',
                          onPressed: () => Navigator.pop(context),
                          fontSize: CustomTheme().fontSize('xl'),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: FormButton(
                          label: 'Simpan',
                          onPressed: () {
                            setState(() {
                              widget.defects[index]['qty'] =
                                  controller.text.replaceAll(',', '');
                              widget.defectQty[index].text =
                                  controller.text.replaceAll(',', '');
                              widget.form['defects'] = widget.defects;
                              // ✅ AUTO-CALCULATE BS GRADE
                              _recalculateGradeBS();
                            });
                            Navigator.pop(context);
                          },
                          fontSize: CustomTheme().fontSize('xl'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*
Tipe BS (BS-an)
*/
  Widget _buildMultiTipeUpdate() {
    return TemplateCard(
      title: 'Tipe BS (BS-an)',
      icon: Icons.stop_circle_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LIST TIPE BS (HORIZONTAL)
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 24) / 4;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  /// ✅ DISPLAY SELECTED DEFECTS
                  if (widget.defects.isNotEmpty)
                    ...widget.defects.asMap().entries.map((entry) {
                      int i = entry.key;
                      var defect = entry.value;

                      _ensureDefectController(i);

                      final defectQty =
                          int.tryParse(defect['qty']?.toString() ?? '0') ?? 0;
                      // final hasQty = defectQty > 0;

                      return SizedBox(
                        width: itemWidth,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (getDefectLabel(i)),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  CustomBadge(
                                    title:
                                        'Qty: ${formatNumber(defectQty).toString()} PCS',
                                    status: 'Selesai',
                                    rework: true,
                                  ),
                                ].separatedBy(CustomTheme().vGap('lg')),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: GestureDetector(
                                      onTap: () => _showDefectQtyDialog(i),
                                      child: Icon(Icons.edit,
                                          color: Colors.blue, size: 32),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        showConfirmationDialog(
                                          context: context,
                                          title: 'Hapus Tipe BS',
                                          message:
                                              'Apakah Anda yakin ingin menghapus ${getDefectLabel(i)}?',
                                          isLoading: _isLoading,
                                          buttonBackground: CustomTheme()
                                              .buttonColor('danger'),
                                          onConfirm: () async {
                                            setState(() {
                                              widget.defects.removeAt(i);
                                              if (i < widget.defectQty.length) {
                                                widget.defectQty[i].dispose();
                                                widget.defectQty.removeAt(i);
                                              }
                                              widget.form['defects'] =
                                                  widget.defects;
                                              _recalculateGradeBS();
                                            });
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                      child: Icon(Icons.close,
                                          color: Colors.red, size: 32),
                                    ),
                                  ),
                                ].separatedBy(CustomTheme().hGap('lg')),
                              )
                            ].separatedBy(CustomTheme().vGap('lg')),
                          ),
                        ),
                      );
                    }),
                ],
              );
            },
          ),

          /// ✅ ADD BUTTON (also inline)
          GestureDetector(
            onTap: () => _showSelectDefectTypeDialog(),
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text('+ Tambah Tipe BS'),
              ),
            ),
          ),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

/*
Produk Jadi
*/
  Widget _buildFinishedMaterial() {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.processData['greige_item'] != null
                          ? '${widget.processData['greige_item']['code'] ?? '-'}'
                          : '-',
                    ),
                    Text(
                      widget.processData['greige_item'] != null
                          ? '${widget.processData['greige_item']['name'] ?? '-'}'
                          : '-',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
