import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/finish/%5Bfinish_process_id%5D.dart';
import 'package:textile_tracking/models/process/stenter.dart';

class FinishStenterManual extends StatefulWidget {
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

  const FinishStenterManual(
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
      processId: widget.processId,
      forDyeing: widget.forDyeing,
      withItemGrade: widget.withItemGrade,
      withQtyAndWeight: widget.withQtyAndWeight,
      forPacking: widget.forPacking,
    );
  }
}
