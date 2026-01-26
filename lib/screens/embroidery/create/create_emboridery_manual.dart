import 'package:flutter/material.dart';
import 'package:textile_tracking/models/process/embroidery.dart';
import 'package:textile_tracking/screens/create/create_process_manual.dart';

class CreateEmborideryManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final processId;
  final withOnlyMaklon;

  const CreateEmborideryManual(
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
    final EmbroideryService embroideryService = EmbroideryService();

    return CreateProcessManual(
      title: 'Mulai Embroidery',
      id: id,
      label: 'Embroidery',
      data: data,
      form: form,
      processId: processId,
      idProcess: 'embroidery_id',
      processService: embroideryService,
      handleSubmit: handleSubmit,
      fetchWorkOrder: (service) => service.fetchEmbroideryOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      withOnlyMaklon: withOnlyMaklon,
    );
  }
}
