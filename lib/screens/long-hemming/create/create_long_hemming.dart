import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/service/create_process.dart';
import 'package:textile_tracking/models/process/long_hemming.dart';
import 'package:textile_tracking/screens/long-hemming/create/create_long_hemming_manual.dart';

class CreateLongHemming extends StatelessWidget {
  const CreateLongHemming({super.key});

  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
    final longHemming = LongHemming(
      wo_id:
          form['wo_id'] != null ? int.tryParse(form['wo_id'].toString()) : null,
      weight_unit_id: form['unit_id'] != null
          ? int.tryParse(form['unit_id'].toString())
          : null,
      machine_id: form['machine_id'] != null
          ? int.tryParse(form['machine_id'].toString())
          : null,
      weight: form['weight'],
      width: form['width'],
      length: form['length'],
      notes: form['notes'],
      status: form['status'],
      start_time: form['start_time'],
      end_time: form['end_time'],
      start_by_id: form['start_by_id'] != null
          ? int.tryParse(form['start_by_id'].toString())
          : null,
      end_by_id: form['end_by_id'],
      attachments: form['attachments'],
    );

    final message =
        await Provider.of<LongHemmingService>(context, listen: false)
            .addItem(longHemming, isLoading);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

    Navigator.pushNamedAndRemoveUntil(
        context, '/long-hemmings', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return CreateProcess(
      title: 'Mulai Long Hemming',
      handleSubmitToService: _submitToService,
      formPageBuilder: (context, id, data, form, handleSubmit) {
        return CreateLongHemmingManual(
          id: id,
          data: data,
          form: form,
          handleSubmit: handleSubmit,
          fetchWorkOrder: (service) => service.fetchLongHemmingOptions(id),
        );
      },
      fetchWorkOrder: (service) => service.fetchLongHemmingOptions(),
      getWorkOrderOptions: (service) => service.dataListLongHemming,
    );
  }
}
