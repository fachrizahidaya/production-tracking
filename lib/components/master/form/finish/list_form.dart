// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/finish/form_section.dart';

class ListForm extends StatefulWidget {
  final formKey;
  final form;
  final data;
  final id;
  final processId;
  final length;
  final width;
  final weight;
  final note;
  final qty;
  final qtyItem;
  final notes;
  final handleSelectWo;
  final handleChangeInput;
  final handleSelectUnit;
  final handleSelectQtyUnit;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;
  final handleSelectQtyUnitItem;
  final handleSelectMachine;
  final isSubmitting;
  final handleSubmit;
  final isFormIncomplete;
  final isChanged;
  final initialQty;
  final initialWeight;
  final initialLength;
  final initialWidth;
  final initialNotes;
  final allAttachments;
  final handlePickAttachments;
  final handleDeleteAttachment;
  final processData;
  final withItemGrade;
  final itemGradeOption;
  final withQtyAndWeight;
  final showImageDialog;

  const ListForm(
      {super.key,
      this.formKey,
      this.id,
      this.handleSelectWo,
      this.form,
      this.data,
      this.length,
      this.width,
      this.weight,
      this.note,
      this.handleChangeInput,
      this.handleSelectUnit,
      this.handleSelectLengthUnit,
      this.handleSelectWidthUnit,
      this.isSubmitting,
      this.handleSelectMachine,
      this.handleSubmit,
      this.isFormIncomplete,
      this.processId,
      this.isChanged,
      this.initialWeight,
      this.initialLength,
      this.initialWidth,
      this.initialNotes,
      this.allAttachments,
      this.handlePickAttachments,
      this.processData,
      this.withItemGrade = false,
      this.itemGradeOption,
      this.handleSelectQtyUnit,
      this.notes,
      this.qty,
      this.withQtyAndWeight = false,
      this.handleSelectQtyUnitItem,
      this.initialQty,
      this.qtyItem,
      this.showImageDialog,
      this.handleDeleteAttachment});

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
        'unit_id': existing['unit_id'] ?? '',
        'notes': existing['notes'] ?? '',
        'qty': existing['qty'] ?? '',
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
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: FormSection(
        id: widget.id,
        data: widget.data,
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
        showImageDialog: widget.showImageDialog,
        handleDeleteAttachment: widget.handleDeleteAttachment,
      ),
    );
  }
}
