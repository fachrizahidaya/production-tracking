// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/screens/finish/index.dart';
import 'package:textile_tracking/models/process/packing.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/packing/finish/finish_packing_manual.dart';

class FinishPacking extends StatefulWidget {
  const FinishPacking({super.key});

  @override
  State<FinishPacking> createState() => _FinishPackingState();
}

class _FinishPackingState extends State<FinishPacking> {
  final Map<String, dynamic> _form = {
    'wo_id': null,
    'machine_id': null,
    'weight_unit_id': null,
    'width_unit_id': null,
    'length_unit_id': null,
    'rework_reference_id': null,
    'start_by_id': null,
    'end_by_id': null,
    'weight_per_dozen': null,
    'gsm': null,
    'total_weight': null,
    'notes': '',
    'rework': null,
    'status': null,
    'start_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'end_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'attachments': [],
    'no_wo': '',
    'no_packing': '',
    'nama_mesin': '',
    'nama_satuan_berat': '',
    'nama_satuan_panjang': '',
    'nama_satuan_lebar': '',
    'nama_satuan': '',
  };

  @override
  void initState() {
    final loggedInUser = Provider.of<UserProvider>(context, listen: false).user;
    super.initState();

    setState(() {
      _form['end_by_id'] = loggedInUser?.id;
    });
  }

  @override
  void dispose() {
    _form.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FinishProcess(
      title: 'Selesai Packing',
      fetchWorkOrder: (service) async =>
          await service.fetchPackingFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      formPageBuilder: (context, id, processId, data, form, handleSubmit,
              handleChangeInput) =>
          FinishPackingManual(
        id: id,
        processId: processId,
        data: data,
        form: form,
        handleSubmit: handleSubmit,
        handleChangeInput: handleChangeInput,
        forDyeing: false,
        forPacking: true,
        withItemGrade: true,
        withQtyAndWeight: false,
      ),
      handleSubmitToService: (context, id, form, isLoading) async {
        final packing = Packing(
            wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
            machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
            weight_unit_id:
                int.tryParse(form['weight_unit_id']?.toString() ?? ''),
            width_unit_id:
                int.tryParse(form['width_unit_id']?.toString() ?? ''),
            length_unit_id:
                int.tryParse(form['length_unit_id']?.toString() ?? ''),
            notes: form['notes'],
            weight_per_dozen: form['weight_per_dozen'],
            gsm: form['gsm'],
            total_weight: form['total_weight'],
            start_time: form['start_time'],
            end_time: form['end_time'],
            start_by_id: int.tryParse(form['start_by_id']?.toString() ?? ''),
            end_by_id: int.tryParse(form['end_by_id']?.toString() ?? ''),
            attachments: form['attachments'],
            grades: form['grades']);

        final message =
            await Provider.of<PackingService>(context, listen: false)
                .finishItem(id, packing, isLoading);

        Navigator.pushNamedAndRemoveUntil(context, '/packings', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context, title: 'Packing Selesai', message: message);
        });
      },
      fetchItemGrade: (service) => service.fetchOptions(),
      getItemGradeOptions: (service) => service.dataListOption,
    );
  }
}
