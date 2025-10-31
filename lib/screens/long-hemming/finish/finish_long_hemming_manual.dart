import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/service/finish_process_manual.dart';
import 'package:textile_tracking/models/process/long_hemming.dart';

class FinishLongHemmingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;

  const FinishLongHemmingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput});

  @override
  State<FinishLongHemmingManual> createState() =>
      _FinishLongHemmingManualState();
}

class _FinishLongHemmingManualState extends State<FinishLongHemmingManual> {
  final LongHemmingService _longHemmingService = LongHemmingService();

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
      title: 'Selesai Long Hemming',
      id: widget.id,
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      machineFilterValue: '2',
      fetchWorkOrder: (service) => service.fetchHemmingFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      processService: _longHemmingService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'long_hemming_id',
      withItemGrade: false,
    );
  }
}
