import 'package:flutter/material.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/screens/shearing/create/create_shearing_process_manual.dart';
=======
import 'package:textile_tracking/screens/create/create_process_manual.dart';
=======
import 'package:textile_tracking/screens/create/create_greige_order_process_manual.dart';
>>>>>>> a1ea7df (feat: warping)
import 'package:textile_tracking/screens/shearing/model/shearing.dart';
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
    return CreateShearingProcessManual(
      id: id,
      data: data,
      processId: processId,
      form: form,
      handleSubmit: handleSubmit,
=======
    final ShearingService shearingService = ShearingService();

    return CreateGreigeOrderProcessManual(
      title: 'Mulai Shearing',
      label: 'Shearing',
      id: id,
      data: data,
      form: form,
      processId: processId,
      processService: shearingService,
      idProcess: 'shearing_id',
      handleSubmit: handleSubmit,
      fetchGreigeOrder: (service) => service.fetchShearingOptions(),
      getGreigeOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsShearing(),
      getMachineOptions: (service) => service.dataListOption,
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
    );
  }
}
