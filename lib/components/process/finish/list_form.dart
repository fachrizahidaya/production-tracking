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
      this.weightDozen});

  @override
  State<ListForm> createState() => _ListFormState();
}

class _ListFormState extends State<ListForm> {
  late List<Map<String, dynamic>> _grades;
  String? _itemWarningValidationMessage;
  String? _weightWarningValidationMessage;

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

  double _getTotalItemQty() {
    final workOrders = widget.processData['work_orders'];
    if (workOrders == null) return 0;

    final List<dynamic>? items = workOrders['items'];

    if (items == null || items.isEmpty) return 0;

    return items.fold<double>(0, (sum, item) {
      final qty = double.tryParse(item['qty']?.toString() ?? '0') ?? 0;
      return sum + qty;
    });
  }

  void _validateWeight(String weight) {
    final greigeQty =
        double.tryParse(widget.processData['work_orders']['greige_qty']);
    final berat = double.tryParse(weight);

    if (greigeQty == null || berat == null || greigeQty <= 0) {
      setState(() {
        _weightWarningValidationMessage = null;
      });
      return;
    }

    final lowerLimit = greigeQty * 0.9;
    final upperLimit = greigeQty * 1.1;

    if (berat < lowerLimit || berat > upperLimit) {
      final diffPercent = ((berat - greigeQty) / greigeQty) * 100;

      setState(() {
        _weightWarningValidationMessage =
            'Qty ${berat < greigeQty ? 'kurang' : 'lebih'} '
            '${diffPercent.abs().toStringAsFixed(2)}% '
            '(Batas: ${lowerLimit.toStringAsFixed(0)} – ${upperLimit.toStringAsFixed(0)})';
      });
    } else {
      setState(() {
        _weightWarningValidationMessage = null;
      });
    }
  }

  void _validateQty(String woQty) {
    final qty = _getTotalItemQty();
    final berat = double.tryParse(woQty);

    if (qty <= 0 || berat == null) {
      setState(() {
        _itemWarningValidationMessage = null;
      });
      return;
    }

    final lowerLimit = qty * 0.9;
    final upperLimit = qty * 1.1;

    if (berat < lowerLimit || berat > upperLimit) {
      final diffPercent = ((berat - qty) / qty) * 100;

      setState(() {
        _itemWarningValidationMessage =
            'Qty ${berat < qty ? 'kurang' : 'lebih'} '
            '${diffPercent.abs().toStringAsFixed(2)}% '
            '(Batas: ${lowerLimit.toStringAsFixed(0)} – ${upperLimit.toStringAsFixed(0)})';
      });
    } else {
      setState(() {
        _itemWarningValidationMessage = null;
      });
    }
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
        validateWeight: _validateWeight,
        validateQty: _validateQty,
        weightWarning: _weightWarningValidationMessage,
        qtyWarning: _itemWarningValidationMessage,
        label: widget.label,
        forDyeing: widget.forDyeing,
        data: widget.data,
        forPacking: widget.forPacking,
        greigeQty: greigeQty,
        gsm: widget.gsm,
        weightDozen: widget.weightDozen,
        totalWeight: widget.totalWeight,
      ),
    );
  }
}
