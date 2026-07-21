// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/screens/create/greige_order_index.dart';
import 'package:textile_tracking/screens/shearing/create/create_form.dart';
import 'package:textile_tracking/screens/shearing/model/shearing.dart';

class CreateShearing extends StatelessWidget {
  const CreateShearing({super.key});

  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
    final shearing = Shearing(
      notes: form['notes'],
      status: form['status'],
      attachments: form['attachments'],
    );

    final message = await Provider.of<ShearingService>(context, listen: false)
        .addItem(context, shearing, isLoading);

    Navigator.pushNamedAndRemoveUntil(context, '/shearing', (route) => false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAlertDialog(
          context: context,
          title: 'Shearing Dimulai',
          child: buildBoldMessage(
            message: message,
            prefix: "SHE",
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return CreateGreigeOrderProcess(
      title: 'Mulai Shearing',
      handleSubmitToService: _submitToService,
      formPageBuilder: (context, id, processId, data, form, handleSubmit) {
        return CreateForm(
          id: id,
          data: data,
          processId: processId,
          form: form,
          handleSubmit: handleSubmit,
          fetchWorkOrder: (service) => service.fetchShearingOptions(),
        );
      },
      fetchGreigeOrder: (service) => service.fetchShearingOptions(),
      getGreigeOrderOptions: (service) => service.dataListOption,
    );
  }
}
