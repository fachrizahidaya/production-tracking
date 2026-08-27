// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/screens/warping/create/create_form.dart';
import 'package:textile_tracking/screens/warping/create/create_warping_process.dart';
import 'package:textile_tracking/screens/warping/model/warping.dart';

class CreateWarping extends StatelessWidget {
  const CreateWarping({super.key});

  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
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
    );

    final message = await Provider.of<WarpingService>(context, listen: false)
        .addItem(context, warping, isLoading);

    Navigator.pushNamedAndRemoveUntil(context, '/warpings', (route) => false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAlertDialog(
          context: context,
          title: 'Warping Dimulai',
          child: buildBoldMessage(
            message: message,
            prefix: "WRP",
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return CreateWarpingProcess(
      title: 'Mulai Warping',
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
