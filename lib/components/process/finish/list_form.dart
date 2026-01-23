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
  final isFormIncomplete;
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
  final validateWeight;
  final weightWarning;
  final validateQty;
  final qtyWarning;
  final handleTotalItemQty;
  final handleRemainingQtyForGrade;
  final onGradeChanged;

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
      this.isFormIncomplete,
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
      this.onGradeChanged});

  @override
  State<ListForm> createState() => _ListFormState();
}

class _ListFormState extends State<ListForm> {
  late List<Map<String, dynamic>> _grades;

  @override
  void initState() {
    _grades = (widget.form['grades'] ?? [])
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();
    _syncGradesWithOptions();
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
        'unit_id': existing['unit_id'] ?? 5,
        'notes': existing['notes'] ?? '',
        'qty': existing['qty'] ?? '0',
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
        forPacking: widget.forPacking,
        greigeQty: greigeQty,
        gsm: widget.gsm,
        weightDozen: widget.weightDozen,
        totalWeight: widget.totalWeight,
        handleRemainingQtyForGrade: widget.handleRemainingQtyForGrade,
        handleTotalItemQty: widget.handleTotalItemQty,
      ),
    );
  }
}
