import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/finish/%5Bfinish_process_id%5D.dart';
import 'package:textile_tracking/models/process/sorting.dart';

class FinishSortingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;
  final processId;
  final forPacking;
  final withItemGrade;
  final withQtyAndWeight;
  final forDyeing;
  final finishedItemOptions;

  const FinishSortingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput,
      this.processId,
      this.forDyeing,
      this.forPacking,
      this.withItemGrade,
      this.withQtyAndWeight,
      this.finishedItemOptions});

  @override
  State<FinishSortingManual> createState() => _FinishSortingManualState();
}

class _FinishSortingManualState extends State<FinishSortingManual> {
  final SortingService _sortingService = SortingService();

  Map<String, dynamic>? get woData => widget.form?['wo_data'];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FinishProcessManual(
      title: 'Selesai Sortir',
      id: widget.id,
      label: 'Sorting',
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      fetchWorkOrder: (service) => service.fetchSortingFinishOptions(),
      fetchFinishItem: (service) => service.fetchOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      getFinishedItemOptions: (service) => service.dataListOption,
      processService: _sortingService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'sorting_id',
      withItemGrade: widget.withItemGrade,
      withQtyAndWeight: widget.withQtyAndWeight,
      forDyeing: widget.forDyeing,
      fetchItemGrade: (service) => service.fetchOptions(),
      getItemGradeOptions: (service) => service.dataListOption,
      processId: widget.processId,
      finishedItemOptions: widget.finishedItemOptions,
    );
  }
}
