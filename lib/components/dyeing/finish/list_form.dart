// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/finish/form_section.dart';

class ListForm extends StatefulWidget {
  final formKey;
  final form;
  final data;
  final woData;
  final id;
  final dyeingId;
  final length;
  final width;
  final qty;
  final note;
  final handleSelectWo;
  final handleChangeInput;
  final handleSelectUnit;
  final handleSelectMachine;
  final isSubmitting;
  final handleSubmit;
  final isFormIncomplete;
  final isChanged;
  final initialQty;
  final initialLength;
  final initialWidth;
  final initialNotes;
  final allAttachments;
  final handlePickAttachments;
  final handleDeleteAttachment;
  final dyeingData;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;
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
      this.qty,
      this.note,
      this.handleChangeInput,
      this.handleSelectUnit,
      this.isSubmitting,
      this.handleSelectMachine,
      this.handleSubmit,
      this.isFormIncomplete,
      this.dyeingId,
      this.isChanged,
      this.initialQty,
      this.initialLength,
      this.initialWidth,
      this.initialNotes,
      this.allAttachments,
      this.handlePickAttachments,
      this.dyeingData,
      this.handleSelectLengthUnit,
      this.handleSelectWidthUnit,
      this.showImageDialog,
      this.handleDeleteAttachment,
      this.woData});

  @override
  State<ListForm> createState() => _ListFormState();
}

class _ListFormState extends State<ListForm> {
  String? _qtyWarningMessage;

  @override
  void initState() {
    super.initState();
  }

  void _validateQty(String qty) {
    final greigeQty =
        double.tryParse(widget.dyeingData['work_orders']['greige_qty']);
    final berat = double.tryParse(qty);

    if (greigeQty == null || berat == null || greigeQty <= 0) {
      setState(() {
        _qtyWarningMessage = null;
      });
      return;
    }

    final lowerLimit = greigeQty * 0.9;
    final upperLimit = greigeQty * 1.1;

    if (berat < lowerLimit || berat > upperLimit) {
      final diffPercent = ((berat - greigeQty) / greigeQty) * 100;

      setState(() {
        _qtyWarningMessage = 'Qty ${berat < greigeQty ? 'kurang' : 'lebih'} '
            '${diffPercent.abs().toStringAsFixed(2)}% '
            '(Batas: ${lowerLimit.toStringAsFixed(0)} – ${upperLimit.toStringAsFixed(0)})';
      });
    } else {
      setState(() {
        _qtyWarningMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: FormSection(
        id: widget.id,
        form: widget.form,
        data: widget.data,
        length: widget.length,
        width: widget.width,
        qty: widget.qty,
        note: widget.note,
        allAttachments: widget.allAttachments,
        handleChangeInput: widget.handleChangeInput,
        handleSelectWo: widget.handleSelectWo,
        handleSelectLengthUnit: widget.handleSelectLengthUnit,
        handleSelectWidthUnit: widget.handleSelectWidthUnit,
        handleSelectUnit: widget.handleSelectUnit,
        handlePickAttachments: widget.handlePickAttachments,
        showImageDialog: widget.showImageDialog,
        handleDeleteAttachment: widget.handleDeleteAttachment,
        validateQty: _validateQty,
        qtyWarning: _qtyWarningMessage,
      ),
    );
  }
}
