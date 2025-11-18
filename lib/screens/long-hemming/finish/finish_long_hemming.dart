// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/service/finish_process.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/models/process/long_hemming.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/long-hemming/finish/finish_long_hemming_manual.dart';

class FinishLongHemming extends StatefulWidget {
  const FinishLongHemming({super.key});

  @override
  State<FinishLongHemming> createState() => _FinishLongHemmingState();
}

class _FinishLongHemmingState extends State<FinishLongHemming> {
  int number = 0;

  late List<dynamic> workOrderOption = [];

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
    'width': null,
    'length': null,
    'notes': '',
    'rework': null,
    'status': null,
    'start_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'end_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'attachments': [],
    'no_wo': '',
    'no_lh': '',
    'nama_mesin': '',
    'nama_satuan_berat': '',
    'nama_satuan_panjang': '',
    'nama_satuan_lebar': '',
    'nama_satuan': '',
  };

  @override
  void initState() {
    final loggedInUser = Provider.of<UserProvider>(context, listen: false).user;
    _handleFetchWorkOrder();
    super.initState();

    setState(() {
      _form['end_by_id'] = loggedInUser?.id;
    });
  }

  Future<void> _handleFetchWorkOrder() async {
    await Provider.of<OptionWorkOrderService>(context, listen: false)
        .fetchHemmingFinishOptions();
    final result = Provider.of<OptionWorkOrderService>(context, listen: false)
        .dataListOption;

    setState(() {
      workOrderOption = result;
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
      title: 'Selesai Long Hemming',
      fetchWorkOrder: (service) async =>
          await service.fetchHemmingFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      formPageBuilder: (context, id, processId, data, form, handleSubmit,
              handleChangeInput) =>
          FinishLongHemmingManual(
        id: id,
        processId: processId,
        data: data,
        form: form,
        handleSubmit: handleSubmit,
        handleChangeInput: handleChangeInput,
      ),
      handleSubmitToService: (context, id, form, isLoading) async {
        final longHemming = LongHemming(
          wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
          machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
          weight_unit_id:
              int.tryParse(form['weight_unit_id']?.toString() ?? ''),
          width_unit_id: int.tryParse(form['width_unit_id']?.toString() ?? ''),
          length_unit_id:
              int.tryParse(form['length_unit_id']?.toString() ?? ''),
          weight: form['weight'],
          width: form['width'],
          length: form['length'],
          notes: form['notes'],
          start_time: form['start_time'],
          end_time: form['end_time'],
          start_by_id: int.tryParse(form['start_by_id']?.toString() ?? ''),
          end_by_id: int.tryParse(form['end_by_id']?.toString() ?? ''),
          attachments: form['attachments'],
        );

        final message =
            await Provider.of<LongHemmingService>(context, listen: false)
                .finishItem(id, longHemming, isLoading);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        Navigator.pushNamedAndRemoveUntil(
            context, '/long-hemmings', (_) => false);
      },
    );
  }
}
