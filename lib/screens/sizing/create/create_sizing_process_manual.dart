import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/create/create_greige_order_process_manual.dart';
import 'package:textile_tracking/screens/sizing/model/sizing.dart';

class CreateSizingProcessManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final processId;

  const CreateSizingProcessManual({
    super.key,
    this.id,
    this.data,
    this.form,
    this.handleSubmit,
    this.processId,
  });

  @override
  Widget build(BuildContext context) {
    final SizingService sizingService = SizingService();

    return CreateGreigeOrderProcessManual(
      title: 'Mulai Sizing',
      label: 'Sizing',
      id: id,
      data: data,
      form: form,
      processId: processId,
      processService: sizingService,
      idProcess: 'sizing_id',
      handleSubmit: handleSubmit,
      fetchGreigeOrder: (service) => service.fetchSizingOptions(),
      getGreigeOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsSizing(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
