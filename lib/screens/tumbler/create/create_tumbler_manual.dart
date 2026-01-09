import 'package:flutter/material.dart';
import 'package:textile_tracking/models/process/tumbler.dart';
import 'package:textile_tracking/screens/master/create/create_process_manual.dart';

class CreateTumblerManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final processId;

  const CreateTumblerManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.processId});

  @override
  Widget build(BuildContext context) {
    final TumblerService tumblerService = TumblerService();

    return CreateProcessManual(
      title: 'Mulai Tumbler',
      id: id,
      label: 'Tumbler',
      data: data,
      form: form,
      processId: processId,
      idProcess: 'tumbler_id',
      processService: tumblerService,
      handleSubmit: handleSubmit,
      fetchWorkOrder: (service) => service.fetchTumblerOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsTumbler(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
