// ignore_for_file: file_names

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
      service: Provider.of<PackingService>(context, listen: false),
      handleUpdateService: (context, id, item, isLoading) =>
          Provider.of<PackingService>(context, listen: false)
              .updateItem(context, id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<PackingService>(context, listen: false)
              .deleteItem(context, id, isLoading),
      modelBuilder: (form, data) => Packing(
          wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
          weight_unit_id:
              int.tryParse(form['weight_unit_id']?.toString() ?? ''),
          length_unit_id:
              int.tryParse(form['length_unit_id']?.toString() ?? ''),
          width_unit_id: int.tryParse(form['width_unit_id']?.toString() ?? ''),
          machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
          weight: form['weight'] ?? data['weight'],
          width: form['width'] ?? data['width'],
          length: form['length'] ?? data['length'],
          notes: form['notes'] ?? data['notes'],
          attachments: [
            ...List<Map<String, dynamic>>.from(data['attachments'] ?? []),
            ...List<Map<String, dynamic>>.from(form['attachments'] ?? []),
          ],
          grades: [
            ...List<Map<String, dynamic>>.from(data['grades'] ?? []),
            ...List<Map<String, dynamic>>.from(form['grades'] ?? []),
          ]),
      canDelete: widget.canDelete,
      canUpdate: widget.canUpdate,
      route: '/packings',
      withItemGrade: true,
      withMaklon: false,
      forDyeing: false,
      idProcess: 'packing_id',
      processService: _packingService,
      forPacking: false,
      fetchFinish: (service) => service.fetchPackingFinishOptions(),
      handleSubmitToService: (context, id, form, isLoading) async {
        final packing = Packing(
          wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
          machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
          weight_unit_id:
              int.tryParse(form['weight_unit_id']?.toString() ?? '2'),
          width_unit_id: int.tryParse(form['width_unit_id']?.toString() ?? '3'),
          length_unit_id:
              int.tryParse(form['length_unit_id']?.toString() ?? '3'),
          notes: form['notes'],
          start_time: form['start_time'],
          end_time: form['end_time'],
          start_by_id: int.tryParse(form['start_by_id']?.toString() ?? ''),
          end_by_id: int.tryParse(form['end_by_id']?.toString() ?? ''),
          attachments: form['attachments'],
          grades: form['grades'],
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
