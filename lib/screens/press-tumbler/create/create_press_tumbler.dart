// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/service/create_process.dart';
import 'package:textile_tracking/models/process/press_tumbler.dart';
import 'package:textile_tracking/screens/press-tumbler/create/create_press_tumbler_manual.dart';

class CreatePressTumbler extends StatelessWidget {
  const CreatePressTumbler({super.key});

  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
    final press = PressTumbler(
      wo_id:
          form['wo_id'] != null ? int.tryParse(form['wo_id'].toString()) : null,
      weight_unit_id: form['unit_id'] != null
          ? int.tryParse(form['unit_id'].toString())
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
        await Provider.of<PressTumblerService>(context, listen: false)
            .addItem(press, isLoading);

    showAlertDialog(context: context, title: 'Press Created', message: message);

    Navigator.pushNamedAndRemoveUntil(context, '/press', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return CreateProcess(
      title: 'Mulai Press',
      handleSubmitToService: _submitToService,
      formPageBuilder: (context, id, data, form, handleSubmit) {
        return CreatePressTumblerManual(
          id: id,
          data: data,
          form: form,
          handleSubmit: handleSubmit,
          fetchWorkOrder: (service) => service.fetchPressTumblerOptions(id),
        );
      },
      fetchWorkOrder: (service) => service.fetchPressTumblerOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
    );
  }
}
