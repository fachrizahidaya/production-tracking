// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/models/process/cross_cutting.dart';
import 'package:textile_tracking/screens/detail/%5Bprocess_id%5D.dart';

class CrossCuttingDetail extends StatefulWidget {
  final String id;
  final String no;
  final canDelete;
  final canUpdate;

  const CrossCuttingDetail(
      {super.key,
      required this.id,
      required this.no,
      this.canDelete,
      this.canUpdate});

  @override
  State<CrossCuttingDetail> createState() => _CrossCuttingDetailState();
}

class _CrossCuttingDetailState extends State<CrossCuttingDetail> {
  final CrossCuttingService _crossCuttingService = CrossCuttingService();

  @override
  Widget build(BuildContext context) {
    return ProcessDetail<CrossCutting>(
      id: widget.id,
      no: widget.no,
      label: 'Cross Cutting',
      service: Provider.of<CrossCuttingService>(context, listen: false),
      handleUpdateService: (context, id, item, isLoading) =>
          Provider.of<CrossCuttingService>(context, listen: false)
              .updateItem(context, id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<CrossCuttingService>(context, listen: false)
              .deleteItem(context, id, isLoading),
      modelBuilder: (form, data) => CrossCutting(
        wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
        unit_id: form['item_unit_id'] != null
            ? int.tryParse(form['item_unit_id'].toString())
            : 1,
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
        qty: form['item_qty'] ?? '0',
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
      route: '/cross-cuttings',
      fetchMachine: (service) => service.fetchOptionsCrossCutting(),
      getMachineOptions: (service) => service.dataListOption,
      withItemGrade: false,
      withQtyAndWeight: true,
      withMaklon: false,
      forDyeing: false,
      idProcess: 'cross_cutting_id',
      processService: _crossCuttingService,
      forPacking: false,
      fetchFinish: (service) => service.fetchCuttingFinishOptions(),
      handleSubmitToService: (context, id, form, isLoading) async {
        final crossCutting = CrossCutting(
          wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
          machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
          unit_id: int.tryParse(form['item_unit_id']?.toString() ?? '1'),
          weight_unit_id:
              int.tryParse(form['weight_unit_id']?.toString() ?? '2'),
          width_unit_id: int.tryParse(form['width_unit_id']?.toString() ?? '3'),
          length_unit_id:
              int.tryParse(form['length_unit_id']?.toString() ?? '3'),
          qty: form['item_qty'],
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
            await Provider.of<CrossCuttingService>(context, listen: false)
                .finishItem(context, id, crossCutting, isLoading);

        Navigator.pushNamedAndRemoveUntil(
            context, '/cross-cuttings', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Cross Cutting Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "CCT",
              ));
        });
      },
    );
  }
}
