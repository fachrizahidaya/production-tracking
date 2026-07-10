import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:textile_tracking/screens/weaving/create/create_weaving_process_manual.dart';
=======
import 'package:textile_tracking/screens/create/create_process_manual.dart';
import 'package:textile_tracking/screens/weaving/model/weaving.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)

class CreateForm extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
<<<<<<< HEAD
=======
  final fetchWorkOrder;
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
  final processId;

  const CreateForm(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
<<<<<<< HEAD
=======
      this.fetchWorkOrder,
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
      this.processId});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return CreateWeavingProcessManual(
      id: id,
      data: data,
      processId: processId,
      form: form,
      handleSubmit: handleSubmit,
=======
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
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
    );
  }
}
