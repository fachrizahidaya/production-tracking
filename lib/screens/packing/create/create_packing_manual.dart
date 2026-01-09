import 'package:flutter/material.dart';
import 'package:textile_tracking/models/process/packing.dart';
import 'package:textile_tracking/screens/create/create_process_manual.dart';

class CreatePackingManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final processId;

  const CreatePackingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.processId});

  @override
  Widget build(BuildContext context) {
    final PackingService packingService = PackingService();

    return CreateProcessManual(
      title: 'Mulai Packing',
      id: id,
      label: 'Packing',
      data: data,
      form: form,
      processId: processId,
      idProcess: 'packing_id',
      processService: packingService,
      handleSubmit: handleSubmit,
      fetchWorkOrder: (service) => service.fetchPackingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      withNoMaklonOrMachine: true,
    );
  }
}
