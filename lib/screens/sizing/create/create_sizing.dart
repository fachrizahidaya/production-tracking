// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/screens/sizing/create/create_form.dart';
import 'package:textile_tracking/screens/sizing/create/create_sizing_process.dart';
import 'package:textile_tracking/screens/sizing/model/sizing.dart';

class CreateSizing extends StatelessWidget {
  const CreateSizing({super.key});

  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
    final sizing = Sizing(
      notes: form['notes'],
      orderGreigeId: int.tryParse(form['order_greige_id']?.toString() ?? ''),
      machineId: int.tryParse(form['machine_id']?.toString() ?? ''),
    );

    final message = await Provider.of<SizingService>(context, listen: false)
        .addItem(context, sizing, isLoading);

    Navigator.pushNamedAndRemoveUntil(context, '/sizings', (route) => false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAlertDialog(
          context: context,
          title: 'Sizing Dimulai',
          child: buildBoldMessage(
            message: message,
            prefix: "SZG",
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return CreateSizingProcess(
      title: 'Mulai Sizing',
      handleSubmitToService: _submitToService,
      formPageBuilder: (context, id, processId, data, form, handleSubmit) {
        return CreateForm(
          id: id,
          data: data,
          processId: processId,
          form: form,
          handleSubmit: handleSubmit,
        );
      },
    );
  }
}
