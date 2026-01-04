import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/master/finish_process_manual.dart';
import 'package:textile_tracking/models/process/embroidery.dart';

class FinishEmbroideryManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;
  final processId;

  const FinishEmbroideryManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput,
      this.processId});

  @override
  State<FinishEmbroideryManual> createState() => _FinishEmbroideryManualState();
}

class _FinishEmbroideryManualState extends State<FinishEmbroideryManual> {
  final EmbroideryService _embroideryService = EmbroideryService();

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
      withItemGrade: false,
      withQtyAndWeight: true,
      forDyeing: false,
      processId: widget.processId,
    );
  }
}
