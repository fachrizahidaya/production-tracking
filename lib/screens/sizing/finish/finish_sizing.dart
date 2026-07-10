import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/models/process/press_tumbler.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/finish/index.dart';
import 'package:textile_tracking/screens/sizing/finish/finish_form.dart';
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
      title: 'Selesai Sizing',
      label: 'Sizing',
      fetchWorkOrder: (service) async =>
          await service.fetchSizingFinishOptions(),
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
        final sizing = Sizing(
          notes: form['notes'],
          attachments: form['attachments'],
        );

        final message = await Provider.of<SizingService>(context, listen: false)
            .finishItem(context, id, sizing, isLoading);

        Navigator.pushNamedAndRemoveUntil(context, '/sizing', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Sizing Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "SIZ",
              ));
        });
      },
    );
  }
}
