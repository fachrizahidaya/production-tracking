// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/process/finish/form_items.dart';

class ListForm extends StatefulWidget {
  final formKey;
  final form;
  final id;
  final processId;
  final length;
  final width;
  final weight;
  final weightDozen;
  final gsm;
  final totalWeight;
  final note;
  final qty;
  final qtyItem;
  final handleSelectWo;
  final handleChangeInput;
  final handleSelectUnit;
  final handleSelectQtyUnit;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;
  final handleSelectQtyUnitItem;
  final handleSelectQtyUnitDyeing;
  final data;

  final handleSelectMachine;
  final isChanged;
  final allAttachments;
  final handlePickAttachments;
  final handleDeleteAttachment;
  final processData;
  final withItemGrade;
  final itemGradeOption;
  final withQtyAndWeight;
  final showImageDialog;
  final label;
  final forDyeing;
  final forPacking;
  final forHemming;
  final forSewing;
  final validateWeight;
  final weightWarning;
  final validateQty;
  final qtyWarning;
  final handleTotalItemQty;
  final handleRemainingQtyForGrade;
  final onGradeChanged;
  final dyeingLotNo;
  final handleSelectFinishedMaterial;
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

  const ListForm(
      {super.key,
      this.formKey,
      this.id,
      this.handleSelectWo,
      this.form,
      this.length,
      this.width,
      this.weight,
      this.note,
      this.handleChangeInput,
      this.handleSelectUnit,
      this.handleSelectLengthUnit,
      this.handleSelectWidthUnit,
      this.handleSelectMachine,
      this.processId,
      this.isChanged,
      this.allAttachments,
      this.handlePickAttachments,
      this.processData,
      this.withItemGrade = false,
      this.itemGradeOption,
      this.handleSelectQtyUnit,
      this.qty,
      this.withQtyAndWeight = false,
      this.handleSelectQtyUnitItem,
      this.qtyItem,
      this.showImageDialog,
      this.handleDeleteAttachment,
      this.label,
      this.forDyeing,
      this.handleSelectQtyUnitDyeing,
      this.data,
      this.forPacking,
      this.gsm,
      this.totalWeight,
      this.weightDozen,
      this.validateWeight,
      this.weightWarning,
      this.qtyWarning,
      this.validateQty,
      this.handleRemainingQtyForGrade,
      this.handleTotalItemQty,
      this.onGradeChanged,
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
      this.dyeingQty});

  @override
  State<ListForm> createState() => _ListFormState();
}

class _ListFormState extends State<ListForm> {
  late List<Map<String, dynamic>> _grades;
  late List<Map<String, dynamic>> _defects;

  @override
  void initState() {
    _grades = (widget.form['grades'] ?? [])
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();
    _defects = (widget.defects ?? [])
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncGradesWithOptions();
      _syncDefectsWithOptions();
    });
    super.initState();
  }

  double? get greigeQty {
    return double.tryParse(
      widget.processData['work_orders']?['greige_qty']?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant ListForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemGradeOption != widget.itemGradeOption) {
      _syncGradesWithOptions();
    }
  }

  void _syncGradesWithOptions() {
    final List<Map<String, dynamic>> updated = [];

    for (var grade in widget.itemGradeOption ?? []) {
      final existing = _grades.firstWhere(
        (g) => g['item_grade_id'].toString() == grade['value'].toString(),
        orElse: () => {},
      );

      updated.add({
        'item_grade_id': grade['value'],
        'unit_id': existing['unit_id'] ?? 1,
        'notes': existing['notes'] ?? '',
        'qty': existing['qty'] ?? '0',
        'greige_item_id': existing['greige_item_id'],
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _grades = updated;
        });
        widget.handleChangeInput('grades', _grades);
      }
    });
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

  void _updateGrade(int index, String key, dynamic value) {
    setState(() {
      _grades[index][key] = value;
    });

    widget.handleChangeInput('grades', _grades);
    widget.onGradeChanged(_grades);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: FormItems(
        id: widget.id,
        form: widget.form,
        withItemGrade: widget.withItemGrade,
        withQtyAndWeight: widget.withQtyAndWeight,
        itemGradeOption: widget.itemGradeOption,
        handleSelectQtyUnit: widget.handleSelectQtyUnit,
        length: widget.length,
        width: widget.width,
        weight: widget.weight,
        note: widget.note,
        handleChangeInput: widget.handleChangeInput,
        handleSelectLengthUnit: widget.handleSelectLengthUnit,
        handleSelectWidthUnit: widget.handleSelectWidthUnit,
        handleSelectUnit: widget.handleSelectUnit,
        qty: widget.qty,
        grades: _grades,
        allAttachments: widget.allAttachments,
        handleSelectWo: widget.handleSelectWo,
        handleUpdateGrade: _updateGrade,
        handlePickAttachments: widget.handlePickAttachments,
        handleSelectQtyUnitItem: widget.handleSelectQtyUnitItem,
        handleSelectQtyUnitDyeing: widget.handleSelectQtyUnitDyeing,
        showImageDialog: widget.showImageDialog,
        handleDeleteAttachment: widget.handleDeleteAttachment,
        validateWeight: widget.validateWeight,
        validateQty: widget.validateQty,
        weightWarning: widget.weightWarning,
        qtyWarning: widget.qtyWarning,
        label: widget.label,
        forDyeing: widget.forDyeing,
        data: widget.data,
        processData: widget.processData,
        forPacking: widget.forPacking,
        gsm: widget.gsm,
        weightDozen: widget.weightDozen,
        totalWeight: widget.totalWeight,
        handleRemainingQtyForGrade: widget.handleRemainingQtyForGrade,
        handleTotalItemQty: widget.handleTotalItemQty,
        qtyItem: widget.qtyItem,
        dyeingLotNo: widget.dyeingLotNo,
        forSewing: widget.forSewing,
        forHemming: widget.forHemming,
        handleSelectFinishedMaterial: widget.handleSelectFinishedMaterial,
        weightDefect: widget.weightDefect,
        weightGood: widget.weightGood,
        woData: widget.woData,
        reworkLongHemming: widget.reworkLongHemming,
        combing: widget.combing,
        spraying: widget.spraying,
        itemTypeOption: widget.itemTypeOption,
        defects: _defects,
        defectQty: widget.defectQty,
        handleSelectItemType: widget.handleSelectItemType,
        handleUpdateDefect: widget.handleUpdateDefect,
        packingQty: widget.packingQty,
        weightGradeA: widget.weightGradeA,
        finishedItem: widget.finishedItem,
      ),
    );
  }
}
