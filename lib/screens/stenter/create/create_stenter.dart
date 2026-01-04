// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/screens/master/create_process.dart';
import 'package:textile_tracking/models/process/stenter.dart';
import 'package:textile_tracking/screens/stenter/create/create_stenter_manual.dart';

class CreateStenter extends StatelessWidget {
  const CreateStenter({super.key});

  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
    final stenter = Stenter(
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

    final message = await Provider.of<StenterService>(context, listen: false)
        .addItem(stenter, isLoading);

    Navigator.pushNamedAndRemoveUntil(context, '/stenters', (route) => false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAlertDialog(
          context: context, title: 'Stenter Dimulai', message: message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CreateProcess(
      title: 'Mulai Stenter',
      handleSubmitToService: _submitToService,
      formPageBuilder: (context, id, data, form, handleSubmit) {
        return CreateStenterManual(
          id: id,
          data: data,
          form: form,
          handleSubmit: handleSubmit,
          fetchWorkOrder: (service) => service.fetchStenterOptions(id),
        );
      },
      fetchWorkOrder: (service) => service.fetchStenterOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
    );
  }
}
