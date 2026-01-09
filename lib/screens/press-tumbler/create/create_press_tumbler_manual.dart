import 'package:flutter/material.dart';
import 'package:textile_tracking/models/process/press_tumbler.dart';
import 'package:textile_tracking/screens/master/create/create_process_manual.dart';

class CreatePressTumblerManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final processId;

  const CreatePressTumblerManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.processId});

  @override
  Widget build(BuildContext context) {
    final PressTumblerService pressService = PressTumblerService();

    return CreateProcessManual(
      title: 'Mulai Press',
      label: 'Press',
      id: id,
      data: data,
      form: form,
      processId: processId,
      processService: pressService,
      idProcess: 'press_id',
      handleSubmit: handleSubmit,
      fetchWorkOrder: (service) => service.fetchPressTumblerOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsPressTumbler(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
