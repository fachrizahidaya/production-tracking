// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/screens/dyeing-preparation/create/create_form.dart';
import 'package:textile_tracking/screens/dyeing-preparation/create/create_dyeing_preparation_process.dart';
import 'package:textile_tracking/screens/dyeing-preparation/model/dyeing_preparation.dart';

class CreateDyeingPreparation extends StatelessWidget {
  const CreateDyeingPreparation({super.key});

<<<<<<< HEAD
  List<Map<String, dynamic>> _mapCreateItems(dynamic items) {
    return List<dynamic>.from(items ?? []).map<Map<String, dynamic>>((rawItem) {
      final item = Map<String, dynamic>.from(rawItem);
      final workOrderItemId = item.remove('work_order_item_id');

      return {
        ...item,
        'wo_item_id': item['wo_item_id'] ?? workOrderItemId,
      };
    }).toList();
  }

=======
>>>>>>> 57f45d55 (feat: persiapan dyeing)
  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
    final dyeingPreparation = DyeingPreparation(
      woId: int.tryParse(form['wo_id']?.toString() ?? ''),
<<<<<<< HEAD
<<<<<<< HEAD
      items: _mapCreateItems(form['items']),
      notes: form['notes']?.toString() ?? '',
      attachments: form['attachments'],
=======
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
      items: form['items'] ?? [],
      notes: form['notes']?.toString() ?? '',
>>>>>>> 7e9db1cc (feat: buat persiapan dyeing)
    );

    final message =
        await Provider.of<DyeingPreparationService>(context, listen: false)
<<<<<<< HEAD
            .createPreparation(context, dyeingPreparation, isLoading);
=======
            .addItem(context, dyeingPreparation, isLoading);
>>>>>>> 57f45d55 (feat: persiapan dyeing)

    Navigator.pushNamedAndRemoveUntil(
        context, '/dyeing-preparations', (route) => false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAlertDialog(
          context: context,
          title: 'Persiapan Dyeing Dimulai',
          child: buildBoldMessage(
            message: message,
<<<<<<< HEAD
<<<<<<< HEAD
            prefix: "PD",
=======
            prefix: "PDP",
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
            prefix: "PRE",
>>>>>>> 7e9db1cc (feat: buat persiapan dyeing)
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return CreateDyeingPreparationProcess(
      title: 'Buat Persiapan Dyeing',
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
