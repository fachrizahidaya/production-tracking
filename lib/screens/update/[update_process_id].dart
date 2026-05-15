// ignore_for_file: file_names, use_build_context_synchronously, deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/process/finish/process/form_helpers.dart';
import 'package:textile_tracking/components/update/detail_work_order.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/format_idr.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/result/to_double.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/update/process/cutting_sewing.dart';
import 'package:textile_tracking/screens/update/process/long_hemming.dart';
import 'package:textile_tracking/screens/update/process/machine.dart';
import 'package:textile_tracking/screens/update/process/sorting.dart';

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
  final finishedItemGood;
  final finishedItemMaterial;

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
      this.finishedItemMaterial,
      this.finishedItemGrb,
      this.finishedItemGood});

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
        greigeItemId = widget.finishedItemGood.isNotEmpty
            ? widget.finishedItemGood[0]['value']
            : null;
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
        'name': grade['name'] ?? ''
      });
    }

    setState(() {
      _grades = updated;
    });

    widget.handleChangeInput('grades', _grades);
    _updateTotalSorting();
  }

  void _syncDefectsWithOptions() {
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
    _updateTotalSorting();
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

  void _recalculateGradeBS() {
    final totalBs = _defects.fold<int>(
      0,
      (int sum, defect) {
        final qty = int.tryParse(
                (defect['qty']?.toString() ?? '0').replaceAll(',', '')) ??
            0;
        return sum + qty;
      },
    );

    final grades = List<Map<String, dynamic>>.from(_grades);
    final index = grades.indexWhere((g) => g['name'].toString() == 'BS');

    if (index != -1) {
      grades[index]['qty'] = totalBs;
      _grades = grades;
      widget.form['grades'] = _grades;

      if (index < widget.qty.length) {
        widget.qty[index].text = totalBs.toString();
      }

      // ✅ UPDATE TOTAL SORTING
      _updateTotalSorting();
    }
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

  void _updateTotalSorting() {
    final total = _calculateTotalQtySorting();
    widget.handleChangeInput('total_sorting', formatIdr(total));
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

    for (var grade in gradesList) {
      final qty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
      totalQty += qty;
    }

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

  String formatId(num value) {
    final formatter = NumberFormat('#,##0.00', 'id_ID');
    return formatter.format(value);
  }

  double parseId(String value) {
    return double.tryParse(
          value.replaceAll('.', '').replaceAll(',', '.'),
        ) ??
        0;
  }

  String toApi(num value) {
    return value.toString();
  }

  void calculateBeratA() {
    final packing = double.tryParse(
          widget.packingQty.text.replaceAll('.', '').replaceAll(',', '.'),
        ) ??
        0;

    final beratLusin = double.tryParse(
          widget.weightPerDozen.text.replaceAll('.', '').replaceAll(',', '.'),
        ) ??
        0;

    if (packing <= 0 || beratLusin <= 0) {
      widget.weightGradeA.text = '0';
      return;
    }

    final result = (packing / 12) * beratLusin;

    widget.weightGradeA.text = formatId(result);

    widget.handleChangeInput(
      'weight_grade_a',
      toApi(result),
    );
  }

  void calculateTotalBerat() {
    final maxQty = getMaxTotalQty();

    final beratLusin = parseId(widget.weightPerDozen.text);

    final total =
        (maxQty == 0 || beratLusin == 0) ? 0 : (beratLusin / 12) * maxQty;

    setState(() {
      widget.totalWeight.text = formatId(total);

      widget.handleChangeInput(
        'total_weight',
        toApi(total),
      );
    });
  }

  double parseSafe(dynamic value) {
    if (value == null) return 0;

    final clean = value.toString().replaceAll('.', '').replaceAll(',', '.');

    return double.tryParse(clean) ?? 0;
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
            if (widget.label == 'Long Hemming' ||
                widget.label == 'Cross Cutting' ||
                widget.label == 'Sewing') {
              final machines = List<Map<String, dynamic>>.from(
                widget.data['machines'] ?? [],
              );

              widget.form['machines'] = machines;
              widget.form['machine_ids'] = _newMachines
                  .map((e) => e['machine']['id'])
                  .where((id) => id != null)
                  .toList();

              widget.form['machine_id'] = null;
              widget.form['nama_mesin'] = null;
              widget.form['maklon'] = false;
              widget.form['maklon_name'] = null;
            }

            if (widget.label == 'Sorting') {
              widget.form['spraying'] = toDouble(widget.form['spraying']);
              widget.form['rework_long_hemming'] =
                  toDouble(widget.form['rework_long_hemming']);
              widget.form['combing'] = toDouble(widget.form['combing']);

              widget.form['grades'] = (_grades).map((e) {
                return {
                  ...e,
                  'qty': toDouble(e['qty']),
                };
              }).toList();
            }

            if (widget.label == 'Long Hemming' ||
                widget.label == 'Sewing' ||
                widget.label == 'Packing') {
              widget.form['greige_item_id'] =
                  (widget.finishedItemMaterial[0]['value']);
            }

            /// 🔥 MAKLON
            else if (_isMaklon == true) {
              widget.form['machines'] = [];
              widget.form['machine_id'] = null;
              widget.form['nama_mesin'] = null;
              widget.form['maklon'] = true;
            }

            /// 🔥 SINGLE MACHINE
            else {
              widget.form['machines'] = [];
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

  bool _isDataEmpty() {
    if (_grades.isEmpty) return true;

    return false;
  }

  bool _isItemEmpty() {
    if (widget.finishedItemMaterial[0]['code'] == null) return true;

    return false;
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
                                // if ((widget.label == 'Long Hemming' ||
                                //         widget.label == 'Sewing' ||
                                //         widget.label == 'Packing') &&
                                //     _isItemEmpty())
                                //   FormHelpers.buildEmptyState(true),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TemplateCard(
                                          title: 'No. Proses',
                                          icon: Icons.description_outlined,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 16,
                                                  horizontal: 12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade200),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        widget.data != null
                                                            ? widget.label ==
                                                                    'Dyeing'
                                                                ? '${widget.data['dyeing_no']}'
                                                                : widget.label ==
                                                                        'Press'
                                                                    ? '${widget.data['press_no']}'
                                                                    : widget.label ==
                                                                            'Tumbler'
                                                                        ? '${widget.data['tumbler_no']}'
                                                                        : widget.label ==
                                                                                'Stenter'
                                                                            ? '${widget.data['stenter_no']}'
                                                                            : widget.label == 'Long Slitting'
                                                                                ? '${widget.data['ls_no']}'
                                                                                : widget.label == 'Long Hemming'
                                                                                    ? '${widget.data['lh_no']}'
                                                                                    : widget.label == 'Cross Cutting'
                                                                                        ? '${widget.data['cc_no']}'
                                                                                        : widget.label == 'Sewing'
                                                                                            ? '${widget.data['sewing_no']}'
                                                                                            : widget.label == 'Sorting'
                                                                                                ? '${widget.data['sorting_no']}'
                                                                                                : '${widget.data['packing_no']}'
                                                            : '-',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ].separatedBy(
                                                CustomTheme().vGap('lg')),
                                          )),
                                    ),
                                    if (widget.label == 'Long Hemming' ||
                                        widget.label == 'Sewing' ||
                                        widget.label == 'Packing')
                                      Expanded(
                                        child: TemplateCard(
                                            title: widget.label == 'Packing'
                                                ? 'Produk Jadi'
                                                : 'Produk Setengah Jadi',
                                            icon: Icons.inventory_2_outlined,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 16,
                                                    horizontal: 12,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade200),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              widget.finishedItemMaterial[
                                                                          0]?[
                                                                      'code'] ??
                                                                  '-',
                                                              style: TextStyle(
                                                                  fontWeight: CustomTheme()
                                                                      .fontWeight(
                                                                          'semibold')),
                                                            ),
                                                            Text(
                                                              widget.finishedItemMaterial[
                                                                          0]?[
                                                                      'label'] ??
                                                                  '-',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ].separatedBy(
                                                  CustomTheme().vGap('lg')),
                                            )),
                                      ),
                                  ].separatedBy(CustomTheme().hGap('xl')),
                                ),
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
                                          MachineEditSection(
                                            data: widget.data,
                                            form: widget.form,
                                            getMachineStatus:
                                                widget.getMachineStatus,
                                            handleSelectMachine:
                                                widget.handleSelectMachine,
                                            newMachines: _newMachines,
                                          )
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
                                  LongHemmingWeightSection(
                                    form: widget.form,
                                    goodWeightController: widget.goodWeight,
                                    defectWeightController: widget.defectWeight,
                                    onChange: widget.handleChangeInput,
                                    onRecalculate: calculateLongHemmingWeight,
                                  ),
                                if (widget.label == 'Cross Cutting' ||
                                    widget.label == 'Sewing')
                                  CuttingSewingQtySection(
                                    label: widget.label,
                                    form: widget.form,
                                    controller: widget.cuttingSewingQty,
                                    onChange: widget.handleChangeInput,
                                  ),
                                if (widget.label == 'Sorting' && _isDataEmpty())
                                  FormHelpers.buildEmptyState(true)
                                // else if ((widget.label == 'Long Hemming' ||
                                //         widget.label == 'Sewing' ||
                                //         widget.label == 'Packing') &&
                                //     _isItemEmpty())
                                //   FormHelpers.buildEmptyState(true)
                                else ...[
                                  if (widget.label == 'Sorting')
                                    SortingEditSection(
                                      form: widget.form,
                                      grades: _grades,
                                      itemGradeOption: widget.itemGradeOption,
                                      spraying: widget.spraying,
                                      reworkLongHemming:
                                          widget.reworkLongHemming,
                                      combing: widget.combing,
                                      onChange: widget.handleChangeInput,
                                      updateTotalSorting: _updateTotalSorting,
                                      calculateTotalVermak:
                                          _calculateTotalVermak,
                                      calculateTotalQtySorting:
                                          _calculateTotalQtySorting,
                                      defectArray: _defects,
                                      defects: widget.defects,
                                      itemTypeOption: widget.itemTypeOption,
                                      finishedItemGood: widget.finishedItemGood,
                                      finishedItemGrb: widget.finishedItemGrb,
                                      data: widget.data,
                                      defectQty: widget.defectQty,
                                      gradeArray: _grades,
                                      handleUpdateGrade:
                                          widget.handleUpdateGrade,
                                      qty: widget.qty,
                                      recalculateGradeBS: _recalculateGradeBS,
                                    ),
                                ],
                                if (widget.label == 'Packing')
                                  Column(
                                    children: [
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
                                                    children: [
                                                      _buildSortingQty()
                                                    ],
                                                  ),
                                                ),
                                              ].separatedBy(
                                                  CustomTheme().hGap('xl')),
                                            ),
                                          ].separatedBy(
                                              CustomTheme().vGap('lg')),
                                        ),
                                      ),
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
                                                isSorting: true,
                                                initialValue: widget.form['qty']
                                                        ?.toString() ??
                                                    '0',
                                                controller: widget.packingQty,
                                                handleChange: (value) {
                                                  final safeValue = (value
                                                          .toString()
                                                          .trim()
                                                          .isEmpty)
                                                      ? '0'
                                                      : value.toString();

                                                  widget.handleChangeInput(
                                                      'qty', safeValue);

                                                  setState(() {
                                                    final input =
                                                        double.tryParse(
                                                              widget
                                                                  .weightPerDozen
                                                                  .text
                                                                  .replaceAll(
                                                                      '.', '')
                                                                  .replaceAll(
                                                                      ',', '.'),
                                                            ) ??
                                                            0;
                                                    if (input > 0) {
                                                      calculateBeratA();
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
                                                isSorting: true,
                                                isNumber: true,
                                                initialValue: widget.form[
                                                            'weight_per_dozen']
                                                        ?.toString() ??
                                                    '0',
                                                controller:
                                                    widget.weightPerDozen,
                                                handleChange: (val) {
                                                  final safeValue = (val
                                                          .toString()
                                                          .trim()
                                                          .isEmpty)
                                                      ? '0'
                                                      : val.toString();

                                                  widget.handleChangeInput(
                                                      'weight_per_dozen',
                                                      safeValue);

                                                  setState(() {
                                                    calculateGsm(
                                                      double.tryParse(
                                                            widget
                                                                .weightPerDozen
                                                                .text
                                                                .replaceAll(
                                                                    '.', '')
                                                                .replaceAll(
                                                                    ',', '.'),
                                                          ) ??
                                                          0,
                                                    );

                                                    calculateBeratA();
                                                    calculateTotalBerat();
                                                  });
                                                },
                                              ),
                                            ),
                                          ].separatedBy(
                                              CustomTheme().hGap('xl')),
                                        ),
                                      ),
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
                                                initialValue: widget.form['gsm']
                                                        ?.toString() ??
                                                    '',
                                                handleChange: (value) {
                                                  setState(() {
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
                                                initialValue: widget
                                                        .form['weight_grade_a']
                                                        ?.toString() ??
                                                    '',
                                                handleChange: (value) {
                                                  setState(() {
                                                    widget.handleChangeInput(
                                                        'weight_grade_a',
                                                        value);
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
                                                initialValue: widget
                                                        .form['total_weight']
                                                        ?.toString() ??
                                                    '',
                                                handleChange: (value) {
                                                  setState(() {
                                                    widget.handleChangeInput(
                                                        'total_weight', value);
                                                  });
                                                },
                                              ),
                                            ),
                                          ].separatedBy(
                                              CustomTheme().hGap('xl')),
                                        ),
                                      ),
                                    ].separatedBy(CustomTheme().vGap('xl')),
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Loop through grades
        ...gradesList.asMap().entries.map((entry) {
          final grade = entry.value;
          final gradeName = grade['grade']?.toString() ?? '-';
          final gradeQty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
          final gradeUnit = grade['unit_code']?.toString() ?? '';

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
                  '${formatNumber(grandTotal.toStringAsFixed(0))} ${gradesList.isNotEmpty ? gradesList[0]['unit_code']?.toString() ?? '' : ''}',
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
}
