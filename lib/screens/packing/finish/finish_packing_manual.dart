import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/finish/%5Bfinish_process_id%5D.dart';
import 'package:textile_tracking/models/process/packing.dart';

class FinishPackingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;
  final processId;

  const FinishPackingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput,
      this.processId});

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
      label: 'Packing',
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      fetchWorkOrder: (service) => service.fetchPackingFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      processService: _packingService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'packing_id',
      withItemGrade: true,
      withQtyAndWeight: false,
      forDyeing: false,
      fetchItemGrade: (service) => service.fetchOptions(),
      getItemGradeOptions: (service) => service.dataListOption,
      processId: widget.processId,
      forPacking: true,
    );
  }
}
