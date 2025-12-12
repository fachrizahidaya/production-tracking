// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/service/create_process.dart';
import 'package:textile_tracking/models/process/dyeing.dart';
import 'package:textile_tracking/screens/dyeing/create/create_dyeing_manual.dart';

class CreateDyeing extends StatelessWidget {
  const CreateDyeing({super.key});

  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
    final dyeing = Dyeing(
      wo_id:
          form['wo_id'] != null ? int.tryParse(form['wo_id'].toString()) : null,
      unit_id: form['unit_id'] != null
          ? int.tryParse(form['unit_id'].toString())
          : null,
      machine_id: form['machine_id'] != null
          ? int.tryParse(form['machine_id'].toString())
          : null,
      rework_reference_id: form['rework_reference_id'] != null
          ? int.tryParse(form['rework_reference_id'].toString())
          : null,
      qty: form['qty'],
      width: form['width'],
      length: form['length'],
      notes: form['notes'],
      rework: form['rework'],
      status: form['status'],
      start_time: form['start_time'],
      end_time: form['end_time'],
      start_by_id: form['start_by_id'] != null
          ? int.tryParse(form['start_by_id'].toString())
          : null,
      end_by_id: form['end_by_id'],
      attachments: form['attachments'],
    );

    final message = await Provider.of<DyeingService>(context, listen: false)
        .addItem(dyeing, isLoading);

    showAlertDialog(
      context: context,
      title: 'Dyeing Created',
      message: message,
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/dyeings',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CreateProcess(
      title: "Mulai Dyeing",
      fetchWorkOrder: (service) => service.fetchOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      handleSubmitToService: _submitToService,
      formPageBuilder: (context, id, data, form, handleSubmit) {
        return CreateDyeingManual(
          id: id,
          data: data,
          form: form,
          handleSubmit: handleSubmit,
          fetchWorkOrder: (service) => service.fetchOptions(id),
        );
      },
    );
  }
}
