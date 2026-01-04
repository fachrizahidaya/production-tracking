import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/master/finish_process_manual.dart';
import 'package:textile_tracking/models/process/cross_cutting.dart';

class FinishCrossCuttingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;
  final processId;

  const FinishCrossCuttingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput,
      this.processId});

  @override
  State<FinishCrossCuttingManual> createState() =>
      _FinishCrossCuttingManualState();
}

class _FinishCrossCuttingManualState extends State<FinishCrossCuttingManual> {
  final CrossCuttingService _crossCuttingService = CrossCuttingService();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FinishProcessManual(
      title: 'Selesai Cross Cutting',
      id: widget.id,
      label: 'Cross Cutting',
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      fetchWorkOrder: (service) => service.fetchCuttingFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      processService: _crossCuttingService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'cross_cutting_id',
      withItemGrade: false,
      withQtyAndWeight: true,
      processId: widget.processId,
    );
  }
}
