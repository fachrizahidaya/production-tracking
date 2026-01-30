// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/finish/%5Bfinish_process_id%5D.dart';
import 'package:textile_tracking/models/process/tumbler.dart';

class FinishTumblerManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;
  final processId;
  final forPacking;
  final withItemGrade;
  final withQtyAndWeight;
  final forDyeing;

  const FinishTumblerManual(
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
  State<FinishTumblerManual> createState() => _FinishTumblerManualState();
}

class _FinishTumblerManualState extends State<FinishTumblerManual> {
  final TumblerService _tumblerService = TumblerService();

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
      title: 'Selesai Tumbler',
      id: widget.id,
      label: 'Tumbler',
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      fetchWorkOrder: (service) => service.fetchTumblerFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      processService: _tumblerService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'tumbler_id',
      processId: widget.processId,
      forDyeing: widget.forDyeing,
      withItemGrade: widget.withItemGrade,
      withQtyAndWeight: widget.withQtyAndWeight,
      forPacking: widget.forPacking,
    );
  }
}
