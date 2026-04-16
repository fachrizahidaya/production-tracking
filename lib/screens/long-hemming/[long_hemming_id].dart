// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/models/process/long_hemming.dart';
import 'package:textile_tracking/screens/detail/%5Bprocess_id%5D.dart';

class LongHemmingDetail extends StatefulWidget {
  final String id;
  final String no;
  final canDelete;
  final canUpdate;

  const LongHemmingDetail(
      {super.key,
      required this.id,
      required this.no,
      this.canDelete,
      this.canUpdate});

  @override
  State<LongHemmingDetail> createState() => _LongHemmingDetailState();
}

class _LongHemmingDetailState extends State<LongHemmingDetail> {
  final LongHemmingService _longHemmingService = LongHemmingService();

  @override
  Widget build(BuildContext context) {
    return ProcessDetail<LongHemming>(
      id: widget.id,
      no: widget.no,
      label: 'Long Hemming',
      isMultiMachine: true,
      service: Provider.of<LongHemmingService>(context, listen: false),
      handleUpdateService: (context, id, item, isLoading) =>
          Provider.of<LongHemmingService>(context, listen: false)
              .updateItem(context, id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<LongHemmingService>(context, listen: false)
              .deleteItem(context, id, isLoading),
      modelBuilder: (form, data) => LongHemming(
        wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
        weight_unit_id: form['weight_unit_id'] != null
            ? int.tryParse(form['weight_unit_id'].toString())
            : 2,
        machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
        weight: form['weight'] ?? '0',
        notes: form['notes'] ?? data['notes'],
        attachments: [
          ...List<Map<String, dynamic>>.from(data['attachments'] ?? []),
          ...List<Map<String, dynamic>>.from(form['attachments'] ?? []),
        ],
        machine_ids: form['machine_ids'],
        machines: form['machines'],
        bs_weight: form['bs_weight'] ?? '0',
        bs_weight_unit_id: form['bs_weight_unit_id'] != null
            ? int.tryParse(form['bs_weight_unit_id'].toString())
            : 2,
        good_weight: form['good_weight'] ?? '0',
        good_weight_unit_id: form['good_weight_unit_id'] != null
            ? int.tryParse(form['good_weight_unit_id'].toString())
            : 2,
      ),
      canDelete: widget.canDelete,
      canUpdate: widget.canUpdate,
      route: '/long-hemmings',
      fetchMachine: (service, currentMachineIds) =>
          service.fetchOptionsLongHemming(
        currentMachineIds: currentMachineIds,
      ),
      getMachineOptions: (service) => service.dataListOption,
      withItemGrade: false,
      withMaklon: false,
      forDyeing: false,
      idProcess: 'long_hemming_id',
      processService: _longHemmingService,
      forPacking: false,
      forHemming: true,
      fetchFinish: (service) => service.fetchHemmingFinishOptions(),
      handleSubmitToService: (context, id, form, isLoading) async {
        final longHemming = LongHemming(
          wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
          machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
          weight_unit_id:
              int.tryParse(form['weight_unit_id']?.toString() ?? ''),
          weight: form['weight'],
          notes: form['notes'],
          start_time: form['start_time'],
          end_time: form['end_time'],
          start_by_id: int.tryParse(form['start_by_id']?.toString() ?? ''),
          end_by_id: int.tryParse(form['end_by_id']?.toString() ?? ''),
          attachments: form['attachments'],
          machines: form['machines'] ?? [],
          machine_ids: form['machine_ids'] ?? [],
          bs_weight: form['bs_weight'],
          bs_weight_unit_id:
              int.tryParse(form['bs_weight_unit_id']?.toString() ?? ''),
          good_weight: form['good_weight'],
          good_weight_unit_id:
              int.tryParse(form['good_weight_unit_id']?.toString() ?? ''),
        );

        final message =
            await Provider.of<LongHemmingService>(context, listen: false)
                .finishItem(context, id, longHemming, isLoading);

        Navigator.pushNamedAndRemoveUntil(
            context, '/long-hemmings', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Long Hemming Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "LHM",
              ));
        });
      },
    );
  }
}
