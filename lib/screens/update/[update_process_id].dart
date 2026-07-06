// ignore_for_file: file_names, use_build_context_synchronously, deprecated_member_use, prefer_final_fields

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/packing_number_form.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
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

class _UpdateProcessState extends State<UpdateProcess>
    with AutomaticKeepAliveClientMixin {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  bool _isMaklon = false;
  late List<Map<String, dynamic>> _grades;
  late List<Map<String, dynamic>> _defects;
  double beratLusin = 0;
  double gsm = 0;
  double totalBeratA = 0;
  double totalBerat = 0;
  final Map<int, TextEditingController> _packingQtyControllers = {};
  final Map<int, TextEditingController> _weightPerDozenControllers = {};
  final Map<int, TextEditingController> _gsmControllers = {};
  final Map<int, TextEditingController> _weightGradeAControllers = {};
  final Map<int, TextEditingController> _totalWeightControllers = {};

  List<Map<String, dynamic>> _newMachines = [];

  @override
  bool get wantKeepAlive => true;

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

    final items = widget.data['items'] ?? [];

    for (final item in items) {
      final itemId = item['id'];

      _packingQtyControllers[itemId] = TextEditingController(
        text: item['qty']?.toString() ?? '0',
      );

      _weightPerDozenControllers[itemId] = TextEditingController(
        text: item['weight_per_dozen']?.toString() ?? '0',
      );

      _gsmControllers[itemId] = TextEditingController(
        text: item['gsm']?.toString() ?? '0',
      );

      _weightGradeAControllers[itemId] = TextEditingController(
        text: formatId(
          parseInput(item['weight_grade_a']),
        ),
      );

      _totalWeightControllers[itemId] = TextEditingController(
        text: '0',
      );
    }

    for (final item in items) {
      calculateGsm(item);
      calculateBeratA(item);
      calculateTotalBerat(
        item,
        widget.data,
      );
    }

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

  int customRound(double value) {
    final decimal = value - value.floor();

    if (decimal > 0.5) {
      return value.ceil();
    } else {
      return value.floor();
    }
  }

  void calculateGsm(
    Map<String, dynamic> item,
  ) {
    final itemId = item['id'];

    final size = item['finished_product']?['name'] ?? '';

    final regex = RegExp(r'(\d+)X(\d+)');

    final match = regex.firstMatch(size);

    if (match == null) return;

    final panjang = int.tryParse(match.group(1) ?? '0') ?? 0;

    final lebar = int.tryParse(match.group(2) ?? '0') ?? 0;

    final beratLusin = double.tryParse(
          item['weight_per_dozen']?.toString() ?? '0',
        ) ??
        0;

    if (panjang == 0 || lebar == 0 || beratLusin == 0) {
      _gsmControllers[itemId]?.text = '0';
      return;
    }

    final rawGsm = (beratLusin * 10000000) / (12 * 70 * 140);

    final rounded = customRound(rawGsm);

    item['gsm'] = rounded;

    _gsmControllers[itemId]?.text = formatId(rounded);
  }

  String formatId(num value) {
    final formatter = NumberFormat('#,##0.00', 'id_ID');
    return formatter.format(value);
  }

  void calculateBeratA(Map<String, dynamic> item) {
    final itemId = item['id'];

    final packing = parseInput(item['qty']);

    final beratLusin = parseInput(item['weight_per_dozen']);

    final result =
        packing <= 0 || beratLusin <= 0 ? 0 : (packing / 12) * beratLusin;

    item['weight_grade_a'] = result;

    _weightGradeAControllers[itemId]?.text = formatId(result);
  }

  void calculateTotalBerat(
    Map<String, dynamic> item,
    Map<String, dynamic> processData,
  ) {
    final itemId = item['id'];

    double totalQty = 0;

    final grades = processData['sorting']?['grades'] ?? [];

    final itemCode = item['finished_product']?['code']?.toString().trim();

    final woItemId = item['wo_item_id'];

    for (final grade in grades) {
      final gradeItems = grade['items'] ?? [];

      final matched = gradeItems.cast<Map<String, dynamic>?>().firstWhere(
        (gradeItem) {
          final gradeItemCode =
              gradeItem?['finished_product']?['code']?.toString().trim();

          return gradeItem?['wo_item_id'] == woItemId;
        },
        orElse: () => null,
      );

      if (matched != null) {
        totalQty += parseInput(matched['qty']) +
            parseInput(matched['spraying']) +
            parseInput(
              matched['rework_long_hemming'],
            ) +
            parseInput(matched['combing']);
      }
    }

    final beratLusin = parseInput(
      item['weight_per_dozen'],
    );

    final result =
        totalQty <= 0 || beratLusin <= 0 ? 0 : (totalQty / 12) * beratLusin;

    item['total_weight'] = result;

    _totalWeightControllers[itemId]?.text = formatId(result);
  }

  Map<String, dynamic> getSortingGradeQty(
    Map<String, dynamic> item,
    Map<String, dynamic> data,
  ) {
    final grades = data['sorting']?['grades'] ?? [];

    double gradeA = 0;
    double gradeB = 0;
    double gradeBS = 0;

    final itemCode = item['finished_product']?['code']?.toString().trim();
    final woItemId = item['wo_item_id'];

    for (final grade in grades) {
      final gradeCode = grade['item_grade']?['code']?.toString().trim();

      final gradeItems = grade['items'] ?? [];

      final matched = gradeItems.cast<Map<String, dynamic>?>().firstWhere(
        (gradeItem) {
          final gradeItemCode =
              gradeItem?['finished_product']?['code']?.toString().trim();

          return gradeItem?['wo_item_id'] == woItemId;
        },
        orElse: () => null,
      );

      if (matched != null) {
        final qty = parseInput(matched['qty']);

        if (gradeCode == 'A') {
          gradeA = qty;
        } else if (gradeCode == 'B') {
          gradeB = qty;
        } else if (gradeCode == 'BS') {
          gradeBS = qty;
        }
      }
    }

    return {
      'grade_a': gradeA,
      'grade_b': gradeB,
      'grade_bs': gradeBS,
    };
  }

  double parseSafe(dynamic value) {
    if (value == null) return 0;

    final clean = value.toString().replaceAll('.', '').replaceAll(',', '.');

    return double.tryParse(clean) ?? 0;
  }

  double parseInput(dynamic value) {
    if (value == null) return 0;

    if (value is num) {
      return value.toDouble();
    }

    String str = value.toString().trim();

    if (str.isEmpty) return 0;

    final ribuanRegex = RegExp(r'^\d{1,3}(\.\d{3})+$');

    if (ribuanRegex.hasMatch(str)) {
      str = str.replaceAll('.', '');
      return double.tryParse(str) ?? 0;
    }

    if (str.contains(',')) {
      str = str.replaceAll('.', '');
      str = str.replaceAll(',', '.');
    }

    return double.tryParse(str) ?? 0;
  }

  void calculateLongHemmingWeight() {
    final items = List<Map<String, dynamic>>.from(widget.form['items'] ?? []);

    double total = 0;

    for (final item in items) {
      final good = parseSafe(item['good_weight']);
      final defect = parseSafe(item['bs_weight']);

      total += good + defect;
    }

    setState(() {
      widget.handleChangeInput(
        'weight',
        total.toStringAsFixed(2),
      );

      widget.weight.value = TextEditingValue(
        text: total.toStringAsFixed(2),
        selection: TextSelection.collapsed(
          offset: total.toStringAsFixed(2).length,
        ),
      );
    });
  }

  List<Map<String, dynamic>> buildGradesPayload() {
    final items = widget.form['items'] ?? [];

    final Map<int, Map<String, dynamic>> groupedGrades = {};

    for (final item in items) {
      final grades = item['grades'] ?? [];

      for (final grade in grades) {
        final gradeId = grade['item_grade_id'];

        if (!groupedGrades.containsKey(gradeId)) {
          groupedGrades[gradeId] = {
            'item_grade_id': gradeId,
            'notes': 'Grade ${grade['name']}',
            'items': [],
          };
        }

        groupedGrades[gradeId]!['items'].add({
          'item_id': grade['item_id'],
          'semifinished_product_id': grade['semifinished_product_id'],
          'qty': grade['qty'] ?? 0,

          /// AMBIL DARI GRADE
          'spraying': grade['spraying'] ?? 0,
          'rework_long_hemming': grade['rework_long_hemming'] ?? 0,
          'combing': grade['combing'] ?? 0,

          'defects': item['defects'] ?? [],
        });
      }
    }

    return groupedGrades.values.toList();
  }

  double get totalGradeASorting {
    final grades = widget.data?['sorting']?['grades'] ??
        widget.data?['sorting']?['grades'] ??
        [];

    double total = 0;

    for (final grade in grades) {
      final code = grade['item_grade']?['code'];

      if (code == 'A') {
        total += parseInput(grade['qty']);
      }
    }

    return total;
  }

  double get totalAllSorting {
    final grades = widget.data?['sorting']?['grades'] ??
        widget.data?['sorting']?['grades'] ??
        [];

    double total = 0;

    for (final grade in grades) {
      total += parseInput(grade['qty']);
    }

    return total;
  }

  double get totalPackingInput {
    final items = widget.data?['items'] ?? widget.form['items'] ?? [];

    double total = 0;

    for (final item in items) {
      total += parseInput(item['qty']);
    }

    return total;
  }

  double get totalWeightGradeAAll {
    final items = widget.data?['items'] ?? widget.form['items'] ?? [];

    double total = 0;

    for (final item in items) {
      total += parseInput(item['weight_grade_a']);
    }

    return total;
  }

  double get totalWeightAll {
    final items = widget.data?['items'] ?? widget.form['items'] ?? [];

    double total = 0;

    for (final item in items) {
      total += parseInput(item['total_weight']);
    }

    return total;
  }

  double getTotalPerbaikanPerItem(
    Map<String, dynamic> item,
    Map<String, dynamic> data,
  ) {
    final grades = data['sorting']?['grades'] ?? [];

    final itemCode = item['finished_product']?['code']?.toString().trim();
    final woItemId = item['wo_item_id'];

    double total = 0;

    for (final grade in grades) {
      final gradeItems = grade['items'] ?? [];

      final matched = gradeItems.cast<Map<String, dynamic>?>().firstWhere(
        (gradeItem) {
          final gradeItemCode =
              gradeItem?['finished_product']?['code']?.toString().trim();

          return gradeItem?['wo_item_id'] == woItemId;
        },
        orElse: () => null,
      );

      if (matched != null) {
        total += parseInput(matched['spraying']) +
            parseInput(matched['rework_long_hemming']) +
            parseInput(matched['combing']);
      }
    }

    return total;
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

              widget.form['grades'] = buildGradesPayload();
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
            widget.form.remove('semifinished_products');

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
    super.build(context);

    final woItems = widget.data['work_orders']['items'];

    String getSpkNo(Map<String, dynamic> item) {
      final woItemId = item['wo_item_id'];
      final itemCode = item['finished_product']?['code'];

      final matched = woItems.cast<Map<String, dynamic>?>().firstWhere(
            (e) => e?['id'] == woItemId && e?['item_code'] == itemCode,
            orElse: () => null,
          );

      return matched?['spk_no']?.toString() ?? woItemId.toString();
    }

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
                                                                                                : widget.label == 'Embroidery'
                                                                                                    ? '${widget.data['emb_no']}'
                                                                                                    : widget.label == 'Printing'
                                                                                                        ? '${widget.data['print_no']}'
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
                                    items: widget.form['items'] ?? [],
                                    workOrders: widget.data['work_orders']
                                            ?['items'] ??
                                        [],
                                    onChange: (index, key, value) {
                                      final items =
                                          List<Map<String, dynamic>>.from(
                                              widget.form['items']);

                                      items[index][key] = value;

                                      widget.handleChangeInput('items', items);
                                    },
                                    onRecalculate: calculateLongHemmingWeight,
                                  ),
                                if (widget.label == 'Cross Cutting' ||
                                    widget.label == 'Sewing')
                                  CuttingSewingQtySection(
                                    label: widget.label,
                                    items: widget.form['items'] ?? [],
                                    workOrders: widget.data['work_orders']
                                            ?['items'] ??
                                        [],
                                    onChange: (index, key, value) {
                                      final items =
                                          List<Map<String, dynamic>>.from(
                                        widget.form['items'],
                                      );

                                      items[index][key] = value;

                                      widget.handleChangeInput(
                                        'items',
                                        items,
                                      );
                                    },
                                  ),
                                if (widget.label == 'Sorting')
                                  SortingEditSection(
                                    form: widget.form,
                                    itemGradeOption: widget.itemGradeOption,
                                    updateTotalSorting: _updateTotalSorting,
                                    itemTypeOption: widget.itemTypeOption,
                                    data: widget.data,
                                  ),
                                if (widget.label == 'Packing')
                                  DefaultTabController(
                                    length: (widget.form['items'] ?? []).length,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6),
                                            child: TabBar(
                                              isScrollable: true,
                                              dividerColor: Colors.transparent,
                                              labelColor: Colors.white,
                                              unselectedLabelColor:
                                                  Colors.black,
                                              indicatorColor: Colors.white,
                                              indicator: BoxDecoration(
                                                color: Colors.blue[800],
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              tabAlignment: TabAlignment.start,
                                              tabs: [
                                                for (int index = 0;
                                                    index <
                                                        (widget.data['items'] ??
                                                                [])
                                                            .length;
                                                    index++)
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 4,
                                                      horizontal: 8,
                                                    ),
                                                    child: Tab(
                                                      text: 'Item ${index + 1}',
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.blue.shade100,
                                            ),
                                          ),
                                          child: Wrap(
                                            spacing: 12,
                                            runSpacing: 12,
                                            children: [
                                              _buildSummaryItem(
                                                'Total Grade A Sorting',
                                                formatNumber(
                                                    totalGradeASorting),
                                              ),
                                              _buildSummaryItem(
                                                'Total Keseluruhan Sorting',
                                                formatNumber(totalAllSorting),
                                              ),
                                              _buildSummaryItem(
                                                'Total Packing',
                                                formatNumber(totalPackingInput),
                                              ),
                                              _buildSummaryItem(
                                                'Total Berat Grade A',
                                                formatId(totalWeightGradeAAll),
                                              ),
                                              _buildSummaryItem(
                                                'Total Berat Keseluruhan',
                                                formatId(totalWeightAll),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 500,
                                          child: TabBarView(
                                            children:
                                                (widget.data['items'] ?? [])
                                                    .map<Widget>((item) {
                                              final itemId = item['id'];
                                              final sortingQty =
                                                  getSortingGradeQty(
                                                      item, widget.data);
                                              final totalPerbaikan =
                                                  getTotalPerbaikanPerItem(
                                                item,
                                                widget.data,
                                              );

                                              return Container(
                                                padding: EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: TemplateCard(
                                                  title: 'Material',
                                                  icon: Icons
                                                      .inventory_2_outlined,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        padding:
                                                            EdgeInsets.all(12),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .grey.shade50,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  item['finished_product']
                                                                          ?[
                                                                          'code'] ??
                                                                      '-',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 4),
                                                                Text(
                                                                  item['finished_product']
                                                                          ?[
                                                                          'name'] ??
                                                                      '-',
                                                                ),
                                                              ],
                                                            ),
                                                            CustomBadge(
                                                              status: 'Rework',
                                                              title: getSpkNo(
                                                                  item),
                                                              rework: true,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: double.infinity,
                                                        padding:
                                                            EdgeInsets.all(12),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .blue.shade50,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                            color: Colors
                                                                .blue.shade100,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    'Grade A',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          4),
                                                                  Text(
                                                                    formatNumber(
                                                                        sortingQty[
                                                                            'grade_a']),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    'Grade B',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          4),
                                                                  Text(
                                                                    formatNumber(
                                                                        sortingQty[
                                                                            'grade_b']),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    'Tipe BS',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          4),
                                                                  Text(
                                                                    formatNumber(
                                                                      sortingQty[
                                                                          'grade_bs'],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    'Total Perbaikan',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          4),
                                                                  Text(
                                                                    formatNumber(
                                                                        totalPerbaikan),
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .orange,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    'Total Keseluruhan',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          4),
                                                                  Text(
                                                                    formatNumber(
                                                                      parseInput(sortingQty['grade_a']) +
                                                                          parseInput(sortingQty[
                                                                              'grade_b']) +
                                                                          parseInput(
                                                                              sortingQty['grade_bs']) +
                                                                          totalPerbaikan,
                                                                    ),
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                PackingNumberForm(
                                                              label:
                                                                  'Total Packing (PCS)',
                                                              controller:
                                                                  _packingQtyControllers[
                                                                      itemId]!,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  item['qty'] =
                                                                      value;

                                                                  calculateBeratA(
                                                                      item);
                                                                  calculateTotalBerat(
                                                                    item,
                                                                    widget.data,
                                                                  );
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                PackingNumberForm(
                                                              label:
                                                                  'Berat 1 Lusin (KG)',
                                                              controller:
                                                                  _weightPerDozenControllers[
                                                                      itemId]!,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  item['weight_per_dozen'] =
                                                                      value;

                                                                  calculateGsm(
                                                                      item);
                                                                  calculateBeratA(
                                                                      item);
                                                                  calculateTotalBerat(
                                                                    item,
                                                                    widget.data,
                                                                  );
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ].separatedBy(
                                                          CustomTheme()
                                                              .hGap('xl'),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: TextForm(
                                                              label:
                                                                  'Gramasi (GSM)',
                                                              isDisabled: true,
                                                              controller:
                                                                  _gsmControllers[
                                                                      itemId],
                                                              handleChange:
                                                                  (value) {
                                                                setState(() {});
                                                              },
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: TextForm(
                                                              label:
                                                                  'Berat Grade A (KG)',
                                                              isDisabled: true,
                                                              controller:
                                                                  _weightGradeAControllers[
                                                                      itemId],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: TextForm(
                                                              label:
                                                                  'Total Berat (KG)',
                                                              isDisabled: true,
                                                              controller:
                                                                  _totalWeightControllers[
                                                                      itemId],
                                                            ),
                                                          ),
                                                        ].separatedBy(
                                                          CustomTheme()
                                                              .hGap('xl'),
                                                        ),
                                                      ),
                                                    ].separatedBy(
                                                      CustomTheme().vGap('xl'),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ].separatedBy(CustomTheme().vGap('xl')),
                                    ),
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

  Widget _buildSummaryItem(
    String title,
    String value,
  ) {
    return Container(
      width: 220,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
