import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/service/create_process_manual.dart';

class CreateEmborideryManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;

  const CreateEmborideryManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder});

  @override
  Widget build(BuildContext context) {
    return CreateProcessManual(
      title: 'Mulai Embroidery',
      id: id,
      data: data,
      form: form,
      handleSubmit: handleSubmit,
      machineFilterValue: '2',
      fetchWorkOrder: (service) => service.fetchEmbroideryOptions(),
      getWorkOrderOptions: (service) => service.dataListEmbroidery,
      fetchMachine: (service) => service.fetchOptionsEmbroidery(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
