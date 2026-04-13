// ignore_for_file: file_names, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/update/detail_work_order.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/master/machine.dart';

class UpdateProcess extends StatefulWidget {
  final id;
  final label;
  final form;
  final formKey;
  final data;
  final woData;
  final handleUpdate;
  final handleSelectMachine;
  final handleSelectItemType;
  final withMaklon;
  final maklon;
  final qtyItem;
  final handleChangeInput;
  final withQtyAndWeight;
  final handleSelectQtyItemUnit;
  final length;
  final width;
  final weight;
  final handleSelectUnit;
  final handleSelectWidthUnit;
  final handleSelectLengthUnit;
  final isSubmitting;
  final forDyeing;
  final grades;
  final getMachineStatus;
  final handleFetchMachine;
  final qty;
  final defectQty;
  final note;
  final itemGradeOption;
  final onGradeChanged;
  final itemTypeOption;
  final defects;
  final handleUpdateGrade;
  final handleUpdateDefect;
  final reworkLongHemming;
  final combing;
  final spraying;
  final cuttingSewingQty;
  final packingQty;
  final defectWeight;
  final goodWeight;
  final gsm;
  final totalWeight;
  final weightPerDozen;
  final weightGradeA;
  final finishedItemGrb;

  const UpdateProcess(
      {super.key,
      this.label,
      this.id,
      this.form,
      this.withMaklon,
      this.handleSelectItemType,
      this.data,
      this.maklon,
      this.handleChangeInput,
      this.qtyItem,
      this.handleSelectQtyItemUnit,
      this.withQtyAndWeight,
      this.length,
      this.weight,
      this.width,
      this.handleUpdate,
      this.handleSelectUnit,
      this.handleSelectWidthUnit,
      this.handleSelectLengthUnit,
      this.isSubmitting,
      this.formKey,
      this.forDyeing,
      this.handleSelectMachine,
      this.grades,
      this.getMachineStatus,
      this.handleFetchMachine,
      this.defectQty,
      this.note,
      this.qty,
      this.itemGradeOption,
      this.onGradeChanged,
      this.itemTypeOption,
      this.defects,
      this.handleUpdateGrade,
      this.handleUpdateDefect,
      this.reworkLongHemming,
      this.combing,
      this.spraying,
      this.woData,
      this.cuttingSewingQty,
      this.defectWeight,
      this.goodWeight,
      this.packingQty,
      this.gsm,
      this.totalWeight,
      this.weightPerDozen,
      this.weightGradeA,
      this.finishedItemGrb});

  @override
  State<UpdateProcess> createState() => _UpdateProcessState();
}

class _UpdateProcessState extends State<UpdateProcess> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  bool _isMaklon = false;
  late List<Map<String, dynamic>> _grades;
  late List<Map<String, dynamic>> _defects;
  double beratLusin = 0;
  double gsm = 0;
  double totalBeratA = 0;
  double totalBerat = 0;

  List<Map<String, dynamic>> _newMachines = [];

  @override
  void initState() {
    super.initState();

    _isMaklon = widget.data['maklon'] ?? false;

    _grades = (widget.grades ?? [])
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();
    _defects = (widget.defects ?? [])
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncGradesWithOptions();
      _syncDefectsWithOptions();
    });
  }

  String capitalizeWords(String text) {
    return text.toLowerCase().split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  void _syncGradesWithOptions() {
    final List<Map<String, dynamic>> updated = [];

    for (int i = 0; i < widget.itemGradeOption.length; i++) {
      final grade = widget.itemGradeOption[i];

      final existing = _grades.firstWhere(
        (g) => g['item_grade_id'].toString() == grade['id'].toString(),
        orElse: () => {},
      );

      dynamic greigeItemId;

      if (i == 0) {
        greigeItemId =
            widget.data?['work_orders']?['items']?[0]?['greige_item_id'];
      } else if (i == 1) {
        greigeItemId = widget.finishedItemGrb.isNotEmpty
            ? widget.finishedItemGrb[0]['value']
            : null;
      } else if (i == 2) {
        greigeItemId = null;
      } else {
        greigeItemId = existing['greige_item_id'];
      }

      updated.add({
        'item_grade_id': grade['id'],
        'unit_id': existing['unit_id'] ?? 1,
        'qty': existing['qty'] ?? '0',
        'notes': existing['notes'] ?? '',
        'greige_item_id': greigeItemId,
      });
    }

    setState(() {
      _grades = updated;
    });

    widget.handleChangeInput('grades', _grades);
  }

  void _syncDefectsWithOptions() {
    /// ✅ ONLY KEEP EXISTING DEFECTS (don't auto-create all types)
    final List<Map<String, dynamic>> updated = [];

    for (var defect in _defects) {
      // Extract defect type ID from nested structure or from flat structure
      final defectId =
          defect['type']?['id'] ?? defect['defect_type_id'] ?? defect['id'];

      // Check if this defect type exists in master data
      final exists = (widget.itemTypeOption ?? []).firstWhere(
        (type) => type['id'].toString() == defectId.toString(),
        orElse: () => <String, dynamic>{},
      );

      // Only keep if exists in master data
      if (exists.isNotEmpty) {
        updated.add({
          'defect_type_id': defectId,
          'qty': defect['qty'] ?? '0',
        });
      }
    }

    setState(() {
      _defects = updated;
      widget.form['defects'] = _defects;

      // Re-initialize defect qty controllers to match synced defects
      for (var controller in widget.defectQty) {
        controller.dispose();
      }
      widget.defectQty.clear();
      for (var defect in _defects) {
        widget.defectQty.add(
          TextEditingController(text: defect['qty']?.toString() ?? '0'),
        );
      }
    });

    widget.handleChangeInput('defects', _defects);
  }

  void _recalculateGradeBS() {
    final totalBs = _defects.fold<int>(
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

  String getGradeLabel(int i) {
    return widget.itemGradeOption.firstWhere(
          (e) => e['id'].toString() == _grades[i]['item_grade_id'].toString(),
          orElse: () => {'name': ''},
        )['name'] ??
        '';
  }

  String getDefectLabel(int i) {
    return widget.itemTypeOption.firstWhere(
          (e) => e['id'].toString() == _defects[i]['defect_type_id'].toString(),
          orElse: () => {'name': ''},
        )['name'] ??
        '';
  }

  int _calculateTotalVermak() {
    final spraying = int.tryParse(widget.spraying.text ?? '0') ?? 0;
    final combing = int.tryParse(widget.combing.text ?? '0') ?? 0;
    final rework = int.tryParse(widget.reworkLongHemming.text ?? '0') ?? 0;
    return spraying + combing + rework;
  }

  int _calculateTotalQtySorting() {
    int totalGrades = 0;
    for (var grade in _grades) {
      final qty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
      totalGrades += qty;
    }
    return totalGrades + _calculateTotalVermak();
  }

  void _ensureController(int index) {
    while (widget.qty.length <= index) {
      widget.qty.add(TextEditingController(text: '0'));
    }
  }

  void _ensureDefectController(int index) {
    while (widget.defectQty.length <= index) {
      widget.defectQty.add(TextEditingController(text: '0'));
    }
  }

  double getMaxQtyFromGrades() {
    final grades =
        double.tryParse(widget.form['qty']?.toString() ?? '0') ?? 0.0;

    return grades;
  }

  double getMaxTotalQty() {
    final gradesList =
        // double.tryParse(widget.form['total_sorting']?.toString() ?? '0') ?? 0.0;
        widget.woData['processes'][10]['data'][0]['grades'] ?? [];

    int totalQty = 0;
    for (var grade in gradesList) {
      final qty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
      totalQty += qty;
    }

    return
        // gradesList;
        double.tryParse(totalQty.toString() ?? '0') ?? 0.0;
  }

  void calculateGsm(double value) {
    final maxQty = getMaxQtyFromGrades();

    final size = widget.woData['items'][0]['variants'][1]['value'];
    final panjang = int.tryParse(size.split('X')[0]) ?? 0;
    final lebar = int.tryParse(size.split('X')[1]) ?? 0;

    setState(() {
      beratLusin = value;

      if (panjang == 0 || lebar == 0) {
        gsm = 0;
      } else {
        gsm = (beratLusin * 10000000) / (12 * panjang * lebar);
      }

      // totalBeratA = maxQty == 0 ? 0 : (beratLusin / 12) * maxQty;

      widget.gsm.text = gsm.toStringAsFixed(2);
      // widget.weightGradeA.text = totalBeratA.toStringAsFixed(2);

      widget.handleChangeInput('gsm', gsm.toStringAsFixed(2));
      // widget.handleChangeInput(
      //   'weight_grade_a',
      //   totalBeratA.toStringAsFixed(2),
      // );
    });
  }

  void calculateBeratA(double value) {
    final maxQty = getMaxQtyFromGrades();

    final size = widget.woData['items'][0]['variants'][1]['value'];
    final panjang = int.tryParse(size.split('X')[0]) ?? 0;
    final lebar = int.tryParse(size.split('X')[1]) ?? 0;

    setState(() {
      beratLusin = value;

      if (panjang == 0 || lebar == 0) {
        gsm = 0;
      } else {
        gsm = (beratLusin * 10000000) / (12 * panjang * lebar);
      }

      totalBeratA = maxQty == 0 ? 0 : (beratLusin / 12) * maxQty;

      // widget.gsm.text = gsm.toStringAsFixed(2);
      widget.weightGradeA.text = totalBeratA.toStringAsFixed(2);

      // widget.handleChangeInput('gsm', gsm.toStringAsFixed(2));
      widget.handleChangeInput(
        'weight_grade_a',
        totalBeratA.toStringAsFixed(2),
      );
    });
  }

  void calculateTotalBerat(double value) {
    final maxQty = getMaxTotalQty();

    final size = widget.woData['items'][0]['variants'][1]['value'];
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

  Future<void> _handleCancel(BuildContext context) async {
    if (context.mounted) {
      showConfirmationDialog(
          context: context,
          isLoading: _isLoading,
          onConfirm: () async {
            await Future.delayed(Duration(milliseconds: 200));
            Navigator.pop(context);
            Navigator.pop(context);
          },
          title: 'Batal Edit Proses ${widget.label}',
          message: 'Anda yakin ingin kembali? Semua perubahan tidak disimpan',
          buttonBackground: CustomTheme().buttonColor('danger'));
    }
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (context.mounted) {
      showConfirmationDialog(
        context: context,
        isLoading: widget.isSubmitting,
        onConfirm: () async {
          await Future.delayed(Duration(milliseconds: 200));
          widget.isSubmitting.value = true;

          try {
            /// 🔥 MULTI MACHINE PROCESS
            if (widget.label == 'Long Hemming' ||
                widget.label == 'Cross Cutting' ||
                widget.label == 'Sewing') {
              final machines = List<Map<String, dynamic>>.from(
                widget.data['machines'] ?? [],
              );

              widget.form['machines'] = machines;
              // ✅ HANYA KIRIM MESIN YANG BARU DITAMBAHKAN
              widget.form['machine_ids'] = _newMachines
                  .map((e) => e['machine']['id'])
                  .where((id) => id != null)
                  .toList();

              widget.form['machine_id'] = null;
              widget.form['nama_mesin'] = null;
              widget.form['maklon'] = false;
              widget.form['maklon_name'] = null;
            }

            /// 🔥 MAKLON
            else if (_isMaklon == true) {
              widget.form['machines'] = [];
              widget.form['machine_ids'] = [];
              widget.form['machine_id'] = null;
              widget.form['nama_mesin'] = null;
              widget.form['maklon'] = true;
            }

            /// 🔥 SINGLE MACHINE
            else {
              widget.form['machines'] = [];
              widget.form['machine_ids'] = [];
              widget.form['maklon_name'] = null;
              widget.form['maklon'] = false;
            }

            widget.form['wo_id'] = widget.data['wo_id'];

            await widget.handleUpdate(widget.data['id'].toString());
            Navigator.pop(context);
          } finally {
            widget.isSubmitting.value = false;
          }
        },
        title: 'Edit Proses ${widget.label}',
        message: 'Anda yakin ingin mengubah proses?',
        buttonBackground: CustomTheme().buttonColor('primary'),
      );
    }
  }

  @override
  void didUpdateWidget(covariant UpdateProcess oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemGradeOption != widget.itemGradeOption) {
      _syncGradesWithOptions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Color(0xFFf9fafc),
            appBar: CustomAppBar(
              title: 'Edit ${widget.label}',
              onReturn: () => _handleCancel(context),
              id: widget.id,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: TabBar(tabs: [
                      Tab(
                        text: 'Form Edit',
                      ),
                      Tab(
                        text: 'Info WO',
                      ),
                    ]),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                            child: Container(
                          padding: CustomTheme().padding('content'),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.data['machines'] == null &&
                                    widget.data['maklon'] != null)
                                  TemplateCard(
                                    title: 'Maklon',
                                    icon: Icons.business_outlined,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (widget.withMaklon == true)
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Maklon',
                                                        style: TextStyle(
                                                            fontSize:
                                                                CustomTheme()
                                                                    .fontSize(
                                                                        'lg')),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Switch(
                                                            value: _isMaklon,
                                                            onChanged: widget
                                                                        .data[
                                                                    'can_update']
                                                                ? (value) {
                                                                    setState(
                                                                        () {
                                                                      _isMaklon =
                                                                          value;
                                                                      widget.form[
                                                                              'maklon'] =
                                                                          value;
                                                                    });
                                                                  }
                                                                : null,
                                                            activeColor:
                                                                Colors.green,
                                                            inactiveThumbColor:
                                                                Colors
                                                                    .redAccent,
                                                          ),
                                                          Text(widget.data[
                                                                  'maklon']
                                                              ? 'Ya'
                                                              : 'Tidak'),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                if (_isMaklon == true)
                                                  TextForm(
                                                    label: 'Nama Maklon',
                                                    req: false,
                                                    controller: widget.maklon,
                                                    handleChange: (value) {
                                                      setState(() {
                                                        widget.maklon.text =
                                                            value.toString();
                                                        widget.form[
                                                                'maklon_name'] =
                                                            value.toString();
                                                      });
                                                    },
                                                  ),
                                              ].separatedBy(
                                                  CustomTheme().vGap('lg')),
                                            ),
                                          ].separatedBy(
                                              CustomTheme().vGap('lg')),
                                        ),
                                      ].separatedBy(CustomTheme().vGap('lg')),
                                    ),
                                  ),
                                if (!_isMaklon &&
                                    widget.label != 'Sorting' &&
                                    widget.label != 'Packing')
                                  TemplateCard(
                                    title: 'Mesin',
                                    icon: Icons.local_laundry_service_outlined,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (widget.label == 'Long Hemming' ||
                                            widget.label == 'Cross Cutting' ||
                                            widget.label == 'Sewing')
                                          _buildMultiMesinUpdate()
                                        else
                                          SelectForm(
                                            label: 'Mesin',
                                            onTap: () =>
                                                widget.handleSelectMachine(),
                                            selectedLabel:
                                                widget.form['nama_mesin'] ?? '',
                                            selectedValue: widget
                                                .form['machine_id']
                                                .toString(),
                                            required: false,
                                          ),
                                      ].separatedBy(CustomTheme().vGap('lg')),
                                    ),
                                  ),
                                if (widget.label == 'Long Hemming')
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TemplateCard(
                                        title: 'Berat',
                                        icon: Icons.scale_outlined,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: TextForm(
                                                label: 'Berat Bagus',
                                                req: false,
                                                isNumber: true,
                                                controller: widget.goodWeight,
                                                handleChange: (value) {
                                                  final safeValue =
                                                      (value == null ||
                                                              value
                                                                  .toString()
                                                                  .trim()
                                                                  .isEmpty)
                                                          ? '0'
                                                          : value.toString();

                                                  widget.handleChangeInput(
                                                      'good_weight', safeValue);
                                                  calculateLongHemmingWeight();
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: TextForm(
                                                label: 'Berat BS',
                                                req: false,
                                                isNumber: true,
                                                controller: widget.defectWeight,
                                                handleChange: (value) {
                                                  widget.handleChangeInput(
                                                      'bs_weight', value);
                                                  calculateLongHemmingWeight();
                                                },
                                              ),
                                            ),
                                            // Expanded(
                                            //   child: TextForm(
                                            //     label: 'Berat',
                                            //     req: false,
                                            //     isDisabled: true,
                                            //     isNumber: true,
                                            //     controller: widget.weight,
                                            //     handleChange: (value) {
                                            //       widget.handleChangeInput(
                                            //           'weight', value);
                                            //     },
                                            //   ),
                                            // ),
                                          ].separatedBy(
                                              CustomTheme().hGap('lg')),
                                        ),
                                      ),
                                    ].separatedBy(CustomTheme().vGap('lg')),
                                  ),
                                if (widget.label == 'Cross Cutting' ||
                                    widget.label == 'Sewing')
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TemplateCard(
                                        title: 'Qty',
                                        icon: Icons.numbers_outlined,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextForm(
                                              label:
                                                  'Qty Hasil ${widget.label} (PCS)',
                                              req: false,
                                              isNumber: true,
                                              controller:
                                                  widget.cuttingSewingQty,
                                              handleChange: (value) {
                                                widget.handleChangeInput(
                                                    'item_qty', value);
                                              },
                                            ),
                                          ].separatedBy(
                                              CustomTheme().vGap('lg')),
                                        ),
                                      ),
                                    ].separatedBy(CustomTheme().vGap('lg')),
                                  ),
                                if (widget.label == 'Packing')
                                  TemplateCard(
                                    title: 'Rincian Hasil Sortir',
                                    icon: Icons.sort_outlined,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                children: [_buildSortingQty()],
                                              ),
                                            ),
                                          ].separatedBy(
                                              CustomTheme().hGap('xl')),
                                        ),
                                      ].separatedBy(CustomTheme().vGap('lg')),
                                    ),
                                  ),
                                if (widget.label == 'Packing')
                                  TemplateCard(
                                    title: 'Packing',
                                    icon: Icons.layers_outlined,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: TextForm(
                                            label: 'Total Packing (PCS)',
                                            req: false,
                                            isNumber: true,
                                            controller: widget.packingQty,
                                            handleChange: (value) {
                                              final safeValue =
                                                  (value == null ||
                                                          value
                                                              .toString()
                                                              .trim()
                                                              .isEmpty)
                                                      ? '0'
                                                      : value.toString();

                                              widget.packingQty.text =
                                                  safeValue;
                                              widget.handleChangeInput(
                                                  'qty', safeValue);

                                              final normalized = safeValue
                                                  .replaceAll(',', '.');
                                              final input =
                                                  double.tryParse(normalized) ??
                                                      0;

                                              setState(() {
                                                final input = double.tryParse(
                                                        widget
                                                            .weightPerDozen.text
                                                            .toString()) ??
                                                    0;
                                                if (input > 0) {
                                                  calculateBeratA(input);
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: TextForm(
                                            label: 'Berat 1 Lusin (KG)',
                                            req: false,
                                            isNumber: true,
                                            controller: widget.weightPerDozen,
                                            handleChange: (val) {
                                              final safeValue = (val == null ||
                                                      val
                                                          .toString()
                                                          .trim()
                                                          .isEmpty)
                                                  ? '0'
                                                  : val.toString();

                                              widget.weightPerDozen.text =
                                                  safeValue;
                                              widget.handleChangeInput(
                                                  'weight_per_dozen',
                                                  safeValue);

                                              final normalized = safeValue
                                                  .replaceAll(',', '.');
                                              final input =
                                                  double.tryParse(normalized) ??
                                                      0;

                                              calculateGsm(input);
                                              calculateBeratA(input);
                                              calculateTotalBerat(input);
                                            },
                                          ),
                                        ),
                                      ].separatedBy(CustomTheme().hGap('xl')),
                                    ),
                                  ),
                                if (widget.label == 'Packing')
                                  TemplateCard(
                                    title: 'Gramasi & Total Berat',
                                    icon: Icons.scale_outlined,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: TextForm(
                                            label: 'Gramasi (GSM)',
                                            isDisabled: true,
                                            isNumber: true,
                                            controller: widget.gsm,
                                            handleChange: (value) {
                                              setState(() {
                                                widget.gsm.text =
                                                    value.toString();
                                                widget.handleChangeInput(
                                                    'gsm', value);
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: TextForm(
                                            label: 'Berat Grade A (KG)',
                                            isDisabled: true,
                                            isNumber: true,
                                            controller: widget.weightGradeA,
                                            handleChange: (value) {
                                              setState(() {
                                                widget.weightGradeA.text =
                                                    value.toString();
                                                widget.handleChangeInput(
                                                    'weight_grade_a', value);
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: TextForm(
                                            label:
                                                'Total Berat Keseluruhan (KG)',
                                            isDisabled: true,
                                            isNumber: true,
                                            controller: widget.totalWeight,
                                            handleChange: (value) {
                                              setState(() {
                                                widget.totalWeight.text =
                                                    value.toString();
                                                widget.handleChangeInput(
                                                    'total_weight', value);
                                              });
                                            },
                                          ),
                                        ),
                                      ].separatedBy(CustomTheme().hGap('xl')),
                                    ),
                                  ),
                                if (widget.label == 'Sorting')
                                  TemplateCard(
                                    title: 'Perbaikan',
                                    icon: Icons.replay_outlined,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: TextForm(
                                            label: 'Semprotan',
                                            req: false,
                                            isNumber: true,
                                            controller: widget.spraying,
                                            handleChange: (value) {
                                              widget.handleChangeInput(
                                                  'spraying', value);
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
                                            controller:
                                                widget.reworkLongHemming,
                                            handleChange: (value) {
                                              widget.handleChangeInput(
                                                  'rework_long_hemming', value);
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
                                            controller: widget.combing,
                                            handleChange: (value) {
                                              widget.handleChangeInput(
                                                  'combing', value);
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ].separatedBy(CustomTheme().hGap('xl')),
                                    ),
                                  ),
                                if (widget.label == 'Sorting')
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [_buildMultiTipeUpdate()]
                                        .separatedBy(CustomTheme().vGap('lg')),
                                  ),
                                if (widget.label == 'Sorting')
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TemplateCard(
                                        title: 'Grade Material',
                                        icon: Icons.grade_outlined,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if ((widget.itemGradeOption ?? [])
                                                    .isNotEmpty &&
                                                _grades.isNotEmpty &&
                                                _grades.length >=
                                                    widget
                                                        .itemGradeOption.length)
                                              for (int i = 0;
                                                  i <
                                                      widget.itemGradeOption
                                                          .length;
                                                  i++)
                                                _buildGradeCard(i),
                                          ].separatedBy(
                                              CustomTheme().vGap('2xl')),
                                        ),
                                      ),
                                    ].separatedBy(CustomTheme().vGap('lg')),
                                  ),
                                if (widget.label == 'Sorting')
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                      padding:
                                                          EdgeInsets.all(12),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade300),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Grade A',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          SizedBox(height: 4),
                                                          Text(
                                                            '${_grades[0]['qty'] ?? '0'}',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black87),
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
                                                      padding:
                                                          EdgeInsets.all(12),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade300),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Grade B',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          SizedBox(height: 4),
                                                          Text(
                                                            '${_grades[1]['qty'] ?? '0'}',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black87),
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
                                                      padding:
                                                          EdgeInsets.all(12),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade300),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Tipe BS (BS-an)',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          SizedBox(height: 4),
                                                          Text(
                                                            '${_grades[2]['qty'] ?? '0'}',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black87),
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
                                                      padding:
                                                          EdgeInsets.all(12),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade300),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Perbaikan',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          SizedBox(height: 4),
                                                          Text(
                                                            '${_calculateTotalVermak()}',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black87),
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
                                                      padding:
                                                          EdgeInsets.all(12),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.grey.shade50,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade200),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Hasil Sortir',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          SizedBox(height: 4),
                                                          Text(
                                                            '${_calculateTotalQtySorting()}',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ].separatedBy(CustomTheme().vGap('lg')),
                                  ),
                              ].separatedBy(CustomTheme().vGap('xl'))),
                        )),
                        DetailWorkOrder(
                          data: widget.woData,
                          form: widget.form,
                          withQtyAndWeight: widget.withQtyAndWeight,
                          label: widget.label,
                          forDyeing: widget.forDyeing,
                          withNote: true,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                color: Colors.white,
                padding: CustomTheme().padding('content'),
                child: ValueListenableBuilder<bool>(
                  valueListenable: widget.isSubmitting,
                  builder: (context, isSubmitting, _) {
                    return Row(
                      children: [
                        Expanded(
                          child: CancelButton(
                            label: 'Batal',
                            onPressed: () => _handleCancel(context),
                            customHeight: 56.0,
                            fontSize: CustomTheme().fontSize('xl'),
                          ),
                        ),
                        Expanded(
                            child: FormButton(
                          label: 'Simpan',
                          onPressed: () {
                            _handleSubmit(context);
                          },
                          customHeight: 56.0,
                          fontSize: CustomTheme().fontSize('xl'),
                        ))
                      ].separatedBy(CustomTheme().hGap('xl')),
                    );
                  },
                ),
              ),
            ),
          )),
    );
  }

  Widget _buildMultiMesinUpdate() {
    final machines = List<Map<String, dynamic>>.from(
      widget.data['machines'] ?? [],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GroupForm(
          label: 'Mesin',
          req: false,
          formControl: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: machines
                      .map((machine) {
                        final machineData = machine['machine'];
                        final status = machine['status'] ??
                            widget.getMachineStatus(machine['machine']['id']);

                        return Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      machineData == null
                                          ? (machine['name'] ?? '-')
                                          : (machineData['code'] == null
                                              ? (machineData['name'] ?? '-')
                                              : '${machineData['code']} - ${machineData['name'] ?? '-'}'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    // if (machines.length > 1)
                                    //   GestureDetector(
                                    //     onTap: () {
                                    //       final isSubmitting =
                                    //           ValueNotifier<bool>(false);

                                    //       showConfirmationDialog(
                                    //         context: context,
                                    //         title: 'Hapus Mesin',
                                    //         message:
                                    //             'Anda yakin ingin menghapus ${machine['machine']['name'] ?? '-'}?',
                                    //         isLoading: isSubmitting,
                                    //         buttonBackground: CustomTheme()
                                    //             .buttonColor('danger'),
                                    //         onConfirm: () {
                                    //           setState(() {
                                    //             final updated = List<
                                    //                 Map<String,
                                    //                     dynamic>>.from(machines)
                                    //               ..removeWhere((m) =>
                                    //                   m['machine']['id'] ==
                                    //                   machine['machine']['id']);

                                    //             widget.data['machines'] =
                                    //                 updated;
                                    //             widget.form['machines'] =
                                    //                 updated;
                                    //           });
                                    //           Navigator.pop(context);
                                    //           isSubmitting.value = false;
                                    //         },
                                    //       );
                                    //     },
                                    //     child: Icon(Icons.close,
                                    //         color: Colors.red, size: 24),
                                    //   ),
                                  ].separatedBy(CustomTheme().hGap('lg'))),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      final isSubmitting =
                                          ValueNotifier<bool>(false);

                                      showConfirmationDialog(
                                        context: context,
                                        title: 'Selesaikan Mesin',
                                        message:
                                            'Anda yakin ingin mengubah ${machine['machine']['name'] ?? '-'} menjadi selesai?',
                                        isLoading: isSubmitting,
                                        buttonBackground: CustomTheme()
                                            .buttonColor('primary'),
                                        onConfirm: () async {
                                          try {
                                            await context
                                                .read<MachineMasterService>()
                                                .updateStatus(
                                                  machine['machine']['id']
                                                      .toString(),
                                                  'Selesai',
                                                  isSubmitting,
                                                );

                                            /// 🔥 UPDATE STATE LOKAL (INI YANG PENTING)
                                            setState(() {
                                              machine['status'] = 'Selesai';
                                            });

                                            Navigator.pop(context);
                                          } catch (e) {
                                            Navigator.pop(context);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content:
                                                    Text('Gagal update status'),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                    child: CustomBadge(
                                      status: status == 'Selesai'
                                          ? 'Selesai'
                                          : status == 'Tersedia'
                                              ? 'Menunggu Diproses'
                                              : 'Diproses',
                                      title: status,
                                      rework: true,
                                    ),
                                  ),
                                ].separatedBy(CustomTheme().hGap('lg')),
                              ),
                            ].separatedBy(CustomTheme().vGap('md')),
                          ),
                        );
                      })
                      .toList()
                      .separatedBy(CustomTheme().hGap('lg')),
                ),
              ),

              // TAMBAH
              GestureDetector(
                onTap: () async {
                  final newMachine = await widget.handleSelectMachine();
                  if (newMachine == null) return;

                  setState(() {
                    final current = List<Map<String, dynamic>>.from(
                      widget.data['machines'] ?? [],
                    );

                    final exists = current
                        .any((m) => m['machine']['id'] == newMachine['id']);

                    if (!exists) {
                      final newItem = {
                        'machine': newMachine,
                        'status': 'Tersedia',
                      };

                      current.add(newItem);

                      // 👉 simpan khusus untuk API
                      _newMachines.add(newItem);
                    }

                    widget.data['machines'] = current;
                    widget.form['machines'] = current;
                  });
                },
                child: Container(
                  height: 48,
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text('+ Tambah Mesin'),
                  ),
                ),
              ),
            ].separatedBy(CustomTheme().vGap('lg')),
          ),
        ),
      ],
    );
  }

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
                if (_defects.isNotEmpty)
                  ..._defects.asMap().entries.map((entry) {
                    int i = entry.key;
                    var defect = entry.value;

                    _ensureDefectController(i);

                    final defectQty =
                        int.tryParse(defect['qty']?.toString() ?? '0') ?? 0;
                    // final hasQty = defectQty > 0;

                    return Container(
                      margin: EdgeInsets.only(right: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                (getDefectLabel(i)),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _showDefectQtyDialog(i),
                                    child: Icon(Icons.edit,
                                        color: Colors.blue, size: 24),
                                  ),
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
                                            _defects.removeAt(i);
                                            if (i < widget.defectQty.length) {
                                              widget.defectQty[i].dispose();
                                              widget.defectQty.removeAt(i);
                                            }
                                            widget.form['defects'] = _defects;
                                            _recalculateGradeBS();
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                    child: Icon(Icons.close,
                                        color: Colors.red, size: 24),
                                  ),
                                ].separatedBy(CustomTheme().hGap('md')),
                              )
                            ].separatedBy(CustomTheme().hGap('xl')),
                          ),
                          CustomBadge(
                            title: 'Qty: $defectQty',
                            rework: true,
                            status: 'Selesai',
                          ),
                        ].separatedBy(CustomTheme().vGap('lg')),
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
              maxHeight: MediaQuery.of(context).size.height * 0.5),
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
                                final exists = _defects.firstWhere(
                                  (d) =>
                                      d['defect_type_id'].toString() ==
                                      option['id'].toString(),
                                  orElse: () => {},
                                );

                                if (exists.isEmpty) {
                                  setState(() {
                                    _defects.add({
                                      'defect_type_id': option['id'],
                                      'qty': '0',
                                    });
                                    widget.defectQty.add(
                                      TextEditingController(text: '0'),
                                    );
                                    widget.form['defects'] = _defects;
                                  });
                                }

                                Navigator.pop(context);
                                _showDefectQtyDialog(_defects.length - 1);
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.only(
              //       bottomLeft: Radius.circular(12),
              //       bottomRight: Radius.circular(12),
              //     ),
              //     border: Border(
              //       top: BorderSide(color: Colors.grey.shade200),
              //     ),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       TextButton(
              //         onPressed: () => Navigator.pop(context),
              //         child: Text(
              //           'Tutup',
              //           style: TextStyle(
              //             color: CustomTheme().buttonColor('primary'),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
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
      text: _defects[index]['qty']?.toString() ?? '0',
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
                          controller: controller,
                          handleChange: (value) {},
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
                              _defects[index]['qty'] = controller.text;
                              widget.defectQty[index].text = controller.text;
                              widget.form['defects'] = _defects;
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
Grades
*/
  Widget _buildGradeCard(int i) {
    final gradeLabel = getGradeLabel(i);
    final items = widget.data?['work_orders']?['items'] ?? [];

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
              isGrade: true,
              isDisabled: i == 2 ? true : false,
              isNumber: true,
              controller: widget.qty[i],
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
Qty Sorting
*/
  Widget _buildSortingQty() {
    final gradesList =
        widget.woData['processes'][10]['data'][0]['grades'] ?? [];

    double getTotalAdditionalProcess() {
      final data = widget.woData['processes']?[10]?['data']?[0];

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Perbaikan',
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
                '${formatNumber(grandTotal.toStringAsFixed(0))} ${gradesList.isNotEmpty ? gradesList[0]['unit_code']?.toString() ?? '' : ''}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: CustomTheme().fontWeight('bold'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
              : gradeLabel == 'B'
                  ? widget.finishedItemGrb[0]['code']
                  : '-',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Text(
          item != null && item['item_name'] != null
              ? item['item_name'].toString()
              : gradeLabel == 'B'
                  ? widget.finishedItemGrb[0]['label']
                  : '-',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
