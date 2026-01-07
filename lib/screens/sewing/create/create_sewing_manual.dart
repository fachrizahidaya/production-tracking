// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:textile_tracking/models/process/sewing.dart';
import 'package:textile_tracking/screens/master/create_process_manual.dart';

class CreateSewingManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final processId;

  const CreateSewingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.processId});

  @override
  Widget build(BuildContext context) {
    final SewingService sewingService = SewingService();

    final TextEditingController _maklonController = TextEditingController();

    return CreateProcessManual(
      title: 'Mulai Sewing',
      id: id,
      label: 'Sewing',
      data: data,
      form: form,
      processId: processId,
      idProcess: 'sewing_id',
      processService: sewingService,
      maklon: _maklonController,
      isMaklon: true,
      handleSubmit: handleSubmit,
      fetchWorkOrder: (service) => service.fetchSewingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsSewing(),
      getMachineOptions: (service) => service.dataListOption,
      withMaklonOrMachine: true,
    );
  }
}
