import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/service/finish_process_manual.dart';
import 'package:textile_tracking/models/process/sewing.dart';

class FinishSewingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;

  const FinishSewingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput});

  @override
  State<FinishSewingManual> createState() => _FinishSewingManualState();
}

class _FinishSewingManualState extends State<FinishSewingManual> {
  final SewingService _sewingService = SewingService();

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
      title: 'Selesai Sewing',
      id: widget.id,
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      machineFilterValue: '2',
      fetchWorkOrder: (service) => service.fetchSewingFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      processService: _sewingService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'sewing_id',
    );
  }
}
