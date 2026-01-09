// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/screens/finish/index.dart';
import 'package:textile_tracking/models/process/press_tumbler.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/press-tumbler/finish/finish_press_tumbler_manual.dart';

class FinishPressTumbler extends StatefulWidget {
  const FinishPressTumbler({super.key});

  @override
  State<FinishPressTumbler> createState() => _FinishPressTumblerState();
}

class _FinishPressTumblerState extends State<FinishPressTumbler> {
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
    'rework_reference_id': null,
    'start_by_id': null,
    'end_by_id': null,
    'weight': null,
    'width': '0',
    'length': '0',
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
      title: 'Selesai Press',
      fetchWorkOrder: (service) async =>
          await service.fetchPressFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      formPageBuilder: (context, id, processId, data, form, handleSubmit,
              handleChangeInput) =>
          FinishPressTumblerManual(
        id: id,
        processId: processId,
        data: data,
        form: form,
        handleSubmit: handleSubmit,
        handleChangeInput: handleChangeInput,
      ),
      handleSubmitToService: (context, id, form, isLoading) async {
        final press = PressTumbler(
          wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
          machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
          weight_unit_id:
              int.tryParse(form['weight_unit_id']?.toString() ?? ''),
          width_unit_id: int.tryParse(form['width_unit_id']?.toString() ?? ''),
          length_unit_id:
              int.tryParse(form['length_unit_id']?.toString() ?? ''),
          weight: form['weight'],
          width: _form['width'] =
              (_form['width'] == null || _form['width'].toString().isEmpty)
                  ? '0'
                  : _form['width'],
          length: form['length'] =
              (_form['length'] == null || _form['length'].toString().isEmpty)
                  ? '0'
                  : _form['length'],
          notes: form['notes'],
          start_time: form['start_time'],
          end_time: form['end_time'],
          start_by_id: int.tryParse(form['start_by_id']?.toString() ?? ''),
          end_by_id: int.tryParse(form['end_by_id']?.toString() ?? ''),
          attachments: form['attachments'],
        );

        final message =
            await Provider.of<PressTumblerService>(context, listen: false)
                .finishItem(id, press, isLoading);

        Navigator.pushNamedAndRemoveUntil(context, '/press', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context, title: 'Press Selesai', message: message);
        });
      },
    );
  }
}
