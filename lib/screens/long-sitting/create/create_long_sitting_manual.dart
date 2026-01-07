import 'package:flutter/material.dart';
import 'package:textile_tracking/models/process/long_sitting.dart';
import 'package:textile_tracking/screens/master/create_process_manual.dart';

class CreateLongSittingManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final processId;

  const CreateLongSittingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.processId});

  @override
  Widget build(BuildContext context) {
    final LongSittingService longSittingService = LongSittingService();

    return CreateProcessManual(
      title: 'Mulai Long Slitting',
      id: id,
      label: 'Long Slitting',
      data: data,
      form: form,
      processId: processId,
      idProcess: 'long_sitting_id',
      processService: longSittingService,
      handleSubmit: handleSubmit,
      fetchWorkOrder: (service) => service.fetchLongSittingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsLongSitting(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
