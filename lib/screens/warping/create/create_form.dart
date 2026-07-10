import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/create/create_process_manual.dart';
import 'package:textile_tracking/screens/warping/model/warping.dart';

class CreateForm extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final processId;

  const CreateForm(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.processId});

  @override
  Widget build(BuildContext context) {
    final WarpingService warpingService = WarpingService();

    return CreateProcessManual(
      title: 'Mulai Warping',
      label: 'Warping',
      id: id,
      data: data,
      form: form,
      processId: processId,
      processService: warpingService,
      idProcess: 'warping_id',
      handleSubmit: handleSubmit,
      fetchWorkOrder: (service) => service.fetchWarpingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsWarping(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
