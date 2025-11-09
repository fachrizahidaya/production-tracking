import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/service/finish_process.dart';
import 'package:textile_tracking/models/option/option_item_grade.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/models/process/sorting.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/sorting/finish/finish_sorting_manual.dart';

class FinishSorting extends StatefulWidget {
  const FinishSorting({super.key});

  @override
  State<FinishSorting> createState() => _FinishSortingState();
}

class _FinishSortingState extends State<FinishSorting> {
  int number = 0;

  late List<dynamic> workOrderOption = [];
  late List<dynamic> itemGradeOption = [];

  final Map<String, dynamic> _form = {
    'wo_id': null,
    'machine_id': null,
    'unit_id': null,
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
    'grades': [],
    'no_wo': '',
    'no_sorting': '',
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
    _handleFetchItemGrade();
    super.initState();

    setState(() {
      _form['end_by_id'] = loggedInUser?.id;
    });
  }

  Future<void> _handleFetchWorkOrder() async {
    await Provider.of<OptionWorkOrderService>(context, listen: false)
        .fetchSortingFinishOptions();
    final result = Provider.of<OptionWorkOrderService>(context, listen: false)
        .dataListOption;

    setState(() {
      workOrderOption = result;
    });
  }

  Future<void> _handleFetchItemGrade() async {
    await Provider.of<OptionItemGradeService>(context, listen: false)
        .fetchOptions();
    final result = Provider.of<OptionItemGradeService>(context, listen: false)
        .dataListOption;

    setState(() {
      itemGradeOption = result;
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
      title: 'Selesai Sorting',
      fetchWorkOrder: (service) async =>
          await service.fetchSortingFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      formPageBuilder: (context, id, processId, data, form, handleSubmit,
              handleChangeInput) =>
          FinishSortingManual(
        id: id,
        processId: processId,
        data: data,
        form: form,
        handleSubmit: handleSubmit,
        handleChangeInput: handleChangeInput,
      ),
      handleSubmitToService: (context, id, form, isLoading) async {
        final sorting = Sorting(
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
          grades: form['grades'],
        );

        final message =
            await Provider.of<SortingService>(context, listen: false)
                .finishItem(id, sorting, isLoading);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        Navigator.pushNamedAndRemoveUntil(context, '/sortings', (_) => false);
      },
      fetchItemGrade: (service) async => await service.fetchOptions(),
      getItemGradeOptions: (service) => service.dataListOption,
    );
  }
}
