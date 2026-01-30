import 'package:flutter/material.dart';
import 'package:textile_tracking/models/process/printing.dart';
import 'package:textile_tracking/screens/create/create_process_manual.dart';

class CreatePrintingManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final processId;
  final withOnlyMaklon;

  const CreatePrintingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.processId,
      this.withOnlyMaklon});

  @override
  Widget build(BuildContext context) {
    final PrintingService printingService = PrintingService();

    return CreateProcessManual(
      title: 'Mulai Printing',
      id: id,
      label: 'Printing',
      data: data,
      form: form,
      processId: processId,
      idProcess: 'printing_id',
      processService: printingService,
      handleSubmit: handleSubmit,
      fetchWorkOrder: (service) => service.fetchPrintingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      withOnlyMaklon: withOnlyMaklon,
    );
  }
}
