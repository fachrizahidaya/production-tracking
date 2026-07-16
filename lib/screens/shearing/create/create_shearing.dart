<<<<<<< HEAD
<<<<<<< HEAD
// ignore_for_file: use_build_context_synchronously

=======
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
// ignore_for_file: use_build_context_synchronously

>>>>>>> bb29b60 (fix: clear warning)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
<<<<<<< HEAD
import 'package:textile_tracking/screens/shearing/create/create_form.dart';
import 'package:textile_tracking/screens/shearing/create/create_shearing_process.dart';
=======
import 'package:textile_tracking/screens/create/index.dart';
import 'package:textile_tracking/screens/shearing/create/create_form.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
import 'package:textile_tracking/screens/shearing/model/shearing.dart';

class CreateShearing extends StatelessWidget {
  const CreateShearing({super.key});

  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
    final shearing = Shearing(
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

    final message = await Provider.of<ShearingService>(context, listen: false)
        .addItem(context, shearing, isLoading);

<<<<<<< HEAD
    Navigator.pushNamedAndRemoveUntil(context, '/shearings', (route) => false);
=======
    Navigator.pushNamedAndRemoveUntil(context, '/shearing', (route) => false);
>>>>>>> 7fd183d (feat: create and finish warping, weaving)

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAlertDialog(
          context: context,
          title: 'Shearing Dimulai',
          child: buildBoldMessage(
            message: message,
<<<<<<< HEAD
            prefix: "SHR",
=======
            prefix: "SHE",
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return CreateShearingProcess(
=======
    return CreateProcess(
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
      title: 'Mulai Shearing',
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
          fetchWorkOrder: (service) => service.fetchShearingOptions(id),
        );
      },
      fetchWorkOrder: (service) => service.fetchShearingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
    );
  }
}
