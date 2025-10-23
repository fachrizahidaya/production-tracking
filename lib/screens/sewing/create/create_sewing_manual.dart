import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/service/create_process_manual.dart';

class CreateSewingManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;

  const CreateSewingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _maklonController = TextEditingController();

    return CreateProcessManual(
      title: 'Mulai Sewing',
      id: id,
      data: data,
      form: form,
      maklon: _maklonController,
      isMaklon: true,
      handleSubmit: handleSubmit,
      machineFilterValue: '2',
      fetchWorkOrder: (service) => service.fetchSewingOptions(),
      getWorkOrderOptions: (service) => service.dataListSewing,
      fetchMachine: (service) => service.fetchOptionsSewing(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
