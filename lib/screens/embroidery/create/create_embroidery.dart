import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/service/create_process.dart';
import 'package:textile_tracking/models/process/embroidery.dart';
import 'package:textile_tracking/screens/embroidery/create/create_emboridery_manual.dart';

class CreateEmbroidery extends StatelessWidget {
  const CreateEmbroidery({super.key});

  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
    final embroidery = Embroidery(
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
      maklon: form['maklon'],
      maklon_name: form['maklon_name'],
    );

    final message = await Provider.of<EmbroideryService>(context, listen: false)
        .addItem(embroidery, isLoading);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

    Navigator.pushNamedAndRemoveUntil(
        context, '/embroideries', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return CreateProcess(
        title: 'Mulai Embroidery',
        handleSubmitToService: _submitToService,
        formPageBuilder: (context, id, data, form, handleSubmit) {
          return CreateEmborideryManual(
            id: id,
            data: data,
            form: form,
            handleSubmit: handleSubmit,
            fetchWorkOrder: (service) => service.fetchEmbroideryOptions(id),
          );
        },
        fetchWorkOrder: (service) => service.fetchEmbroideryOptions(),
        getWorkOrderOptions: (service) => service.dataListOption);
  }
}
