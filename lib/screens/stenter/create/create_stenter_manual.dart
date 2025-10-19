import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/service/create_process_manual.dart';

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
      data: data,
      form: form,
      handleSubmit: handleSubmit,
      machineFilterValue: '2',
      fetchWorkOrder: (service) => service.fetchStenterOptions(),
      getWorkOrderOptions: (service) => service.dataListStenter,
    );
  }
}
