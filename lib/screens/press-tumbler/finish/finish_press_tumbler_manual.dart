// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/finish/%5Bfinish_process_id%5D.dart';
import 'package:textile_tracking/models/process/press_tumbler.dart';

class FinishPressTumblerManual extends StatefulWidget {
  final id;
  final data;
  final form;
  final handleSubmit;
  final handleChangeInput;
  final processId;
  final forPacking;
  final withItemGrade;
  final withQtyAndWeight;
  final forDyeing;

  const FinishPressTumblerManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput,
      this.processId,
      this.forDyeing,
      this.forPacking,
      this.withItemGrade,
      this.withQtyAndWeight});

  @override
  State<FinishPressTumblerManual> createState() =>
      _FinishPressTumblerManualState();
}

class _FinishPressTumblerManualState extends State<FinishPressTumblerManual> {
  final PressTumblerService _pressTumblerService = PressTumblerService();

  @override
  void initState() {
    widget.form?['length'] ??= '0';
    widget.form?['width'] ??= '0';
    widget.form?['weight'] ??= '0';

    super.initState();
  }

  @override
  void dispose() {
    if (widget.form != null) {
      widget.form!.clear();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FinishProcessManual(
      title: 'Selesai Press',
      id: widget.id,
      data: widget.data,
      label: 'Press',
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      fetchWorkOrder: (service) => service.fetchPressFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      processService: _pressTumblerService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'press_id',
      processId: widget.processId,
      forDyeing: widget.forDyeing,
      withItemGrade: widget.withItemGrade,
      withQtyAndWeight: widget.withQtyAndWeight,
      forPacking: widget.forPacking,
    );
  }
}
