// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/models/process/dyeing.dart';
import 'package:textile_tracking/screens/master/create_process_manual.dart';

class CreateDyeingManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final processId;

  const CreateDyeingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.processId});

  @override
  Widget build(BuildContext context) {
    final DyeingService dyeingService = DyeingService();

    return CreateProcessManual(
      title: 'Mulai Dyeing',
      id: id,
      label: 'Dyeing',
      data: data,
      form: form,
      processId: processId,
      idProcess: 'dyeing_id',
      processService: dyeingService,
      handleSubmit: handleSubmit,
      fetchWorkOrder: (service) => service.fetchOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsDyeing(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
