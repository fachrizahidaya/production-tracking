import 'package:flutter/material.dart';
import 'package:textile_tracking/models/process/long_hemming.dart';
import 'package:textile_tracking/screens/master/create_process_manual.dart';

class CreateLongHemmingManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final processId;

  const CreateLongHemmingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.processId});

  @override
  Widget build(BuildContext context) {
    final LongHemmingService longHemmingService = LongHemmingService();

    return CreateProcessManual(
      title: 'Mulai Long Hemming',
      id: id,
      label: 'Long Hemming',
      data: data,
      form: form,
      processId: processId,
      idProcess: 'long_hemming_id',
      processService: longHemmingService,
      handleSubmit: handleSubmit,
      fetchWorkOrder: (service) => service.fetchLongHemmingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsLongHemming(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
