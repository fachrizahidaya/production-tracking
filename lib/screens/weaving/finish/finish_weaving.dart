// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/finish/index.dart';
import 'package:textile_tracking/screens/weaving/finish/finish_form.dart';
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
    'wo_id': null,
    'machine_id': null,
    'weight_unit_id': null,
    'width_unit_id': null,
    'length_unit_id': null,
    'start_by_id': null,
    'end_by_id': null,
    'weight': null,
    'width': null,
    'length': null,
    'notes': '',
    'rework': null,
    'status': null,
    'start_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'end_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'attachments': [],
    'no_wo': '',
    'no_pt': '',
    'nama_mesin': '',
    'nama_satuan_berat': '',
    'nama_satuan_panjang': '',
    'nama_satuan_lebar': '',
    'nama_satuan': '',
  };

  @override
  void dispose() {
    _form.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FinishProcess(
      title: 'Selesai Weaving',
      label: 'Weaving',
      fetchWorkOrder: (service) async => await null,
      getWorkOrderOptions: (service) => service.dataListOption,
      formPageBuilder: (context, id, processId, data, form, handleSubmit,
              handleChangeInput, finishedItemOption, finishedItemOptionGrb) =>
          FinishForm(
        id: id,
        processId: processId,
        data: data,
        form: form,
        handleSubmit: handleSubmit,
        handleChangeInput: handleChangeInput,
        forDyeing: false,
        withItemGrade: false,
        withQtyAndWeight: false,
      ),
      handleSubmitToService: (context, id, form, isLoading) async {
        final weaving = Weaving(
          notes: form['notes'],
          attachments: form['attachments'],
        );

        final message =
            await Provider.of<WeavingService>(context, listen: false)
                .finishItem(context, id, weaving, isLoading);

        Navigator.pushNamedAndRemoveUntil(context, '/weaving', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Weaving Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "WEA",
              ));
        });
      },
    );
  }
}
