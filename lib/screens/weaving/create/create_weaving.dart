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
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/screens/weaving/create/create_form.dart';
import 'package:textile_tracking/screens/weaving/create/create_weaving_process.dart';
=======
import 'package:textile_tracking/screens/create/index.dart';
=======
import 'package:textile_tracking/screens/create/greige_order_index.dart';
>>>>>>> a1ea7df (feat: warping)
import 'package:textile_tracking/screens/weaving/create/create_form.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
import 'package:textile_tracking/screens/weaving/create/create_form.dart';
import 'package:textile_tracking/screens/weaving/create/create_weaving_process.dart';
>>>>>>> 95d1a035 (fix: weaving, shearing)
import 'package:textile_tracking/screens/weaving/model/weaving.dart';

class CreateWeavng extends StatelessWidget {
  const CreateWeavng({super.key});

  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
    final weaving = Weaving(
<<<<<<< HEAD
<<<<<<< HEAD
        notes: form['notes'],
        machineId: int.tryParse(form['machine_id']?.toString() ?? ''),
        orderGreigeId: int.tryParse(form['order_greige_id']?.toString() ?? ''),
        skipShearing: form['skip_shearing'],
        machine_ids: (form['machines'] as List?)
            ?.map((e) => int.tryParse(e['value'].toString()))
            .where((e) => e != null)
            .cast<int>()
            .toList());
=======
      notes: form['notes'],
      status: form['status'],
      attachments: form['attachments'],
    );
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
        notes: form['notes'],
        machineId: int.tryParse(form['machine_id']?.toString() ?? ''),
        orderGreigeId: int.tryParse(form['order_greige_id']?.toString() ?? ''),
        skipShearing: form['skip_shearing']);
>>>>>>> 95d1a035 (fix: weaving, shearing)

    final message = await Provider.of<WeavingService>(context, listen: false)
        .addItem(context, weaving, isLoading);

<<<<<<< HEAD
<<<<<<< HEAD
    Navigator.pushNamedAndRemoveUntil(context, '/weavings', (route) => false);
=======
    Navigator.pushNamedAndRemoveUntil(context, '/weaving', (route) => false);
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
    Navigator.pushNamedAndRemoveUntil(context, '/weavings', (route) => false);
>>>>>>> 95d1a035 (fix: weaving, shearing)

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAlertDialog(
          context: context,
          title: 'Weaving Dimulai',
          child: buildBoldMessage(
            message: message,
<<<<<<< HEAD
<<<<<<< HEAD
            prefix: "WVG",
=======
            prefix: "WEA",
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
            prefix: "WVG",
>>>>>>> 95d1a035 (fix: weaving, shearing)
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    return CreateWeavingProcess(
=======
    return CreateProcess(
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
    return CreateGreigeOrderProcess(
>>>>>>> a1ea7df (feat: warping)
=======
    return CreateWeavingProcess(
>>>>>>> 95d1a035 (fix: weaving, shearing)
      title: 'Mulai Weaving',
      handleSubmitToService: _submitToService,
      formPageBuilder: (context, id, processId, data, form, handleSubmit) {
        return CreateForm(
          id: id,
          data: data,
          processId: processId,
          form: form,
          handleSubmit: handleSubmit,
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        );
      },
=======
          fetchWorkOrder: (service) => service.fetchWeavingOptions(id),
        );
      },
      fetchWorkOrder: (service) => service.fetchWeavingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
          fetchWorkOrder: (service) => service.fetchWeavingOptions(),
        );
      },
      fetchGreigeOrder: (service) => service.fetchWeavingOptions(),
      getGreigeOrderOptions: (service) => service.dataListOption,
>>>>>>> a1ea7df (feat: warping)
=======
        );
      },
>>>>>>> 95d1a035 (fix: weaving, shearing)
    );
  }
}
