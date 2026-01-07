import 'package:flutter/material.dart';
import 'package:textile_tracking/models/process/stenter.dart';
import 'package:textile_tracking/screens/master/create_process_manual.dart';

class CreateStenterManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final processId;

  const CreateStenterManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.processId});

  @override
  Widget build(BuildContext context) {
    final StenterService stenterService = StenterService();

    return CreateProcessManual(
      title: 'Mulai Stenter',
      id: id,
      label: 'Stenter',
      data: data,
      form: form,
      processId: processId,
      idProcess: 'stenter_id',
      processService: stenterService,
      handleSubmit: handleSubmit,
      fetchWorkOrder: (service) => service.fetchStenterOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsStenter(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
