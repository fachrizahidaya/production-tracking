import 'package:flutter/material.dart';
import 'package:textile_tracking/models/process/press_tumbler.dart';
import 'package:textile_tracking/screens/create/create_process_manual.dart';
import 'package:textile_tracking/screens/sizing/model/sizing.dart';

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
    );
  }
}
