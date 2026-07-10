import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:textile_tracking/screens/sizing/create/create_sizing_process_manual.dart';
=======
import 'package:textile_tracking/models/process/press_tumbler.dart';
import 'package:textile_tracking/screens/create/create_process_manual.dart';
import 'package:textile_tracking/screens/sizing/model/sizing.dart';
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
    return CreateSizingProcessManual(
      id: id,
      data: data,
      processId: processId,
      form: form,
      handleSubmit: handleSubmit,
=======
    final SizingService sizingService = SizingService();
    final PressTumblerService pressService = PressTumblerService();

    return CreateProcessManual(
      title: 'Mulai Sizing',
      label: 'Sizing',
      id: id,
      data: data,
      form: form,
      processId: processId,
      processService: sizingService,
      idProcess: 'sizing_id',
      handleSubmit: handleSubmit,
      fetchWorkOrder: (service) => service.fetchSizingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsSizing(),
      getMachineOptions: (service) => service.dataListOption,
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
    );
  }
}
