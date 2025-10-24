import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/service/create_process.dart';
import 'package:textile_tracking/models/process/sorting.dart';
import 'package:textile_tracking/screens/sorting/create/create_sorting_manual.dart';

class CreateSorting extends StatelessWidget {
  const CreateSorting({super.key});

  Future<void> _submitToService(
      BuildContext context, Map<String, dynamic> form, isLoading) async {
    final sorting = Sorting(
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

    final message = await Provider.of<SortingService>(context, listen: false)
        .addItem(sorting, isLoading);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

    Navigator.pushNamedAndRemoveUntil(context, '/sortings', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return CreateProcess(
      title: 'Mulai Sorting',
      handleSubmitToService: _submitToService,
      formPageBuilder: (context, id, data, form, handleSubmit) {
        return CreateSortingManual(
          id: id,
          data: data,
          form: form,
          handleSubmit: handleSubmit,
          fetchWorkOrder: (service) => service.fetchSortingOptions(id),
        );
      },
      fetchWorkOrder: (service) => service.fetchSortingOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
    );
  }
}
