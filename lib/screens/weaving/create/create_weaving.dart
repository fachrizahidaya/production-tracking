// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/screens/weaving/create/create_form.dart';
import 'package:textile_tracking/screens/weaving/create/create_weaving_process.dart';
import 'package:textile_tracking/screens/weaving/model/weaving.dart';

class CreateWeavng extends StatelessWidget {
  const CreateWeavng({super.key});

  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
    final weaving = Weaving(
        notes: form['notes'],
        machineId: int.tryParse(form['machine_id']?.toString() ?? ''),
        orderGreigeId: int.tryParse(form['order_greige_id']?.toString() ?? ''),
        skipShearing: form['skip_shearing']);

    final message = await Provider.of<WeavingService>(context, listen: false)
        .addItem(context, weaving, isLoading);

    Navigator.pushNamedAndRemoveUntil(context, '/weavings', (route) => false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAlertDialog(
          context: context,
          title: 'Weaving Dimulai',
          child: buildBoldMessage(
            message: message,
            prefix: "WVG",
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return CreateWeavingProcess(
      title: 'Mulai Weaving',
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
