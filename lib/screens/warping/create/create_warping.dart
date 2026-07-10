<<<<<<< HEAD
// ignore_for_file: use_build_context_synchronously

=======
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
<<<<<<< HEAD
import 'package:textile_tracking/screens/warping/create/create_form.dart';
import 'package:textile_tracking/screens/warping/create/create_warping_process.dart';
=======
import 'package:textile_tracking/screens/create/index.dart';
import 'package:textile_tracking/screens/warping/create/create_form.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
import 'package:textile_tracking/screens/warping/model/warping.dart';

class CreateWarping extends StatelessWidget {
  const CreateWarping({super.key});

  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
<<<<<<< HEAD
    final isSingle = form['warping_type'] == 'single_warping';

    final warping = Warping(
      orderGreigeId: int.tryParse(form['order_greige_id']?.toString() ?? ''),
      machineId: int.tryParse(form['machine_id']?.toString() ?? ''),
      notes: form['notes']?.toString() ?? '',
      warpingType: form['warping_type']?.toString(),
      yarnQty: num.tryParse(form['yarn_qty']?.toString() ?? ''),
      beamQty:
          isSingle ? num.tryParse(form['beam_qty']?.toString() ?? '') : null,
      section:
          !isSingle ? num.tryParse(form['section']?.toString() ?? '') : null,
      machine_ids: (form['machines'] as List?)
          ?.map((e) => int.tryParse(e['value'].toString()))
          .where((e) => e != null)
          .cast<int>()
          .toList(),
=======
    final warping = Warping(
      notes: form['notes'],
      status: form['status'],
      attachments: form['attachments'],
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
    );

    final message = await Provider.of<WarpingService>(context, listen: false)
        .addItem(context, warping, isLoading);

<<<<<<< HEAD
    Navigator.pushNamedAndRemoveUntil(context, '/warpings', (route) => false);
=======
    Navigator.pushNamedAndRemoveUntil(context, '/warping', (route) => false);
>>>>>>> 7fd183d (feat: create and finish warping, weaving)

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAlertDialog(
          context: context,
          title: 'Warping Dimulai',
          child: buildBoldMessage(
            message: message,
<<<<<<< HEAD
            prefix: "WRP",
=======
            prefix: "WAR",
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return CreateWarpingProcess(
=======
    return CreateProcess(
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
      title: 'Mulai Warping',
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
          fetchWorkOrder: (service) => service.fetchWarpingOptions(id),
        );
      },
      fetchWorkOrder: (service) => service.fetchWarpingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
    );
  }
}
