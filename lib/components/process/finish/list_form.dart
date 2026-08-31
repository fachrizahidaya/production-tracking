// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/process/finish/form_items.dart';

class ListForm extends StatefulWidget {
  final formKey;
  final form;
  final id;
  final length;
  final width;
  final weight;
  final gsm;
  final totalWeight;
  final note;
  final qty;
  final qtyItem;
  final handleSelectWo;
  final handleChangeInput;
  final data;
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
  final validateWeight;
  final weightWarning;
  final validateQty;
  final qtyWarning;
  final weightGood;
  final weightDefect;
  final woData;
  final combing;
  final spraying;
  final itemTypeOption;
  final defects;
  final defectQty;
  final packingQty;
  final weightGradeA;
  final finishedItem;
  final dyeingQty;
  final finishedItemGrb;
  final isInitializing;
  final reworkCategoryOption;
  final handleItemQtyWarning;

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
      this.allAttachments,
      this.handlePickAttachments,
      this.processData,
      this.withItemGrade = false,
      this.itemGradeOption,
      this.qty,
      this.withQtyAndWeight = false,
      this.qtyItem,
      this.showImageDialog,
      this.handleDeleteAttachment,
      this.label,
      this.forDyeing,
      this.data,
      this.gsm,
      this.totalWeight,
      this.validateWeight,
      this.weightWarning,
      this.qtyWarning,
      this.validateQty,
      this.weightDefect,
      this.weightGood,
      this.woData,
      this.combing,
      this.spraying,
      this.itemTypeOption,
      this.defects,
      this.defectQty,
      this.packingQty,
      this.weightGradeA,
      this.finishedItem,
      this.dyeingQty,
      this.finishedItemGrb,
      this.isInitializing,
      this.reworkCategoryOption,
      this.handleItemQtyWarning});

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
      _syncDefectsWithOptions();
    });
    super.initState();
  }

  double? get greigeQty {
    return double.tryParse(
      widget.processData['work_orders']?['greige_qty']?.toString() ?? '',
    );
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
        length: widget.length,
        width: widget.width,
        weight: widget.weight,
        note: widget.note,
        handleChangeInput: widget.handleChangeInput,
        qty: widget.qty,
        grades: _grades,
        allAttachments: widget.allAttachments,
        handleSelectWo: widget.handleSelectWo,
        handlePickAttachments: widget.handlePickAttachments,
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
        gsm: widget.gsm,
        totalWeight: widget.totalWeight,
        qtyItem: widget.qtyItem,
        weightDefect: widget.weightDefect,
        weightGood: widget.weightGood,
        woData: widget.woData,
        combing: widget.combing,
        spraying: widget.spraying,
        itemTypeOption: widget.itemTypeOption,
        packingQty: widget.packingQty,
        weightGradeA: widget.weightGradeA,
        finishedItem: widget.finishedItem,
        dyeingQty: widget.dyeingQty,
        finishedItemGrb: widget.finishedItemGrb,
        isInitializing: widget.isInitializing,
        reworkCategoryOption: widget.reworkCategoryOption,
        handleItemQtyWarning: widget.handleItemQtyWarning,
      ),
    );
  }
}
