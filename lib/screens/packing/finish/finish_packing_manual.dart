import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/service/finish_process_manual.dart';
import 'package:textile_tracking/models/process/packing.dart';

class FinishPackingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;

  const FinishPackingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput});

  @override
  State<FinishPackingManual> createState() => _FinishPackingManualState();
}

class _FinishPackingManualState extends State<FinishPackingManual> {
  final PackingService _packingService = PackingService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FinishProcessManual(
      title: 'Selesai Packing',
      id: widget.id,
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      machineFilterValue: '2',
      fetchWorkOrder: (service) => service.fetchStenterFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      processService: _packingService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'packing_id',
    );
  }
}
