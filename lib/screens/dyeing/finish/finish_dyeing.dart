// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/screens/finish/index.dart';
import 'package:textile_tracking/models/process/dyeing.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/dyeing/finish/finish_dyeing_manual.dart';

class FinishDyeing extends StatefulWidget {
  const FinishDyeing({super.key});

  @override
  State<FinishDyeing> createState() => _FinishDyeingState();
}

class _FinishDyeingState extends State<FinishDyeing> {
  @override
  void initState() {
    final loggedInUser = Provider.of<UserProvider>(context, listen: false).user;
    super.initState();

    setState(() {
      _form['end_by_id'] = loggedInUser?.id;
    });
  }

  final Map<String, dynamic> _form = {
    'wo_id': null,
    'machine_id': null,
    'unit_id': null,
    'length_unit_id': null,
    'width_unit_id': null,
    'rework_reference_id': null,
    'start_by_id': null,
    'end_by_id': null,
    'qty': null,
    'width': null,
    'length': null,
    'notes': '',
    'rework': null,
    'status': null,
    'start_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'end_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'attachments': [],
    'no_wo': '',
    'no_dyeing': '',
    'nama_mesin': '',
    'nama_satuan': '',
    'nama_satuan_panjang': '',
    'nama_satuan_lebar': '',
    'lot_celup_no': '',
    'greige_item_id': null,
    'nama_greige_item': '',
    'sku_greige_item': '',
    'semifinished_products': [],
    'rework_category': null,
    'rework_type': [],
    'rework_method': [],
  };

  @override
  void dispose() {
    _form.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FinishProcess(
      title: 'Selesai Dyeing',
      label: 'Dyeing',
      fetchWorkOrder: (service) async => await service.fetchFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      getFinishedItemOptions: (service) => service.dataListOption,
      formPageBuilder: (context, id, processId, data, form, handleSubmit,
              handleChangeInput, finishedItemOption, finishedItemOptionGrb) =>
          FinishDyeingManual(
        id: id,
        processId: processId,
        data: data,
        form: form,
        handleSubmit: handleSubmit,
        handleChangeInput: handleChangeInput,
        forDyeing: true,
        withItemGrade: false,
        withQtyAndWeight: false,
        woId: id,
        finishedItemOptions: finishedItemOption,
        finishedItemOptionGrb: finishedItemOptionGrb,
      ),
      handleSubmitToService: (context, id, form, isLoading) async {
        final dyeing = {
          'wo_id': form['wo_id'],
          'machine_id': form['machine_id'],
          'lot_celup_no': form['lot_celup_no'] ?? '',
          'unit_id': form['unit_id'],
          'qty': form['qty'],
          'notes': form['notes'] ?? '',
          'rework': form['rework'] == true ? 1 : 0,
          'rework_category': form['rework_category'],
          'rework_type': form['rework_type'] ?? [],
          'rework_method': form['rework_method'] ?? [],
          '_method': 'PATCH',
          'attachments': form['attachments'],
        };

        final message = await Provider.of<DyeingService>(context, listen: false)
            .finishDyeingItem(context, id, dyeing, isLoading);

        Navigator.pushNamedAndRemoveUntil(context, '/dyeings', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Dyeing Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "DYE",
              ));
        });
      },
    );
  }
}
