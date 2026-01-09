import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/master/finish/%5Bfinish_process_id%5D.dart';
import 'package:textile_tracking/models/process/printing.dart';

class FinishPrintingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;
  final processId;

  const FinishPrintingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput,
      this.processId});

  @override
  State<FinishPrintingManual> createState() => _FinishPrintingManualState();
}

class _FinishPrintingManualState extends State<FinishPrintingManual> {
  final PrintingService _printingService = PrintingService();

  @override
  void initState() {
    widget.form?['length'] ??= '0';
    widget.form?['width'] ??= '0';

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FinishProcessManual(
      title: 'Selesai Printing',
      id: widget.id,
      label: 'Printing',
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      fetchWorkOrder: (service) => service.fetchPrintingFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      processService: _printingService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'printing_id',
      withItemGrade: false,
      withQtyAndWeight: true,
      forDyeing: false,
      processId: widget.processId,
    );
  }
}
