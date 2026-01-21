import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/finish/%5Bfinish_process_id%5D.dart';
import 'package:textile_tracking/models/process/embroidery.dart';

class FinishEmbroideryManual extends StatefulWidget {
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

  const FinishEmbroideryManual(
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
  State<FinishEmbroideryManual> createState() => _FinishEmbroideryManualState();
}

class _FinishEmbroideryManualState extends State<FinishEmbroideryManual> {
  final EmbroideryService _embroideryService = EmbroideryService();

  @override
  void initState() {
    widget.form?['length'] ??= '0';
    widget.form?['width'] ??= '0';
    widget.form?['weight'] ??= '0';
    widget.form?['item_qty'] ??= '0';

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FinishProcessManual(
      title: 'Selesai Embroidery',
      id: widget.id,
      label: 'Embroidery',
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      fetchWorkOrder: (service) => service.fetchEmbroideryFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      processService: _embroideryService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'embroidery_id',
      forDyeing: widget.forDyeing,
      withItemGrade: widget.withItemGrade,
      withQtyAndWeight: widget.withQtyAndWeight,
      forPacking: widget.forPacking,
      processId: widget.processId,
    );
  }
}
