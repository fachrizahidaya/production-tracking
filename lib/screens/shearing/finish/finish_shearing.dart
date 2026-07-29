// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/shearing/finish/finish_form.dart';
import 'package:textile_tracking/screens/shearing/finish/finish_shearing_process.dart';
import 'package:textile_tracking/screens/shearing/model/shearing.dart';

class FinishShearing extends StatefulWidget {
  const FinishShearing({super.key});

  @override
  State<FinishShearing> createState() => _FinishShearingState();
}

class _FinishShearingState extends State<FinishShearing> {
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
    'qty': null,
    'weight': null,
    'notes': '',
  };

  @override
  void dispose() {
    _form.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FinishShearingProcess(
      title: 'Selesai Shearing',
      formPageBuilder: (
        context,
        id,
        processId,
        data,
        form,
        handleSubmit,
        handleChangeInput,
      ) =>
          FinishForm(
        id: id,
        processId: processId,
        data: data,
        form: form,
        handleSubmit: handleSubmit,
        handleChangeInput: handleChangeInput,
      ),
      handleSubmitToService: (context, id, form, isLoading) async {
        final shearing = Shearing(
          machineId: int.tryParse(form['machine_id']?.toString() ?? ''),
          notes: form['notes']?.toString() ?? '',
          qty: num.tryParse(form['qty']?.toString() ?? '0') ?? 0,
          weight: num.tryParse(form['weight']?.toString() ?? '0') ?? 0,
          orderGreigeId:
              int.tryParse(form['order_greige_id']?.toString() ?? ''),
        );

        final message =
            await Provider.of<ShearingService>(context, listen: false)
                .finishItem(context, id, shearing, isLoading);

        Navigator.pushNamedAndRemoveUntil(context, '/shearings', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Shearing Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "SHR",
              ));
        });
      },
    );
  }
}
