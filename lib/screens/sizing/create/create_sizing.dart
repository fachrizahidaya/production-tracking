<<<<<<< HEAD
// ignore_for_file: use_build_context_synchronously

=======
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
<<<<<<< HEAD
import 'package:textile_tracking/screens/sizing/create/create_form.dart';
import 'package:textile_tracking/screens/sizing/create/create_sizing_process.dart';
=======
import 'package:textile_tracking/screens/create/index.dart';
import 'package:textile_tracking/screens/sizing/create/create_form.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
import 'package:textile_tracking/screens/sizing/model/sizing.dart';

class CreateSizing extends StatelessWidget {
  const CreateSizing({super.key});

  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
    final sizing = Sizing(
      notes: form['notes'],
<<<<<<< HEAD
      orderGreigeId: int.tryParse(form['order_greige_id']?.toString() ?? ''),
      machineId: int.tryParse(form['machine_id']?.toString() ?? ''),
      machine_ids: (form['machines'] as List?)
          ?.map((e) => int.tryParse(e['value'].toString()))
          .where((e) => e != null)
          .cast<int>()
          .toList(),
=======
      status: form['status'],
      attachments: form['attachments'],
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
    );

    final message = await Provider.of<SizingService>(context, listen: false)
        .addItem(context, sizing, isLoading);

<<<<<<< HEAD
    Navigator.pushNamedAndRemoveUntil(context, '/sizings', (route) => false);
=======
    Navigator.pushNamedAndRemoveUntil(context, '/sizing', (route) => false);
>>>>>>> 7fd183d (feat: create and finish warping, weaving)

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAlertDialog(
          context: context,
          title: 'Sizing Dimulai',
          child: buildBoldMessage(
            message: message,
<<<<<<< HEAD
            prefix: "SZG",
=======
            prefix: "SIZ",
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return CreateSizingProcess(
=======
    return CreateProcess(
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
      title: 'Mulai Sizing',
      handleSubmitToService: _submitToService,
      formPageBuilder: (context, id, processId, data, form, handleSubmit) {
        return CreateForm(
          id: id,
          data: data,
          processId: processId,
          form: form,
          handleSubmit: handleSubmit,
<<<<<<< HEAD
        );
      },
=======
          fetchWorkOrder: (service) => service.fetchSizingOptions(id),
        );
      },
      fetchWorkOrder: (service) => service.fetchSizingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
    );
  }
}
