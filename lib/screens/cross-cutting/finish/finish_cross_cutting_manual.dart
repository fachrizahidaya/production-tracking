import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/finish/%5Bfinish_process_id%5D.dart';
import 'package:textile_tracking/models/process/cross_cutting.dart';

class FinishCrossCuttingManual extends StatefulWidget {
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

  const FinishCrossCuttingManual(
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
  State<FinishCrossCuttingManual> createState() =>
      _FinishCrossCuttingManualState();
}

class _FinishCrossCuttingManualState extends State<FinishCrossCuttingManual> {
  final CrossCuttingService _crossCuttingService = CrossCuttingService();

  @override
  void initState() {
    widget.form?['length'] ??= '0';
    widget.form?['width'] ??= '0';
    widget.form?['item_qty'] ??= '0';
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
      forDyeing: widget.forDyeing,
      withItemGrade: widget.withItemGrade,
      withQtyAndWeight: widget.withQtyAndWeight,
      forPacking: widget.forPacking,
      processId: widget.processId,
    );
  }
}
