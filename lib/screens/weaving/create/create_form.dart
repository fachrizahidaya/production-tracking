import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/create/create_process_manual.dart';
import 'package:textile_tracking/screens/weaving/model/weaving.dart';

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
    final WeavingService weavingService = WeavingService();

    return CreateProcessManual(
      title: 'Mulai Weaving',
      label: 'Weaving',
      id: id,
      data: data,
      form: form,
      processId: processId,
      processService: weavingService,
      idProcess: 'weaving_id',
      handleSubmit: handleSubmit,
      fetchWorkOrder: (service) => service.fetchWeavingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsWeaving(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
