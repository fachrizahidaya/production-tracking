// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/packing_number_form.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/process/finish/process/form_helpers.dart';
import 'package:textile_tracking/components/process/finish/process/long_hemming_weight.dart';
import 'package:textile_tracking/components/process/finish/process/process_item_qty.dart';
import 'package:textile_tracking/components/process/finish/process/qty_weight.dart';
import 'package:textile_tracking/components/process/finish/process/sorting.dart';
import 'package:textile_tracking/components/process/finish/process/weight.dart';
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
  final dyeingQty;
  final finishedItemGood;
  final finishedItemGrb;
  final isInitializing;

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
      this.finishedItem,
      this.dyeingQty,
      this.finishedItemGood,
      this.finishedItemGrb,
      this.isInitializing});

  @override
  State<FormItems> createState() => _FormItemsState();
}

class _FormItemsState extends State<FormItems>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  double beratLusin = 0;
  double gsm = 0;
  double beratGradeA = 0;
  double totalBerat = 0;
  late List<Map<String, dynamic>> _grades;
  TabController? _semiFinishedTabController;
  int _selectedSemiFinishedIndex = 0;
  final Map<int, TextEditingController> _packingQtyControllers = {};
  final Map<int, TextEditingController> _weightPerDozenControllers = {};
  final Map<int, TextEditingController> _gsmControllers = {};
  final Map<int, TextEditingController> _weightGradeAControllers = {};
  final Map<int, TextEditingController> _totalWeightControllers = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _grades = (widget.processData['grades'] ?? [])
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();
    _initGradeControllers();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final items = safeItems;

      if (items.isNotEmpty) {
        calculateLongHemmingWeight();
      }

      _syncGradesWithOptions();

      _initializeSemiFinishedTab();

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
          widget.processData,
        );
      }
    });

    final semiFinishedProducts = this.semiFinishedProducts;

    if (semiFinishedProducts.length > 1) {
      _semiFinishedTabController = TabController(
        length: semiFinishedProducts.length,
        vsync: this,
      );

      _semiFinishedTabController!.addListener(() {
        if (!_semiFinishedTabController!.indexIsChanging) {
          final selectedIndex = _semiFinishedTabController!.index;

          final semiFinishedProducts = this.semiFinishedProducts;

          setState(() {
            _selectedSemiFinishedIndex = selectedIndex;

            widget.handleChangeInput(
              'greige_item_id',
              semiFinishedProducts[selectedIndex]['id'],
            );

            widget.handleChangeInput(
              'nama_greige_item',
              semiFinishedProducts[selectedIndex]['name'],
            );

            widget.handleChangeInput(
              'sku_greige_item',
              semiFinishedProducts[selectedIndex]['code'],
            );
          });
        }
      });
    }
  }

  void _syncGradesWithOptions() {
    final List<Map<String, dynamic>> updated = [];

    for (int i = 0; i < widget.itemGradeOption.length; i++) {
      final grade = widget.itemGradeOption[i];

      final existing = _grades.firstWhere(
        (g) => g['item_grade_id'].toString() == grade['value'].toString(),
        orElse: () => {},
      );

      dynamic greigeItemId;

      if (i == 0) {
        greigeItemId = widget.processData['greige_item'] != null
            ? widget.processData['greige_item']['id']
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
        'item_grade_id': grade['value'],
        'unit_id': existing['unit_id'] ?? 1,
        'qty': existing['qty'] ?? '0',
        'notes': existing['notes'] ?? '',
        'greige_item_id': greigeItemId,
        'name': grade['label'] ?? ''
      });
    }

    setState(() {
      _grades = updated;
    });

    widget.handleChangeInput('grades', _grades);
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

    final beratLusin = parseInput(
      item['weight_per_dozen'],
    );

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

  void calculateBeratA(
    Map<String, dynamic> item,
  ) {
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

    for (final grade in grades) {
      final gradeItems = grade['items'] ?? [];

      final matched = gradeItems.cast<Map<String, dynamic>?>().firstWhere(
        (gradeItem) {
          final gradeItemCode =
              gradeItem?['finished_product']?['code']?.toString().trim();

          return gradeItemCode == itemCode;
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

  double parseSafe(dynamic val) {
    if (val == null) return 0;

    String str = val.toString().trim();

    if (str.isEmpty) return 0;

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

  void _initializeSemiFinishedTab() {
    final semiFinishedProducts = this.semiFinishedProducts;

    // dispose controller lama
    _semiFinishedTabController?.dispose();
    _semiFinishedTabController = null;

    if (semiFinishedProducts.length > 1) {
      _semiFinishedTabController = TabController(
        length: semiFinishedProducts.length,
        vsync: this,
      );

      _semiFinishedTabController!.addListener(() {
        if (!_semiFinishedTabController!.indexIsChanging) {
          final selectedIndex = _semiFinishedTabController!.index;

          final semiFinishedProducts = this.semiFinishedProducts;

          setState(() {
            _selectedSemiFinishedIndex = selectedIndex;

            widget.handleChangeInput(
              'greige_item_id',
              semiFinishedProducts[selectedIndex]['id'],
            );

            widget.handleChangeInput(
              'nama_greige_item',
              semiFinishedProducts[selectedIndex]['name'],
            );

            widget.handleChangeInput(
              'sku_greige_item',
              semiFinishedProducts[selectedIndex]['code'],
            );
          });
        }
      });
    }

    if (semiFinishedProducts.isNotEmpty) {
      widget.handleChangeInput(
        'greige_item_id',
        semiFinishedProducts[0]['id'],
      );

      widget.handleChangeInput(
        'nama_greige_item',
        semiFinishedProducts[0]['name'],
      );

      widget.handleChangeInput(
        'sku_greige_item',
        semiFinishedProducts[0]['code'],
      );
    }
  }

  Map<String, dynamic>? get selectedSemiFinishedItem {
    final semiFinishedProducts = this.semiFinishedProducts;

    if (semiFinishedProducts == null || semiFinishedProducts.isEmpty) {
      return null;
    }

    return semiFinishedProducts[_selectedSemiFinishedIndex];
  }

  bool get isLoadingSemiFinished {
    final hasSelectedWO = widget.form['wo_id'] != null;

    final semiFinishedProducts = this.semiFinishedProducts;

    return hasSelectedWO && semiFinishedProducts.isEmpty;
  }

  List<dynamic> get semiFinishedProducts {
    if (widget.label == 'Dyeing') {
      return (widget.processData['semifinished_products'] ?? [])
          .where((item) => item != null)
          .toList();
    }

    final items = widget.processData['items'] ?? [];

    return items
        .map((item) => item['semifinished_product'])
        .where((item) => item != null)
        .toList();
  }

  @override
  void didUpdateWidget(covariant FormItems oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldItems = (oldWidget.processData['items'] ?? [])
        .map((item) => item['semifinished_product'])
        .where((item) => item != null)
        .toList();

    final newItems = (widget.processData['items'] ?? [])
        .map((item) => item['semifinished_product'])
        .where((item) => item != null)
        .toList();

    if (oldItems.toString() != newItems.toString()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeSemiFinishedTab();
      });
    }
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

    for (final grade in grades) {
      final gradeCode = grade['item_grade']?['code']?.toString().trim();

      final gradeItems = grade['items'] ?? [];

      final matched = gradeItems.cast<Map<String, dynamic>?>().firstWhere(
        (gradeItem) {
          final gradeItemCode =
              gradeItem?['finished_product']?['code']?.toString().trim();

          return gradeItemCode == itemCode;
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

  double getTotalPerbaikanPerItem(
    Map<String, dynamic> item,
    Map<String, dynamic> data,
  ) {
    final grades = data['sorting']?['grades'] ?? [];

    final itemCode = item['finished_product']?['code']?.toString().trim();

    double total = 0;

    for (final grade in grades) {
      final gradeItems = grade['items'] ?? [];

      final matched = gradeItems.cast<Map<String, dynamic>?>().firstWhere(
        (gradeItem) {
          final gradeItemCode =
              gradeItem?['finished_product']?['code']?.toString().trim();

          return gradeItemCode == itemCode;
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

  List<Map<String, dynamic>> get safeItems {
    final raw = widget.form['items'];

    if (raw is List) {
      return List<Map<String, dynamic>>.from(raw);
    }

    return [];
  }

  double get totalGradeASorting {
    final grades = widget.processData?['sorting']?['grades'] ?? [];

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
    final grades = widget.processData?['sorting']?['grades'] ?? [];

    double total = 0;

    for (final grade in grades) {
      total += parseInput(grade['qty']);
    }

    return total;
  }

  double get totalPackingInput {
    final items = widget.processData?['items'] ?? widget.form['items'] ?? [];

    double total = 0;

    for (final item in items) {
      total += parseInput(item['qty']);
    }

    return total;
  }

  double get totalWeightGradeAAll {
    final items = widget.processData?['items'] ?? widget.form['items'] ?? [];

    double total = 0;

    for (final item in items) {
      total += parseInput(item['weight_grade_a']);
    }

    return total;
  }

  double get totalWeightAll {
    final items = widget.processData?['items'] ?? widget.form['items'] ?? [];

    double total = 0;

    for (final item in items) {
      total += parseInput(item['total_weight']);
    }

    return total;
  }

  @override
  void dispose() {
    _semiFinishedTabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final semiFinishedProducts = this.semiFinishedProducts;
    final items =
        (widget.form['items'] is List) ? safeItems : <Map<String, dynamic>>[];

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
                    widget.label != 'Embroidery' &&
                    widget.label != 'Printing' &&
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
            if (widget.data != null &&
                widget.label != 'Dyeing' &&
                widget.label != 'Long Hemming' &&
                widget.label != 'Cross Cutting' &&
                widget.label != 'Sewing' &&
                widget.label != 'Embroidery' &&
                widget.label != 'Printing' &&
                widget.label != 'Sorting' &&
                widget.label != 'Packing')
              Expanded(
                child: WeightSection(
                  form: widget.form,
                  controller: widget.weight,
                  warning: widget.weightWarning,
                  onChange: (val) {
                    widget.handleChangeInput('weight', val);
                  },
                  onValidate: (val) {
                    widget.validateWeight(val);
                  },
                ),
              ),
            if (widget.data != null &&
                (widget.label == 'Long Hemming' ||
                    widget.label == 'Cross Cutting' ||
                    widget.label == 'Sewing') &&
                widget.withItemGrade == false &&
                widget.label == 'Dyeing' &&
                widget.label != 'Packing' &&
                widget.label != 'Press' &&
                widget.label != 'Tumbler' &&
                widget.label != 'Stenter' &&
                widget.label != 'Long Slitting')
              QtyWeightSection(
                form: widget.form,
                label: widget.label,
                withItemGrade: widget.withItemGrade,
                withQtyAndWeight: widget.withQtyAndWeight,
                forDyeing: widget.forDyeing,
                qty: widget.qty,
                dyeingQty: widget.dyeingQty,
                weightGood: widget.weightGood,
                weightDefect: widget.weightDefect,
                qtyWarning: widget.qtyWarning,
                weightWarning: widget.weightWarning,
                onChange: widget.handleChangeInput,
                validateQty: widget.validateQty,
                validateWeight: widget.validateWeight,
                calculateLongHemmingWeight: calculateLongHemmingWeight,
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
              child: FormHelpers.buildMachine(
                context: context,
                machines: widget.processData['machines'] ?? [],
              )),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.data != null &&
                (widget.label == 'Long Hemming' ||
                    widget.label == 'Cross Cutting' ||
                    widget.label == 'Sewing') &&
                widget.withItemGrade == false &&
                widget.label != 'Packing' &&
                widget.label != 'Press' &&
                widget.label != 'Tumbler' &&
                widget.label != 'Stenter' &&
                widget.label != 'Long Slitting' &&
                widget.label != 'Embroidery' &&
                widget.label != 'Printing' &&
                widget.label != 'Sorting' &&
                widget.label != 'Packing')
              if (isLoadingSemiFinished)
                Expanded(
                  child: SizedBox(
                    height: 120,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              else if (widget.label == 'Long Hemming')
                LongHemmingItemsWeightSection(
                  items: widget.form['items'] ?? [],
                  onChange: (index, key, value) {
                    final items =
                        List<Map<String, dynamic>>.from(widget.form['items']);

                    items[index][key] = value;

                    widget.handleChangeInput('items', items);

                    calculateLongHemmingWeight();
                  },
                )
              else
                ProcessItemsQtySection(
                  label: widget.label,
                  items: widget.form['items'] ?? [],
                  onChange: (index, key, value) {
                    final items = List<Map<String, dynamic>>.from(
                      widget.form['items'],
                    );

                    items[index][key] = value;

                    widget.handleChangeInput(
                      'items',
                      items,
                    );
                  },
                ),
            if (widget.label != 'Long Hemming' &&
                widget.label != 'Cross Cutting' &&
                widget.label != 'Sewing' &&
                widget.label != 'Press' &&
                widget.label != 'Tumbler' &&
                widget.label != 'Stenter' &&
                widget.label != 'Long Slitting' &&
                widget.label != 'Embroidery' &&
                widget.label != 'Printing' &&
                widget.label != 'Sorting' &&
                widget.label != 'Packing')
              if (isLoadingSemiFinished)
                Expanded(
                  child: SizedBox(
                    height: 120,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              else if (semiFinishedProducts.isNotEmpty)
                Expanded(
                  child: TemplateCard(
                    title: 'Produk Setengah Jadi',
                    icon: Icons.inventory_2_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_semiFinishedTabController != null)
                          TabBar(
                            tabAlignment: TabAlignment.start,
                            controller: _semiFinishedTabController,
                            isScrollable: true,
                            labelColor: Colors.black,
                            tabs: List.generate(
                              semiFinishedProducts.length,
                              (index) {
                                return Tab(
                                  text: semiFinishedProducts[index]['code']
                                          ?.toString()
                                          .split('-')
                                          .first ??
                                      'Item ${index + 1}',
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedSemiFinishedItem?['code'] ?? '-',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      selectedSemiFinishedItem?['name'] ?? '-',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
                SortingSection(
                  form: widget.form,
                  itemGradeOption: widget.itemGradeOption,
                  itemTypeOption: widget.itemTypeOption,
                  processData: widget.processData,
                  finishedItemGrb: widget.finishedItemGrb,
                  finishedItem: widget.finishedItem,
                  woData: widget.woData,
                  isInitializing: widget.isInitializing,
                ),
              if (widget.label == 'Packing')
                DefaultTabController(
                  length: items.length,
                  child: Column(
                    children: [
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: TabBar(
                            dividerColor: Colors.transparent,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black,
                            indicatorColor: Colors.white,
                            indicator: BoxDecoration(
                              color: Colors.blue[800],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            tabs: [
                              for (final item
                                  in (widget.processData['items'] ?? []))
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  child: Tab(
                                    text: item['finished_product']?['code'] ??
                                        '-',
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
                          borderRadius: BorderRadius.circular(12),
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
                              formatNumber(totalGradeASorting),
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
                          children: (safeItems).map<Widget>((item) {
                            final itemId = item['id'];

                            _packingQtyControllers.putIfAbsent(
                              itemId,
                              () => TextEditingController(
                                text: item['qty']?.toString() ?? '0',
                              ),
                            );

                            _weightPerDozenControllers.putIfAbsent(
                              itemId,
                              () => TextEditingController(
                                text:
                                    item['weight_per_dozen']?.toString() ?? '0',
                              ),
                            );

                            _gsmControllers.putIfAbsent(
                              itemId,
                              () => TextEditingController(
                                text: item['gsm']?.toString() ?? '0',
                              ),
                            );

                            _weightGradeAControllers.putIfAbsent(
                              itemId,
                              () => TextEditingController(
                                text: item['weight_grade_a']?.toString() ?? '0',
                              ),
                            );

                            _totalWeightControllers.putIfAbsent(
                              itemId,
                              () => TextEditingController(
                                text: item['total_weight']?.toString() ?? '0',
                              ),
                            );

                            final sortingQty = getSortingGradeQty(
                              item,
                              widget.processData,
                            );
                            final totalPerbaikan = getTotalPerbaikanPerItem(
                              item,
                              widget.processData,
                            );

                            return TemplateCard(
                              title: item['finished_product']?['code'] ?? '-',
                              icon: Icons.inventory_2_outlined,
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['finished_product']?['code'] ??
                                              '-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          item['finished_product']?['name'] ??
                                              '-',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.blue.shade100,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Grade A',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                formatNumber(
                                                    sortingQty['grade_a']),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Grade B',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                formatNumber(
                                                    sortingQty['grade_b']),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Tipe BS',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                formatNumber(
                                                  sortingQty['grade_bs'],
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
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                formatNumber(totalPerbaikan),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
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
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                formatNumber(
                                                  parseInput(
                                                        sortingQty['grade_a'],
                                                      ) +
                                                      parseInput(
                                                        sortingQty['grade_b'],
                                                      ) +
                                                      parseInput(
                                                        sortingQty['grade_bs'],
                                                      ) +
                                                      totalPerbaikan,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: PackingNumberForm(
                                          label: 'Total Packing (PCS)',
                                          controller:
                                              _packingQtyControllers[itemId]!,
                                          onChanged: (value) {
                                            setState(() {
                                              item['qty'] = value;

                                              calculateBeratA(item);
                                              calculateTotalBerat(
                                                item,
                                                widget.processData,
                                              );
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: PackingNumberForm(
                                          label: 'Berat per Lusin (KG)',
                                          controller:
                                              _weightPerDozenControllers[
                                                  itemId]!,
                                          onChanged: (value) {
                                            setState(() {
                                              item['weight_per_dozen'] = value;

                                              calculateGsm(item);
                                              calculateBeratA(item);
                                              calculateTotalBerat(
                                                item,
                                                widget.processData,
                                              );
                                            });
                                          },
                                        ),
                                      ),
                                    ].separatedBy(
                                      CustomTheme().hGap('xl'),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextForm(
                                          label: 'Gramasi (GSM)',
                                          isDisabled: true,
                                          controller: _gsmControllers[itemId],
                                        ),
                                      ),
                                      Expanded(
                                        child: TextForm(
                                          label: 'Berat Grade A (KG)',
                                          isDisabled: true,
                                          controller:
                                              _weightGradeAControllers[itemId],
                                        ),
                                      ),
                                      Expanded(
                                        child: TextForm(
                                          label: 'Total Berat (KG)',
                                          isDisabled: true,
                                          controller:
                                              _totalWeightControllers[itemId],
                                        ),
                                      ),
                                    ].separatedBy(
                                      CustomTheme().hGap('xl'),
                                    ),
                                  ),
                                ].separatedBy(
                                  CustomTheme().vGap('xl'),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ].separatedBy(
                      CustomTheme().vGap('xl'),
                    ),
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
            ].separatedBy(CustomTheme().vGap('xl')),
          ),
      ].separatedBy(CustomTheme().vGap('lg')),
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
            '${formatNumber(widget.processData['rework_reference']?['work_orders']?['greige_qty'])} ${widget.processData['rework_reference']?['work_orders']?['greige_unit']?['code'] ?? ''}',
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

/*
Qty Sorting
*/
}
