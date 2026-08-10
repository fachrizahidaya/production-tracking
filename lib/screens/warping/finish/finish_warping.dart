// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/warping/finish/finish_form.dart';
import 'package:textile_tracking/screens/warping/finish/finish_warping_process.dart';
import 'package:textile_tracking/screens/warping/model/warping.dart';

class FinishWarping extends StatefulWidget {
  const FinishWarping({super.key});

  @override
  State<FinishWarping> createState() => _FinishWarpingState();
}

class _FinishWarpingState extends State<FinishWarping> {
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
    'yarn_qty': null,
    'notes': '',
    'warping_type': '',
    'beam_qty': null,
    'section': null,
    'lengths': [],
  };

  @override
  void dispose() {
    _form.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FinishWarpingProcess(
      title: 'Selesai Warping',
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
        final warping = Warping(
          machineId: int.tryParse(form['machine_id']?.toString() ?? ''),
          warpingType: form['warping_type']?.toString(),
          yarnQty: num.tryParse(form['yarn_qty']?.toString() ?? '0') ?? 0,
          section: int.tryParse(form['section']?.toString() ?? '0') ?? 0,
          notes: form['notes']?.toString() ?? '',
          orderGreigeId:
              int.tryParse(form['order_greige_id']?.toString() ?? ''),
          beamQty: int.tryParse(form['beam_qty']?.toString() ?? '0') ?? 0,
          lengths: (form['lengths'] as List?)
                  ?.map((e) => num.tryParse(e.toString()) ?? 0)
                  .toList() ??
              [],
        );

        final message =
            await Provider.of<WarpingService>(context, listen: false)
                .finishItem(context, id, warping, isLoading);

        Navigator.pushNamedAndRemoveUntil(context, '/warpings', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Warping Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "WRP",
              ));
        });
      },
    );
  }
}
