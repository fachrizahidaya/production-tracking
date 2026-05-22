// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/models/process/sorting.dart';
import 'package:textile_tracking/screens/detail/%5Bprocess_id%5D.dart';

class SortingDetail extends StatefulWidget {
  final String id;
  final String no;
  final canDelete;
  final canUpdate;

  const SortingDetail(
      {super.key,
      required this.id,
      required this.no,
      this.canDelete,
      this.canUpdate});

  @override
  State<SortingDetail> createState() => _SortingDetailState();
}

class _SortingDetailState extends State<SortingDetail> {
  final SortingService _sortingService = SortingService();

  @override
  Widget build(BuildContext context) {
    return ProcessDetail<Sorting>(
      id: widget.id,
      no: widget.no,
      label: 'Sorting',
      prefix: 'SRT',
      service: Provider.of<SortingService>(context, listen: false),
      handleUpdateService: (context, id, item, isLoading) =>
          Provider.of<SortingService>(context, listen: false)
              .updateItem(context, id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<SortingService>(context, listen: false)
              .deleteItem(context, id, isLoading),
      modelBuilder: (form, data) => Sorting(
          wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
          weight_unit_id:
              int.tryParse(form['weight_unit_id']?.toString() ?? ''),
          unit_id: int.tryParse(form['unit_id']?.toString() ?? ''),
          machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
          qty: form['qty'] ?? data['qty'],
          weight: form['weight'] ?? data['weight'],
          notes: form['notes'] ?? data['notes'],
          attachments: [
            ...List<Map<String, dynamic>>.from(data['attachments'] ?? []),
            ...List<Map<String, dynamic>>.from(form['attachments'] ?? []),
          ],
          grades: form['grades'] ?? data['grades'],
          greige_item_id:
              int.tryParse(form['greige_item_id']?.toString() ?? ''),
          defects: form['defects'] ?? data['defects'],
          combing: form['combing'] ?? data['combing'],
          spraying: form['spraying'] ?? data['spraying'],
          rework_long_hemming:
              form['rework_long_hemming'] ?? data['rework_long_hemming'],
          items: form['items'] ?? data['items']),
      canDelete: widget.canDelete,
      canUpdate: widget.canUpdate,
      route: '/sortings',
      withItemGrade: true,
      withMaklon: false,
      forDyeing: false,
      idProcess: 'sorting_id',
      processService: _sortingService,
      forPacking: false,
      fetchFinish: (service) => service.fetchSortingFinishOptions(),
      fetchItemGrade: (service) => service.fetchOptions(),
      getItemGradeOptions: (service) => service.dataListOption,
      getWorkOrderOptions: (service) => service.dataListOption,
      handleSubmitToService: (context, id, form, isLoading) async {
        final sorting = Sorting(
            wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
            machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
            weight_unit_id:
                int.tryParse(form['weight_unit_id']?.toString() ?? '2'),
            notes: form['notes'],
            start_time: form['start_time'],
            end_time: form['end_time'],
            start_by_id: int.tryParse(form['start_by_id']?.toString() ?? ''),
            end_by_id: int.tryParse(form['end_by_id']?.toString() ?? ''),
            attachments: form['attachments'],
            grades: form['grades'],
            defects: form['defects'],
            rework_long_hemming: form['rework_long_hemming'],
            spraying: form['spraying'],
            combing: form['combing'],
            greige_item_id:
                int.tryParse(form['greige_item_id']?.toString() ?? ''),
            items: form['items']);

        final message =
            await Provider.of<SortingService>(context, listen: false)
                .finishItem(context, id, sorting, isLoading);

        Navigator.pushNamedAndRemoveUntil(context, '/sortings', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Sortir Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "SRT",
              ));
        });
      },
    );
  }
}
