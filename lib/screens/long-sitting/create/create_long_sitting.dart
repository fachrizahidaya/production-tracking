// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/screens/create/index.dart';
import 'package:textile_tracking/models/process/long_sitting.dart';
import 'package:textile_tracking/screens/long-sitting/create/create_long_sitting_manual.dart';

class CreateLongSitting extends StatelessWidget {
  const CreateLongSitting({super.key});

  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
    final longSitting = LongSitting(
      wo_id:
          form['wo_id'] != null ? int.tryParse(form['wo_id'].toString()) : null,
      weight_unit_id: form['unit_id'] != null
          ? int.tryParse(form['weight_unit_id'].toString())
          : null,
      machine_id: form['machine_id'] != null
          ? int.tryParse(form['machine_id'].toString())
          : null,
      weight: form['weight'],
      width: form['width'],
      length: form['length'],
      notes: form['notes'],
      status: form['status'],
      start_time: form['start_time'],
      end_time: form['end_time'],
      start_by_id: form['start_by_id'] != null
          ? int.tryParse(form['start_by_id'].toString())
          : null,
      end_by_id: form['end_by_id'],
      attachments: form['attachments'],
    );

    final message =
        await Provider.of<LongSittingService>(context, listen: false)
            .addItem(context, longSitting, isLoading);

    Navigator.pushNamedAndRemoveUntil(
        context, '/long-slittings', (route) => false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAlertDialog(
          context: context, title: 'Long Slitting Dimulai', message: message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CreateProcess(
      title: 'Mulai Long Slitting',
      handleSubmitToService: _submitToService,
      formPageBuilder: (context, id, processId, data, form, handleSubmit) {
        return CreateLongSittingManual(
          id: id,
          data: data,
          form: form,
          processId: processId,
          handleSubmit: handleSubmit,
          fetchWorkOrder: (service) => service.fetchLongSittingOptions(id),
        );
      },
      fetchWorkOrder: (service) => service.fetchLongSittingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
    );
  }
}
