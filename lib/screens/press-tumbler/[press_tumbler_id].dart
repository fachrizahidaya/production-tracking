// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/models/process/press_tumbler.dart';
import 'package:textile_tracking/screens/detail/%5Bprocess_id%5D.dart';

class PressTumblerDetail extends StatefulWidget {
  final id;
  final no;
  final canDelete;
  final canUpdate;

  const PressTumblerDetail(
      {super.key,
      required this.id,
      required this.no,
      this.canDelete,
      this.canUpdate});

  @override
  State<PressTumblerDetail> createState() => _PressTumblerDetailState();
}

class _PressTumblerDetailState extends State<PressTumblerDetail> {
  final PressTumblerService _pressTumblerService = PressTumblerService();

  @override
  Widget build(BuildContext context) {
    return ProcessDetail<PressTumbler>(
      id: widget.id,
      no: widget.no,
      label: 'Press',
      service: Provider.of<PressTumblerService>(context, listen: false),
      handleUpdateService: (context, id, item, isLoading) =>
          Provider.of<PressTumblerService>(context, listen: false)
              .updateItem(context, id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<PressTumblerService>(context, listen: false)
              .deleteItem(context, id, isLoading),
      modelBuilder: (form, data) => PressTumbler(
        wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
        weight_unit_id: form['weight_unit_id'] != null
            ? int.tryParse(form['weight_unit_id'].toString())
            : 1,
        length_unit_id: form['length_unit_id'] != null
            ? int.tryParse(form['length_unit_id'].toString())
            : 3,
        width_unit_id: form['width_unit_id'] != null
            ? int.tryParse(form['width_unit_id'].toString())
            : 3,
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
      route: '/press',
      fetchMachine: (service) => service.fetchOptionsPressTumbler(),
      getMachineOptions: (service) => service.dataListOption,
      withItemGrade: false,
      withMaklon: false,
      forDyeing: false,
      idProcess: 'press_id',
      processService: _pressTumblerService,
      forPacking: false,
      fetchFinish: (service) => service.fetchPressFinishOptions(),
      handleSubmitToService: (context, id, form, isLoading) async {
        final press = PressTumbler(
          wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
          machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
          width_unit_id: int.tryParse(form['width_unit_id']?.toString() ?? ''),
          length_unit_id:
              int.tryParse(form['length_unit_id']?.toString() ?? ''),
          weight_unit_id:
              int.tryParse(form['weight_unit_id']?.toString() ?? ''),
          weight: form['weight'],
          width: form['width'] =
              (form['width'] == null || form['width'].toString().isEmpty)
                  ? '0'
                  : form['width'],
          length: form['length'] =
              (form['length'] == null || form['length'].toString().isEmpty)
                  ? '0'
                  : form['length'],
          notes: form['notes'],
          start_time: form['start_time'],
          end_time: form['end_time'],
          start_by_id: int.tryParse(form['start_by_id']?.toString() ?? ''),
          end_by_id: int.tryParse(form['end_by_id']?.toString() ?? ''),
          attachments: form['attachments'],
        );

        final message =
            await Provider.of<PressTumblerService>(context, listen: false)
                .finishItem(context, id, press, isLoading);

        Navigator.pushNamedAndRemoveUntil(context, '/press', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Press Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "PRS",
              ));
        });
      },
    );
  }
}
