// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/service/finish_process_manual.dart';
import 'package:textile_tracking/models/process/tumbler.dart';

class FinishTumblerManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;
  final processId;

  const FinishTumblerManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput,
      this.processId});

  @override
  State<FinishTumblerManual> createState() => _FinishTumblerManualState();
}

class _FinishTumblerManualState extends State<FinishTumblerManual> {
  final TumblerService _tumblerService = TumblerService();

  @override
  void initState() {
    widget.form?['length'] ??= '0';
    widget.form?['width'] ??= '0';
    widget.form?['length_unit_id'] ??= 4;
    widget.form?['width_unit_id'] ??= 4;

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
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      fetchWorkOrder: (service) => service.fetchTumblerFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      processService: _tumblerService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'tumbler_id',
      withItemGrade: false,
      processId: widget.processId,
    );
  }
}
