import 'package:flutter/material.dart';
import 'package:textile_tracking/models/process/sorting.dart';
import 'package:textile_tracking/screens/create/create_process_manual.dart';

class CreateSortingManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final processId;

  const CreateSortingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.processId});

  @override
  Widget build(BuildContext context) {
    final SortingService sortingService = SortingService();

    return CreateProcessManual(
      title: 'Mulai Sorting',
      id: id,
      label: 'Sorting',
      data: data,
      form: form,
      processId: processId,
      idProcess: 'sorting_id',
      processService: sortingService,
      handleSubmit: handleSubmit,
      fetchWorkOrder: (service) => service.fetchSortingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      withNoMaklonOrMachine: true,
    );
  }
}
