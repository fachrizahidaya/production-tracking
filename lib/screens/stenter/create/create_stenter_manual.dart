import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/master/create_process_manual.dart';

class CreateStenterManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;

  const CreateStenterManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder});

  @override
  Widget build(BuildContext context) {
    return CreateProcessManual(
      title: 'Mulai Stenter',
      id: id,
      label: 'Stenter',
      data: data,
      form: form,
      handleSubmit: handleSubmit,
      fetchWorkOrder: (service) => service.fetchStenterOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsStenter(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
