import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/create/create_greige_order_process_manual.dart';
import 'package:textile_tracking/screens/weaving/model/weaving.dart';

class CreateWeavingProcessManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final processId;

  const CreateWeavingProcessManual({
    super.key,
    this.id,
    this.data,
    this.form,
    this.handleSubmit,
    this.processId,
  });

  @override
  Widget build(BuildContext context) {
    final WeavingService weavingService = WeavingService();

    return CreateGreigeOrderProcessManual(
      title: 'Mulai Weaving',
      label: 'Weaving',
      id: id,
      data: data,
      form: form,
      processId: processId,
      processService: weavingService,
      idProcess: 'weaving_id',
      handleSubmit: handleSubmit,
      fetchGreigeOrder: (service) => service.fetchWeavingOptions(),
      getGreigeOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsWeaving(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
