// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
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
      this.weightGradeA});

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
    // widget.woData['grades'] as List<dynamic>?;

    // if (grades == null || grades.isEmpty) return 0;

    // return grades.fold<double>(0, (sum, grade) {
    //   final qty = double.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
    //   return sum + qty;
    // });

    return grades;
  }

  double getMaxTotalQty() {
    final grades = widget.woData['processes'][10]['data'][0]['grades'] ?? [];

    // if (grades == null || grades.isEmpty) return 0;

    // return grades.fold<double>(0, (sum, grade) {
    //   final qty = double.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
    //   return sum + qty;
    // });
    int totalQty = 0;
    for (var grade in grades) {
      final qty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
      totalQty += qty;
    }

    return double.tryParse(totalQty.toString() ?? '0') ?? 0.0;
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

      beratGradeA = maxQty == 0 ? 0 : (beratLusin / 12) * maxQty;

      widget.gsm.text = gsm.toStringAsFixed(2);
      widget.totalWeight.text = beratGradeA.toStringAsFixed(2);

      widget.handleChangeInput('gsm', gsm.toStringAsFixed(2));
      widget.handleChangeInput(
        'weight_grade_a',
        beratGradeA.toStringAsFixed(2),
      );
    });
  }

  void calculateTotalFromBeratLusin(double value) {
    final maxQty = getMaxTotalQty();

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
    final cleaned = val?.toString().replaceAll('.', '').replaceAll(',', '.');

    return double.tryParse(cleaned ?? '') ?? 0;
  }

  /// 📊 Calculate total vermak (spraying + combing + rework_long_hemming)
  int _calculateTotalVermak() {
    final spraying = int.tryParse(widget.spraying.text ?? '0') ?? 0;
    final combing = int.tryParse(widget.combing.text ?? '0') ?? 0;
    final rework = int.tryParse(widget.reworkLongHemming.text ?? '0') ?? 0;
    return spraying + combing + rework;
  }

  /// 📊 Calculate total qty sorting (all grades + vermak)
  int _calculateTotalQtySorting() {
    int totalGrades = 0;
    for (var grade in _grades) {
      final qty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
      totalGrades += qty;
    }
    return totalGrades + _calculateTotalVermak();
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
        final qty = int.tryParse(defect['qty']?.toString() ?? '0') ?? 0;
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

      if (index < widget.qty.length) {
        widget.qty[index].text = totalBs.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> formRows = [
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
      if (widget.forDyeing == false &&
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
        if (widget.id != null)
          TemplateCard(
              title: 'Work Order',
              icon: Icons.paste_outlined,
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
                          controller: widget.spraying,
                          handleChange: (value) {
                            widget.handleChangeInput('spraying', value);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextForm(
                          label: 'Permak Long Hemming',
                          req: false,
                          isNumber: true,
                          controller: widget.reworkLongHemming,
                          handleChange: (value) {
                            widget.handleChangeInput(
                                'rework_long_hemming', value);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextForm(
                          label: 'Sisiran',
                          req: false,
                          isNumber: true,
                          controller: widget.combing,
                          handleChange: (value) {
                            widget.handleChangeInput('combing', value);
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
                        ..._buildGradeCardsInOrder(),
                    ].separatedBy(CustomTheme().vGap('2xl')),
                  ),
                ),
              if (widget.label == 'Sorting')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TemplateCard(
                      title: 'Ringkasan Sorting',
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
                                          '${_grades[0]['qty'] ?? '0'}',
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
                                          '${_grades[1]['qty'] ?? '0'}',
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
                                          '${_grades[2]['qty'] ?? '0'}',
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
                                          '${_calculateTotalVermak()}',
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
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.green.shade200),
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
                                          '${_calculateTotalQtySorting()}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green.shade700),
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
                                selectedLabel: widget.form['nama_item'] ?? '',
                                selectedCode: widget.form['sku_item'] ?? '',
                                selectedValue: widget.form['finished_item_id']
                                        ?.toString() ??
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
              if (widget.label == 'Packing')
                TemplateCard(
                  title: 'Hasil Sorting (Grade A)',
                  icon: Icons.numbers_outlined,
                  child: _buildSortingQty(),
                ),
              if (widget.label == 'Packing')
                TemplateCard(
                  title: 'Produk Jadi',
                  icon: Icons.inventory_2_outlined,
                  child: _buildFinishedMaterial(),
                ),
              if (widget.label == 'Packing')
                TemplateCard(
                  title: 'Informasi Packing',
                  icon: Icons.layers_outlined,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextForm(
                            label: 'Total Packing (PCS)',
                            req: true,
                            isNumber: true,
                            controller: widget.packingQty,
                            handleChange: (val) {
                              final safeValue =
                                  (val == null || val.toString().trim().isEmpty)
                                      ? '0'
                                      : val.toString();

                              widget.packingQty.text = safeValue;
                              widget.handleChangeInput('qty', safeValue);

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
                      Expanded(
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
                              calculateTotalFromBeratLusin(input);
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
                  title: 'Gramasi & Total Berat',
                  icon: Icons.scale_outlined,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextForm(
                          label: 'Gramasi',
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
                      Expanded(
                        child: TextForm(
                          label: 'Berat Grade A (PCS)',
                          req: false,
                          isDisabled: true,
                          controller: widget.weightGradeA,
                          handleChange: (value) {
                            widget.weightGradeA.text = value.toString();
                            widget.handleChangeInput('weight_grade_a', value);
                          },
                        ),
                      ),
                      Expanded(
                        child: TextForm(
                          label: 'Total Berat Kesuluruhan (KG)',
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
            ].separatedBy(CustomTheme().vGap('2xl')),
          ),
      ].separatedBy(CustomTheme().vGap('2xl')),
    );
  }

/*
Multi Mesin
*/
  Widget _buildMachine() {
    final machines = widget.processData['machines'] as List? ?? [];

    if (machines.isEmpty) return NoData();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
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

/*
Qty Sorting
*/
  Widget _buildSortingQty() {
    final gradesList =
        widget.woData['processes'][10]['data'][0]['grades'] ?? [];

    // Calculate total quantity
    int totalQty = 0;
    for (var grade in gradesList) {
      final qty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
      totalQty += qty;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Loop through grades
          ...gradesList.asMap().entries.map((entry) {
            final grade = entry.value;
            final gradeName = grade['grade']?.toString() ?? '-';
            final gradeQty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
            final gradeUnit = grade['unit_code']?.toString() ?? '';

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Grade ${gradeName}',
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
                if (entry.key < gradesList.length - 1) SizedBox(height: 12),
              ],
            );
          }).toList(),
          SizedBox(height: 12),
          Divider(color: Colors.grey.shade300),
          SizedBox(height: 12),
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                '${formatNumber(totalQty.toString())} ${gradesList.isNotEmpty ? gradesList[0]['unit_code']?.toString() ?? '' : ''}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: CustomTheme().fontWeight('bold'),
                  color: CustomTheme().colors('primary'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

/*
Build Grade Cards in Order (A, B, BS)
*/
  List<Widget> _buildGradeCardsInOrder() {
    // Define the desired grade order
    final gradeOrder = ['Grade A', 'Grade B', 'Grade BS'];

    // Create list of indices
    final indices = List.generate(widget.itemGradeOption.length, (i) => i);

    // Sort indices based on grade label order
    indices.sort((a, b) {
      final labelA = getGradeLabel(a);
      final labelB = getGradeLabel(b);
      final orderA = gradeOrder.indexOf(labelA);
      final orderB = gradeOrder.indexOf(labelB);

      // If label not found in gradeOrder, put it at the end
      return orderA.compareTo(orderB);
    });

    // Build grade cards in sorted order
    return indices.map((i) => buildGradeCard(i)).toList();
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
                      double.tryParse(widget.weightDozen.text.toString()) ?? 0;
                  if (input > 0) {
                    calculateFromBeratLusin(input);
                  }
                });
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
                mainAxisSize: MainAxisSize.min,
                children: [
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

/*
Produk Jadi
*/
  Widget _buildFinishedItem(List items, int i) {
    final item = (items.length > i) ? items[i] : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Produk Jadi'),
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
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }

/*
Produk Jadi Compact (for table display)
*/
  Widget _buildFinishedItemCompact(List items, int i) {
    final item = (items.length > i) ? items[i] : null;
    final gradeLabel = getGradeLabel(i);
    final itemCode =
        widget.processData['grades'][2]?['greige_item']['code'] ?? '-';
    final itemName =
        widget.processData['grades'][2]?['greige_item']['name'] ?? '-';

    return Container(
      // padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      // decoration: BoxDecoration(
      //   color: Colors.grey.shade50,
      //   borderRadius: BorderRadius.circular(4),
      //   border: Border.all(color: Colors.grey.shade200),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item != null && item['item_code'] != null
                ? item['item_code'].toString()
                : gradeLabel == 'Grade B'
                    ? itemCode
                    : '-',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text(
            item != null && item['item_name'] != null
                ? item['item_name'].toString()
                : gradeLabel == 'Grade B'
                    ? itemName
                    : '-',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            maxHeight: MediaQuery.of(context).size.height * 0.6,
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
                            EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        child: Text(
                          'Pilih Tipe BS',
                          style: TextStyle(
                            fontSize: CustomTheme().fontSize('2xl'),
                            fontWeight: CustomTheme().fontWeight('bold'),
                            height: 1,
                          ),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var option in widget.itemTypeOption ?? [])
                              ListTile(
                                title: Text(option['name'] ?? ''),
                                onTap: () {
                                  final exists = widget.defects.firstWhere(
                                    (d) =>
                                        d['defect_type_id'].toString() ==
                                        option['id'].toString(),
                                    orElse: () => {},
                                  );

                                  if (exists.isEmpty) {
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
                                  _showDefectQtyDialog(
                                      widget.defects.length - 1);
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Tutup',
                        style: TextStyle(
                          color: CustomTheme().buttonColor('primary'),
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
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            maxHeight: MediaQuery.of(context).size.height * 0.6,
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
                            EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        child: Text(
                          '${getDefectLabel(index)} - Input Qty',
                          style: TextStyle(
                            fontSize: CustomTheme().fontSize('2xl'),
                            fontWeight: CustomTheme().fontWeight('bold'),
                            height: 1,
                          ),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        child: TextForm(
                          label: 'Qty',
                          req: true,
                          isNumber: true,
                          controller: controller,
                          handleChange: (value) {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          color: CustomTheme().buttonColor('danger'),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          widget.defects[index]['qty'] = controller.text;
                          widget.defectQty[index].text = controller.text;
                          widget.form['defects'] = widget.defects;
                          // ✅ AUTO-CALCULATE BS GRADE
                          _recalculateGradeBS();
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Simpan',
                        style: TextStyle(
                          color: CustomTheme().buttonColor('primary'),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                /// ✅ DISPLAY SELECTED DEFECTS
                if (widget.defects.isNotEmpty)
                  ...widget.defects.asMap().entries.map((entry) {
                    int i = entry.key;
                    var defect = entry.value;

                    _ensureDefectController(i);

                    final defectQty =
                        int.tryParse(defect['qty']?.toString() ?? '0') ?? 0;
                    final hasQty = defectQty > 0;

                    return Container(
                      margin: EdgeInsets.only(right: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                capitalizeWords(getDefectLabel(i)),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Qty: $defectQty',
                                style: TextStyle(
                                    fontSize: CustomTheme().fontSize('sm')),
                              ),
                            ].separatedBy(SizedBox(height: 4)),
                          ),
                          SizedBox(width: 8),
                          if (hasQty)
                            GestureDetector(
                              onTap: () => _showDefectQtyDialog(i),
                              child: Icon(Icons.edit,
                                  color: Colors.blue, size: 18),
                            ),
                          if (hasQty)
                            GestureDetector(
                              onTap: () {
                                showConfirmationDialog(
                                  context: context,
                                  title: 'Hapus Tipe BS',
                                  message:
                                      'Anda yakin ingin menghapus ${getDefectLabel(i)}?',
                                  isLoading: _isLoading,
                                  buttonBackground:
                                      CustomTheme().buttonColor('danger'),
                                  onConfirm: () async {
                                    setState(() {
                                      widget.defects.removeAt(i);
                                      if (i < widget.defectQty.length) {
                                        widget.defectQty[i].dispose();
                                        widget.defectQty.removeAt(i);
                                      }
                                      widget.form['defects'] = widget.defects;
                                      _recalculateGradeBS();
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              child: Icon(Icons.close,
                                  color: Colors.red, size: 18),
                            ),
                        ].separatedBy(SizedBox(width: 4)),
                      ),
                    );
                  }),
              ],
            ),
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
                      widget.processData['work_orders']['items'][0]
                                  ['item_code'] !=
                              null
                          ? '${widget.processData['work_orders']['items'][0]['item_code'] ?? '-'}'
                          : '-',
                    ),
                    Text(
                      widget.processData['work_orders']['items'][0] != null
                          ? '${widget.processData['work_orders']['items'][0]['item_name'] ?? '-'}'
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
