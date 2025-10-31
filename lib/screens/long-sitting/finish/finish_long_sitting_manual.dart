import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/service/finish_process_manual.dart';
import 'package:textile_tracking/models/process/long_sitting.dart';

class FinishLongSittingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;

  const FinishLongSittingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput});

  @override
  State<FinishLongSittingManual> createState() =>
      _FinishLongSittingManualState();
}

class _FinishLongSittingManualState extends State<FinishLongSittingManual> {
  final LongSittingService _longSittingService = LongSittingService();

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
      title: 'Selesai Long Sitting',
      id: widget.id,
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      machineFilterValue: '2',
      fetchWorkOrder: (service) => service.fetchSittingFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      processService: _longSittingService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'long_sitting_id',
      withItemGrade: false,
    );
  }
}
