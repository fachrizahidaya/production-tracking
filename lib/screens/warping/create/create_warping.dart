import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/screens/create/index.dart';
import 'package:textile_tracking/screens/warping/create/create_form.dart';
import 'package:textile_tracking/screens/warping/model/warping.dart';

class CreateWarping extends StatelessWidget {
  const CreateWarping({super.key});

  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
    final warping = Warping(
      notes: form['notes'],
      status: form['status'],
      attachments: form['attachments'],
    );

    final message = await Provider.of<WarpingService>(context, listen: false)
        .addItem(context, warping, isLoading);

    Navigator.pushNamedAndRemoveUntil(context, '/warping', (route) => false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAlertDialog(
          context: context,
          title: 'Warping Dimulai',
          child: buildBoldMessage(
            message: message,
            prefix: "WAR",
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return CreateProcess(
      title: 'Mulai Warping',
      handleSubmitToService: _submitToService,
      formPageBuilder: (context, id, processId, data, form, handleSubmit) {
        return CreateForm(
          id: id,
          data: data,
          processId: processId,
          form: form,
          handleSubmit: handleSubmit,
          fetchWorkOrder: (service) => service.fetchWarpingOptions(id),
        );
      },
      fetchWorkOrder: (service) => service.fetchWarpingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
    );
  }
}
