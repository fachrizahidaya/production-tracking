import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/master/finish_process_manual.dart';
import 'package:textile_tracking/models/process/stenter.dart';

class FinishStenterManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;
  final processId;

  const FinishStenterManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput,
      this.processId});

  @override
  State<FinishStenterManual> createState() => _FinishStenterManualState();
}

class _FinishStenterManualState extends State<FinishStenterManual> {
  final StenterService _stenterService = StenterService();

  @override
  void initState() {
    widget.form?['length'] ??= '0';
    widget.form?['width'] ??= '0';
    widget.form?['weight'] ??= '0';

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FinishProcessManual(
      title: 'Selesai Stenter',
      id: widget.id,
      label: 'Stenter',
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      fetchWorkOrder: (service) => service.fetchStenterFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      processService: _stenterService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'stenter_id',
      withItemGrade: false,
      processId: widget.processId,
      withQtyAndWeight: false,
      forDyeing: false,
    );
  }
}
