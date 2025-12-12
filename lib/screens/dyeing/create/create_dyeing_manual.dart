// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/service/create_process_manual.dart';

class CreateDyeingManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;

  const CreateDyeingManual({
    super.key,
    this.id,
    this.data,
    this.form,
    this.handleSubmit,
    this.fetchWorkOrder,
  });

  @override
  Widget build(BuildContext context) {
    return CreateProcessManual(
      title: 'Mulai Dyeing',
      id: id,
      data: data,
      form: form,
      handleSubmit: handleSubmit,
      machineFilterValue: '2',
      fetchWorkOrder: (service) => service.fetchOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsDyeing(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
