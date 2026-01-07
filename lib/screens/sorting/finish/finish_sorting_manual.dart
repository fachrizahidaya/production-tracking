import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/master/finish_process_manual.dart';
import 'package:textile_tracking/models/process/sorting.dart';

class FinishSortingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;
  final processId;

  const FinishSortingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput,
      this.processId});

  @override
  State<FinishSortingManual> createState() => _FinishSortingManualState();
}

class _FinishSortingManualState extends State<FinishSortingManual> {
  final SortingService _sortingService = SortingService();

  @override
  void initState() {
    widget.form?['length'] ??= '0';
    widget.form?['width'] ??= '0';

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FinishProcessManual(
      title: 'Selesai Sorting',
      id: widget.id,
      label: 'Sorting',
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      fetchWorkOrder: (service) => service.fetchSortingFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      processService: _sortingService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'sorting_id',
      withItemGrade: true,
      withQtyAndWeight: false,
      forDyeing: false,
      fetchItemGrade: (service) => service.fetchOptions(),
      getItemGradeOptions: (service) => service.dataListOption,
      processId: widget.processId,
    );
  }
}
