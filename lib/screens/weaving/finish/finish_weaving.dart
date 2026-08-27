// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/weaving/finish/finish_form.dart';
import 'package:textile_tracking/screens/weaving/finish/finish_weaving_process.dart';
import 'package:textile_tracking/screens/weaving/model/weaving.dart';

class FinishWeaving extends StatefulWidget {
  const FinishWeaving({super.key});

  @override
  State<FinishWeaving> createState() => _FinishWeavingState();
}

class _FinishWeavingState extends State<FinishWeaving> {
  @override
  void initState() {
    final loggedInUser = Provider.of<UserProvider>(context, listen: false).user;

    setState(() {
      _form['end_by_id'] = loggedInUser?.id;
    });

    super.initState();
  }

  final Map<String, dynamic> _form = {
    'order_greige_id': null,
    'machine_id': null,
    'notes': '',
    'qty': null,
    'weight': null,
    'waste': null,
    'skip_shearing': ''
  };

  @override
  void dispose() {
    _form.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FinishWeavingProcess(
      title: 'Selesai Weaving',
      formPageBuilder: (context, id, processId, data, form, handleSubmit,
              handleChangeInput) =>
          FinishForm(
        id: id,
        processId: processId,
        data: data,
        form: form,
        handleSubmit: handleSubmit,
        handleChangeInput: handleChangeInput,
      ),
      handleSubmitToService: (context, id, form, isLoading) async {
        final weaving = Weaving(
          machineId: int.tryParse(form['machine_id']?.toString() ?? ''),
          notes: form['notes']?.toString() ?? '',
          qty: num.tryParse(form['qty']?.toString() ?? '0') ?? 0,
          weight: num.tryParse(form['weight']?.toString() ?? '0') ?? 0,
          waste: num.tryParse(form['waste']?.toString() ?? '0') ?? 0,
          orderGreigeId:
              int.tryParse(form['order_greige_id']?.toString() ?? ''),
        );

        final message =
            await Provider.of<WeavingService>(context, listen: false)
                .finishItem(context, id, weaving, isLoading);

        Navigator.pushNamedAndRemoveUntil(context, '/weavings', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Weaving Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "WVG",
              ));
        });
      },
    );
  }
}
