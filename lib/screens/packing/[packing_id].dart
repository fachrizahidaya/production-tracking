// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/models/process/packing.dart';
import 'package:textile_tracking/screens/detail/%5Bprocess_id%5D.dart';

class PackingDetail extends StatefulWidget {
  final String id;
  final String no;
  final canDelete;
  final canUpdate;

  const PackingDetail(
      {super.key,
      required this.id,
      required this.no,
      this.canDelete,
      this.canUpdate});

  @override
  State<PackingDetail> createState() => _PackingDetailState();
}

class _PackingDetailState extends State<PackingDetail> {
  final PackingService _packingService = PackingService();

  @override
  Widget build(BuildContext context) {
    return ProcessDetail<Packing>(
      id: widget.id,
      no: widget.no,
      label: 'Packing',
      prefix: 'PCK',
      service: Provider.of<PackingService>(context, listen: false),
      handleUpdateService: (context, id, item, isLoading) =>
          Provider.of<PackingService>(context, listen: false)
              .updateItemPacking(context, id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<PackingService>(context, listen: false)
              .deleteItem(context, id, isLoading),
      modelBuilder: (form, data) => Packing(
          wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
          notes: form['notes'] ?? data['notes'],
          attachments: form['attachments'] ?? data['attachments'],
          grades: form['grades'] ?? data['grades'],
          unit_id: int.tryParse(form['unit_id']?.toString() ?? ''),
          qty: form['qty'] ?? data['qty'],
          gsm: form['gsm'] ?? data['gsm'],
          total_weight: form['total_weight'] ?? data['total_weight'],
          weight_per_dozen:
              form['weight_per_dozen'] ?? data['weight_per_dozen'],
          weight_grade_a: form['weight_grade_a'] ?? data['weight_grade_a'],
          greige_item_id:
              int.tryParse(form['greige_item_id']?.toString() ?? '')),
      canDelete: widget.canDelete,
      canUpdate: widget.canUpdate,
      route: '/packings',
      withItemGrade: true,
      withMaklon: false,
      forDyeing: false,
      idProcess: 'packing_id',
      processService: _packingService,
      forPacking: true,
      fetchFinish: (service) => service.fetchPackingFinishOptions(),
      fetchItemGrade: (service) => service.fetchOptions(),
      getItemGradeOptions: (service) => service.dataListOption,
      getWorkOrderOptions: (service) => service.dataListOption,
      handleSubmitToService: (context, id, form, isLoading) async {
        final packing = Packing(
          wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
          notes: form['notes'],
          start_time: form['start_time'],
          end_time: form['end_time'],
          start_by_id: int.tryParse(form['start_by_id']?.toString() ?? ''),
          end_by_id: int.tryParse(form['end_by_id']?.toString() ?? ''),
          attachments: form['attachments'],
          grades: form['grades'],
          weight_per_dozen: form['weight_per_dozen'],
          gsm: form['gsm'],
          total_weight: form['total_weight'],
          qty: form['qty'],
          unit_id: int.tryParse(form['unit_id']?.toString() ?? '1'),
          greige_item_id:
              int.tryParse(form['greige_item_id']?.toString() ?? ''),
          weight_grade_a: form['weight_grade_a'],
        );

        final message =
            await Provider.of<PackingService>(context, listen: false)
                .finishItem(context, id, packing, isLoading);

        Navigator.pushNamedAndRemoveUntil(context, '/packings', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Packing Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "PCK",
              ));
        });
      },
    );
  }
}
