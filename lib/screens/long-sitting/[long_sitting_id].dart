// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/models/process/long_sitting.dart';
import 'package:textile_tracking/screens/detail/%5Bprocess_id%5D.dart';

class LongSittingDetail extends StatefulWidget {
  final String id;
  final String no;
  final canDelete;
  final canUpdate;

  const LongSittingDetail(
      {super.key,
      required this.id,
      required this.no,
      this.canDelete,
      this.canUpdate});

  @override
  State<LongSittingDetail> createState() => _LongSittingDetailState();
}

class _LongSittingDetailState extends State<LongSittingDetail> {
  final LongSittingService _longSittingService = LongSittingService();

  @override
  Widget build(BuildContext context) {
    return ProcessDetail<LongSitting>(
      id: widget.id,
      no: widget.no,
      label: 'Long Slitting',
      service: Provider.of<LongSittingService>(context, listen: false),
      handleUpdateService: (context, id, item, isLoading) =>
          Provider.of<LongSittingService>(context, listen: false)
              .updateItem(context, id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<LongSittingService>(context, listen: false)
              .deleteItem(context, id, isLoading),
      modelBuilder: (form, data) => LongSitting(
        wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
        weight_unit_id: form['weight_unit_id'] != null
            ? int.tryParse(form['weight_unit_id'].toString())
            : 1,
        length_unit_id: form['length_unit_id'] != null
            ? int.tryParse(form['length_unit_id'].toString())
            : 1,
        width_unit_id: form['width_unit_id'] != null
            ? int.tryParse(form['width_unit_id'].toString())
            : 1,
        machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
        weight: form['weight'] ?? '0',
        width: form['width'] ?? '0',
        length: form['length'] ?? '0',
        notes: form['notes'] ?? data['notes'],
        attachments: [
          ...List<Map<String, dynamic>>.from(data['attachments'] ?? []),
          ...List<Map<String, dynamic>>.from(form['attachments'] ?? []),
        ],
      ),
      canDelete: widget.canDelete,
      canUpdate: widget.canUpdate,
      route: '/long-slittings',
      fetchMachine: (service) => service.fetchOptionsLongSitting(),
      getMachineOptions: (service) => service.dataListOption,
      withItemGrade: false,
      withMaklon: false,
      forDyeing: false,
      idProcess: 'long_slitting_id',
      processService: _longSittingService,
      forPacking: false,
      fetchFinish: (service) => service.fetchSittingFinishOptions(),
      handleSubmitToService: (context, id, form, isLoading) async {
        final longSitting = LongSitting(
          wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
          machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
          weight_unit_id:
              int.tryParse(form['weight_unit_id']?.toString() ?? ''),
          width_unit_id: int.tryParse(form['width_unit_id']?.toString() ?? ''),
          length_unit_id:
              int.tryParse(form['length_unit_id']?.toString() ?? ''),
          weight: form['weight'],
          width: form['width'],
          length: form['length'],
          notes: form['notes'],
          start_time: form['start_time'],
          end_time: form['end_time'],
          start_by_id: int.tryParse(form['start_by_id']?.toString() ?? ''),
          end_by_id: int.tryParse(form['end_by_id']?.toString() ?? ''),
          attachments: form['attachments'],
        );

        final message =
            await Provider.of<LongSittingService>(context, listen: false)
                .finishItem(context, id, longSitting, isLoading);

        Navigator.pushNamedAndRemoveUntil(
            context, '/long-slittings', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Long Slitting Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "LST",
              ));
        });
      },
    );
  }
}
