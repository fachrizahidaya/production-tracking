import 'package:flutter/material.dart';
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/screens/weaving/create/create_weaving_process_manual.dart';
=======
import 'package:textile_tracking/screens/create/create_process_manual.dart';
=======
import 'package:textile_tracking/screens/create/create_greige_order_process_manual.dart';
>>>>>>> a1ea7df (feat: warping)
import 'package:textile_tracking/screens/weaving/model/weaving.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
import 'package:textile_tracking/screens/weaving/create/create_weaving_process_manual.dart';
>>>>>>> 95d1a035 (fix: weaving, shearing)

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
>>>>>>> 95d1a035 (fix: weaving, shearing)
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
>>>>>>> 95d1a035 (fix: weaving, shearing)
      this.processId});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
<<<<<<< HEAD
    return CreateWeavingProcessManual(
      id: id,
      data: data,
      processId: processId,
      form: form,
      handleSubmit: handleSubmit,
=======
    final WeavingService weavingService = WeavingService();

    return CreateGreigeOrderProcessManual(
      title: 'Mulai Weaving',
      label: 'Weaving',
=======
    return CreateWeavingProcessManual(
>>>>>>> 95d1a035 (fix: weaving, shearing)
      id: id,
      data: data,
      processId: processId,
      form: form,
      handleSubmit: handleSubmit,
<<<<<<< HEAD
      fetchGreigeOrder: (service) => service.fetchWeavingOptions(),
      getGreigeOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsWeaving(),
      getMachineOptions: (service) => service.dataListOption,
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
>>>>>>> 95d1a035 (fix: weaving, shearing)
    );
  }
}
