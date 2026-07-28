import 'package:flutter/material.dart';
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/screens/sizing/create/create_sizing_process_manual.dart';
=======
import 'package:textile_tracking/models/process/press_tumbler.dart';
=======
>>>>>>> bb29b60 (fix: clear warning)
import 'package:textile_tracking/screens/create/create_process_manual.dart';
import 'package:textile_tracking/screens/sizing/model/sizing.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
import 'package:textile_tracking/screens/sizing/create/create_sizing_process_manual.dart';
>>>>>>> 5d1f483f (fix: warping, sizing)

class CreateForm extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
<<<<<<< HEAD
<<<<<<< HEAD
=======
  final fetchWorkOrder;
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
>>>>>>> 5d1f483f (fix: warping, sizing)
  final processId;

  const CreateForm(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
<<<<<<< HEAD
<<<<<<< HEAD
=======
      this.fetchWorkOrder,
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
>>>>>>> 5d1f483f (fix: warping, sizing)
      this.processId});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
<<<<<<< HEAD
    return CreateSizingProcessManual(
      id: id,
      data: data,
      processId: processId,
      form: form,
      handleSubmit: handleSubmit,
=======
    final SizingService sizingService = SizingService();

    return CreateProcessManual(
      title: 'Mulai Sizing',
      label: 'Sizing',
=======
    return CreateSizingProcessManual(
>>>>>>> 5d1f483f (fix: warping, sizing)
      id: id,
      data: data,
      processId: processId,
      form: form,
      handleSubmit: handleSubmit,
<<<<<<< HEAD
      fetchWorkOrder: (service) => service.fetchSizingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsSizing(),
      getMachineOptions: (service) => service.dataListOption,
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
>>>>>>> 5d1f483f (fix: warping, sizing)
    );
  }
}
