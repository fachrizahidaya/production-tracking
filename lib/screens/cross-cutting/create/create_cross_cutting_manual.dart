import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/service/create_process_manual.dart';

class CreateCrossCuttingManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;

  const CreateCrossCuttingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder});

  @override
  Widget build(BuildContext context) {
    return CreateProcessManual(
      title: 'Mulai Cross Cutting',
      id: id,
      data: data,
      form: form,
      handleSubmit: handleSubmit,
      machineFilterValue: '2',
      fetchWorkOrder: (service) => service.fetchCrossCuttingOptions(),
      getWorkOrderOptions: (service) => service.dataListCrossCutting,
      fetchMachine: (service) => service.fetchOptionsCrossCutting(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
