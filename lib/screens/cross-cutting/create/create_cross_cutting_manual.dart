import 'package:flutter/material.dart';
import 'package:textile_tracking/models/process/cross_cutting.dart';
import 'package:textile_tracking/screens/master/create/create_process_manual.dart';

class CreateCrossCuttingManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final processId;

  const CreateCrossCuttingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.processId});

  @override
  Widget build(BuildContext context) {
    final CrossCuttingService crossCuttingService = CrossCuttingService();

    return CreateProcessManual(
      title: 'Mulai Cross Cutting',
      id: id,
      label: 'Cross Cutting',
      data: data,
      form: form,
      processId: processId,
      idProcess: 'cross_cutting_id',
      processService: crossCuttingService,
      handleSubmit: handleSubmit,
      fetchWorkOrder: (service) => service.fetchCrossCuttingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsCrossCutting(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
