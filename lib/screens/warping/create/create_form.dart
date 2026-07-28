import 'package:flutter/material.dart';
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/screens/warping/create/create_warping_process_manual.dart';
=======
import 'package:textile_tracking/screens/create/create_process_manual.dart';
=======
import 'package:textile_tracking/screens/create/create_greige_order_process_manual.dart';
>>>>>>> a1ea7df (feat: warping)
import 'package:textile_tracking/screens/warping/model/warping.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
import 'package:textile_tracking/screens/warping/create/create_warping_process_manual.dart';
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
    return CreateWarpingProcessManual(
      id: id,
      data: data,
      processId: processId,
      form: form,
      handleSubmit: handleSubmit,
=======
    final WarpingService warpingService = WarpingService();

    return CreateGreigeOrderProcessManual(
      title: 'Mulai Warping',
      label: 'Warping',
=======
    return CreateWarpingProcessManual(
>>>>>>> 5d1f483f (fix: warping, sizing)
      id: id,
      data: data,
      processId: processId,
      form: form,
      handleSubmit: handleSubmit,
<<<<<<< HEAD
      fetchGreigeOrder: (service) => service.fetchWarpingOptions(),
      getGreigeOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsWarping(),
      getMachineOptions: (service) => service.dataListOption,
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
>>>>>>> 5d1f483f (fix: warping, sizing)
    );
  }
}
