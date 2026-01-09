// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/screens/create/index.dart';
import 'package:textile_tracking/models/process/printing.dart';
import 'package:textile_tracking/screens/printing/create/create_printing_manual.dart';

class CreatePrinting extends StatelessWidget {
  const CreatePrinting({super.key});

  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
    final printing = Printing(
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
      maklon: form['maklon'] == true,
      maklon_name: form['maklon_name'],
    );

    final message = await Provider.of<PrintingService>(context, listen: false)
        .addItem(printing, isLoading);

    Navigator.pushNamedAndRemoveUntil(context, '/printings', (route) => false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAlertDialog(
          context: context, title: 'Printing Dimulai', message: message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CreateProcess(
        title: 'Mulai Printing',
        handleSubmitToService: _submitToService,
        formPageBuilder: (context, id, processId, data, form, handleSubmit) {
          return CreatePrintingManual(
            id: id,
            data: data,
            form: form,
            processId: processId,
            handleSubmit: handleSubmit,
            fetchWorkOrder: (service) => service.fetchPrintingOptions(id),
          );
        },
        fetchWorkOrder: (service) => service.fetchPrintingOptions(),
        getWorkOrderOptions: (service) => service.dataListOption);
  }
}
