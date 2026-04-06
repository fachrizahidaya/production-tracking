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
      this.weightPerDozen});

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
  double totalBerat = 0;

  @override
  void initState() {
    super.initState();

    _isMaklon = widget.data['maklon'] ?? false;

    // Initialize grades and defects from widget data
    _grades = (widget.grades ?? [])
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();
    _defects = (widget.defects ?? [])
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();

    // Sync with options after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncGradesWithOptions();
      _syncDefectsWithOptions();
    });
  }

  void _syncGradesWithOptions() {
    final List<Map<String, dynamic>> updated = [];

    for (var grade in widget.itemGradeOption) {
      final existing = _grades.firstWhere(
        (g) => g['item_grade_id'].toString() == grade['id'].toString(),
        orElse: () => {},
      );

      updated.add({
        'item_grade_id': grade['id'],
        'unit_id': existing['unit_id'] ?? 1,
        'qty': existing['qty'] ?? '0', // ✅ KEEP EXISTING
        'notes': existing['notes'] ?? '',
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
    // Sum all defect quantities
    final totalBs = _defects.fold<int>(
      0,
      (int sum, defect) {
        final qty = int.tryParse(defect['qty']?.toString() ?? '0') ?? 0;
        return sum + qty;
      },
    );

    // Find Grade BS (item_grade_id = 3) in grades and update
    final grades = List<Map<String, dynamic>>.from(_grades);
    final index =
        grades.indexWhere((g) => g['item_grade_id'].toString() == '3');

    if (index != -1) {
      grades[index]['qty'] = totalBs;
      _grades = grades;
      widget.form['grades'] = _grades;

      // Update the corresponding qty controller
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
    final grades = double.tryParse(widget.form['qty']?.toString() ?? '0') ??
        0.0; // Default to 100 if no grades available

    return grades;
  }

  void calculateFromBeratLusin(double value) {
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
              widget.form['machine_ids'] = machines
                  .map((e) => e['id'])
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
    return GestureDetector(
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
            child: SingleChildScrollView(
                child: Container(
              padding: CustomTheme().padding('content'),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_isMaklon &&
                        widget.label != 'Sorting' &&
                        widget.label != 'Packing')
                      TemplateCard(
                        title: 'Mesin',
                        icon: Icons.local_laundry_service_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.label == 'Long Hemming' ||
                                widget.label == 'Cross Cutting' ||
                                widget.label == 'Sewing')
                              _buildMultiMesinUpdate()
                            else
                              SelectForm(
                                label: 'Mesin',
                                onTap: () => widget.handleSelectMachine(),
                                selectedLabel: widget.form['nama_mesin'] ?? '',
                                selectedValue:
                                    widget.form['machine_id'].toString(),
                                required: false,
                              ),
                          ].separatedBy(CustomTheme().vGap('lg')),
                        ),
                      ),
                    if (widget.data['maklon'] != null)
                      TemplateCard(
                        title: 'Maklon',
                        icon: Icons.business_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (widget.withMaklon == true)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Maklon',
                                            style: TextStyle(
                                                fontSize: CustomTheme()
                                                    .fontSize('lg')),
                                          ),
                                          Row(
                                            children: [
                                              Switch(
                                                value: _isMaklon,
                                                onChanged: widget
                                                        .data['can_update']
                                                    ? (value) {
                                                        setState(() {
                                                          _isMaklon = value;
                                                          widget.form[
                                                              'maklon'] = value;
                                                        });
                                                      }
                                                    : null,
                                                activeColor: Colors.green,
                                                inactiveThumbColor:
                                                    Colors.redAccent,
                                              ),
                                              Text(widget.data['maklon']
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
                                            widget.form['maklon_name'] =
                                                value.toString();
                                          });
                                        },
                                      ),
                                  ].separatedBy(CustomTheme().vGap('lg')),
                                ),
                              ].separatedBy(CustomTheme().vGap('lg')),
                            ),
                          ].separatedBy(CustomTheme().vGap('lg')),
                        ),
                      ),
                    if (widget.label == 'Long Hemming')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TemplateCard(
                            title: 'Berat',
                            icon: Icons.grade_outlined,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextForm(
                                  label: 'Berat Bagus',
                                  req: false,
                                  isNumber: true,
                                  controller: widget.goodWeight,
                                  handleChange: (value) {
                                    widget.handleChangeInput(
                                        'good_weight', value);
                                  },
                                ),
                                TextForm(
                                  label: 'Berat BS',
                                  req: false,
                                  isNumber: true,
                                  controller: widget.defectWeight,
                                  handleChange: (value) {
                                    widget.handleChangeInput(
                                        'bs_weight', value);
                                  },
                                ),
                              ].separatedBy(CustomTheme().vGap('lg')),
                            ),
                          ),
                        ].separatedBy(CustomTheme().vGap('lg')),
                      ),
                    if (widget.label == 'Cross Cutting' ||
                        widget.label == 'Sewing')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TemplateCard(
                            title: 'Qty',
                            icon: Icons.grade_outlined,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextForm(
                                  label: 'Qty',
                                  req: false,
                                  isNumber: true,
                                  controller: widget.cuttingSewingQty,
                                  handleChange: (value) {
                                    widget.handleChangeInput('item_qty', value);
                                  },
                                ),
                              ].separatedBy(CustomTheme().vGap('lg')),
                            ),
                          ),
                        ].separatedBy(CustomTheme().vGap('lg')),
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
                                  isNumber: true,
                                  controller: widget.packingQty,
                                  handleChange: (value) {
                                    final safeValue =
                                        (value == null || value.trim().isEmpty)
                                            ? '0'
                                            : value;

                                    widget.packingQty.text = safeValue;
                                    widget.handleChangeInput('qty', safeValue);

                                    setState(() {
                                      final input = double.tryParse(widget
                                              .weightPerDozen.text
                                              .toString()) ??
                                          0;
                                      if (input > 0) {
                                        calculateFromBeratLusin(input);
                                      }
                                    });
                                  },
                                ),
                              ].separatedBy(CustomTheme().vGap('lg')),
                            ),
                          ),
                        ].separatedBy(CustomTheme().vGap('lg')),
                      ),
                    if (widget.label == 'Packing')
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
                                controller: widget.weightPerDozen,
                                handleChange: (val) {
                                  final safeValue = (val == null ||
                                          val.toString().trim().isEmpty)
                                      ? '0'
                                      : val.toString();

                                  widget.weightPerDozen.text = safeValue;
                                  widget.handleChangeInput(
                                      'weight_per_dozen', safeValue);

                                  final normalized =
                                      safeValue.replaceAll(',', '.');
                                  final input =
                                      double.tryParse(normalized) ?? 0;

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
                                    widget.handleChangeInput(
                                        'total_weight', value);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (widget.label == 'Sorting')
                      TemplateCard(
                        title: 'Perbaikan Long Hemming',
                        icon: Icons.grade_outlined,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextForm(
                                label: 'Vermak Long Hemming',
                                req: false,
                                isNumber: true,
                                controller: widget.reworkLongHemming,
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
                                  widget.handleChangeInput('combing', value);
                                  setState(() {});
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextForm(
                                label: 'Semprotan',
                                req: false,
                                isNumber: true,
                                controller: widget.spraying,
                                handleChange: (value) {
                                  widget.handleChangeInput('spraying', value);
                                  setState(() {});
                                },
                              ),
                            ),
                          ].separatedBy(CustomTheme().hGap('xl')),
                        ),
                      ),
                    if (widget.label == 'Sorting')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [_buildMultiTipeUpdate()]
                            .separatedBy(CustomTheme().vGap('lg')),
                      ),
                    if (widget.label == 'Sorting')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TemplateCard(
                            title: 'Grade Material',
                            icon: Icons.grade_outlined,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if ((widget.itemGradeOption ?? []).isNotEmpty &&
                                    _grades.isNotEmpty &&
                                    _grades.length >=
                                        widget.itemGradeOption.length)
                                  for (int i = 0;
                                      i < widget.itemGradeOption.length;
                                      i++)
                                    _buildGradeCard(i),
                              ].separatedBy(CustomTheme().vGap('2xl')),
                            ),
                          ),
                        ].separatedBy(CustomTheme().vGap('lg')),
                      ),
                    if (widget.label == 'Sorting')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TemplateCard(
                            title: 'Ringkasan Sorting',
                            icon: Icons.summarize_outlined,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total Perbaikan Long Hemming:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            '${_calculateTotalVermak()}',
                                            style: TextStyle(
                                                fontSize: CustomTheme()
                                                    .fontSize('lg'),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total Qty Sorting:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                                  CustomTheme().fontSize('lg'),
                                            ),
                                          ),
                                          Text(
                                            '${_calculateTotalQtySorting()}',
                                            style: TextStyle(
                                              fontSize:
                                                  CustomTheme().fontSize('2xl'),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ].separatedBy(SizedBox(height: 8)),
                                  ),
                                ),
                              ].separatedBy(CustomTheme().vGap('lg')),
                            ),
                          ),
                        ].separatedBy(CustomTheme().vGap('lg')),
                      ),
                    DetailWorkOrder(
                      data: widget.data['work_orders'],
                      form: widget.form,
                      withQtyAndWeight: widget.withQtyAndWeight,
                      label: widget.label,
                      forDyeing: widget.forDyeing,
                      withNote: true,
                    )
                  ].separatedBy(CustomTheme().vGap('xl'))),
            )),
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
        ));
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
              // LIST MESIN (HORIZONTAL)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: machines.map((machine) {
                    return Container(
                      margin: EdgeInsets.only(right: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${machine['code'] != null ? machine['code'] : ''} ${machine['code'] != null ? '-' : ''} ${machine['name'] ?? '-'}',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 8),

                                /// STATUS
                                CustomBadge(
                                  status:
                                      widget.getMachineStatus(machine['id']) ==
                                              'Tersedia'
                                          ? 'Selesai'
                                          : 'Diproses',
                                  title:
                                      widget.getMachineStatus(machine['id']) ==
                                              'Tersedia'
                                          ? 'Selesai'
                                          : 'Sedang Digunakan',
                                ),
                              ].separatedBy(CustomTheme().vGap('md'))),

                          /// LABEL
                          Row(
                            children: [
                              /// ACTION DONE
                              if (widget.getMachineStatus(machine['id']) !=
                                  'Tersedia')
                                GestureDetector(
                                  onTap: () {
                                    final isSubmitting =
                                        ValueNotifier<bool>(false);

                                    showConfirmationDialog(
                                      context: context,
                                      title: 'Selesaikan Mesin',
                                      message:
                                          'Yakin ingin menandai ${machine['name'] ?? '-'} sebagai selesai?',
                                      isLoading: isSubmitting,
                                      buttonBackground:
                                          CustomTheme().buttonColor('primary'),
                                      onConfirm: () async {
                                        try {
                                          /// 🔥 CALL API
                                          await context
                                              .read<MachineMasterService>()
                                              .updateStatus(
                                                machine['id'].toString(),
                                                'Tersedia',
                                                isSubmitting,
                                              );

                                          /// 🔥 REFETCH
                                          await widget.handleFetchMachine();

                                          setState(() {
                                            widget.form['machines'] = List.from(
                                                widget.data['machines']);
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
                                  child: Icon(Icons.task_alt_outlined,
                                      color: Colors.green, size: 20),
                                )
                              else
                                GestureDetector(
                                  onTap: () {
                                    final isSubmitting =
                                        ValueNotifier<bool>(false);

                                    showConfirmationDialog(
                                      context: context,
                                      title: 'Gunakan Mesin',
                                      message:
                                          'Yakin ingin menandai ${machine['name'] ?? '-'} sebagai digunakan?',
                                      isLoading: isSubmitting,
                                      buttonBackground:
                                          CustomTheme().buttonColor('primary'),
                                      onConfirm: () async {
                                        try {
                                          /// 🔥 CALL API
                                          await context
                                              .read<MachineMasterService>()
                                              .updateStatus(
                                                machine['id'].toString(),
                                                'Sedang Digunakan',
                                                isSubmitting,
                                              );

                                          /// 🔥 REFETCH
                                          await widget.handleFetchMachine();

                                          setState(() {
                                            widget.form['machines'] = List.from(
                                                widget.data['machines']);
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
                                  child: Icon(Icons.access_time_outlined,
                                      color: Colors.grey, size: 20),
                                ),

                              /// DELETE
                              GestureDetector(
                                onTap: () {
                                  final isSubmitting =
                                      ValueNotifier<bool>(false);

                                  showConfirmationDialog(
                                    context: context,
                                    title: 'Hapus Mesin',
                                    message:
                                        'Yakin ingin menghapus ${machine['name'] ?? '-'}?',
                                    isLoading: isSubmitting,
                                    buttonBackground:
                                        CustomTheme().buttonColor('danger'),
                                    onConfirm: () {
                                      setState(() {
                                        final updated =
                                            List<Map<String, dynamic>>.from(
                                                machines)
                                              ..removeWhere((m) =>
                                                  m['id'] == machine['id']);

                                        widget.data['machines'] = updated;
                                        widget.form['machines'] = updated;
                                      });
                                      Navigator.pop(context);
                                      isSubmitting.value = false;
                                    },
                                  );
                                },
                                child: Icon(Icons.close,
                                    color: Colors.red, size: 20),
                              ),
                            ].separatedBy(CustomTheme().hGap('lg')),
                          ),
                        ].separatedBy(CustomTheme().hGap('xl')),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // BUTTON TAMBAH
              GestureDetector(
                onTap: () async {
                  final newMachine = await widget.handleSelectMachine();
                  if (newMachine == null) return;

                  setState(() {
                    final current = List<Map<String, dynamic>>.from(
                      widget.data['machines'] ?? [],
                    );

                    final exists =
                        current.any((m) => m['id'] == newMachine['id']);
                    if (!exists) {
                      current.add({
                        ...newMachine,
                        'status':
                            'Sedang Digunakan', // ✅ default langsung dipakai
                      });
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
            ],
          ),
        ),
      ].separatedBy(SizedBox(height: 12)),
    );
  }

  Widget _buildMultiTipeUpdate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TemplateCard(
          title: 'Tipe BS',
          icon: Icons.grade_outlined,
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
                        final hasQty = defectQty > 0;

                        return Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getDefectLabel(i),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: CustomTheme().fontSize('lg')),
                                  ),
                                  SizedBox(height: 4),
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
                                          'Yakin ingin menghapus ${getDefectLabel(i)}?',
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
                                      color: Colors.red, size: 18),
                                ),
                            ].separatedBy(SizedBox(width: 4)),
                          ),
                        );
                      }).toList(),
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
                    child: Text('+ Tambah'),
                  ),
                ),
              ),
            ].separatedBy(CustomTheme().vGap('xl')),
          ),
        ),
      ],
    );
  }

  /// 🔹 DIALOG TO SELECT DEFECT TYPE
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

  /// 🔹 DIALOG TO INPUT QTY
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
                          _defects[index]['qty'] = controller.text;
                          widget.defectQty[index].text = controller.text;
                          widget.form['defects'] = _defects;
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

  Widget _buildGradeCard(int i) {
    final gradeLabel = getGradeLabel(i);
    final items = widget.data?['work_orders']?['items'] ?? [];

    _ensureController(i);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Grade $gradeLabel',
          style: TextStyle(
              fontSize: 16, fontWeight: CustomTheme().fontWeight('semibold')),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: TextForm(
                label: 'Qty (PCS)',
                req: true,
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

                  // ✅ Update internal _grades state
                  setState(() {
                    _grades[i]['qty'] = safeValue;
                  });

                  widget.handleUpdateGrade(i, 'qty', safeValue);
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
            //     label: 'Catatan',
            //     req: false,
            //     handleChange: (val) {
            //       // ✅ Update internal _grades state
            //       setState(() {
            //         _grades[i]['notes'] = val ?? '';
            //       });

            //       widget.handleUpdateGrade(i, 'notes', val);
            //     },
            //   ),
            // ),
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
      ].separatedBy(CustomTheme().vGap('lg')),
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
                flex: 2,
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
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }
}
