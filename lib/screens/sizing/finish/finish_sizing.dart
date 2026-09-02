// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/sizing/finish/finish_form.dart';
import 'package:textile_tracking/screens/sizing/finish/finish_sizing_process.dart';
import 'package:textile_tracking/screens/sizing/model/sizing.dart';

class FinishSizing extends StatefulWidget {
  const FinishSizing({super.key});

  @override
  State<FinishSizing> createState() => _FinishSizingState();
}

class _FinishSizingState extends State<FinishSizing> {
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
    'roll_length': null,
    'notes': '',
    'attachments': []
  };

  @override
  void dispose() {
    _form.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FinishSizingProcess(
      title: 'Selesai Sizing',
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
        final sizing = Sizing(
          notes: form['notes'],
          panjangGulungan: form['roll_length'],
          orderGreigeId:
              int.tryParse(form['order_greige_id']?.toString() ?? ''),
          machineId: int.tryParse(form['machine_id']?.toString() ?? ''),
          attachments: form['attachments'],
        );

        final message = await Provider.of<SizingService>(context, listen: false)
            .finishItem(context, id, sizing, isLoading);

        Navigator.pushNamedAndRemoveUntil(context, '/sizings', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Sizing Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "SZG",
              ));
        });
      },
    );
  }
}
