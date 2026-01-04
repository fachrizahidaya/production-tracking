import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/master/create_process_manual.dart';

class CreatePressTumblerManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;

  const CreatePressTumblerManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder});

  @override
  Widget build(BuildContext context) {
    return CreateProcessManual(
      title: 'Mulai Press',
      label: 'Press',
      id: id,
      data: data,
      form: form,
      handleSubmit: handleSubmit,
      fetchWorkOrder: (service) => service.fetchPressTumblerOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsPressTumbler(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
