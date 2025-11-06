import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/service/finish_process.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/models/process/embroidery.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/embroidery/finish/finish_embroidery_manual.dart';

class FinishEmbroidery extends StatefulWidget {
  const FinishEmbroidery({super.key});

  @override
  State<FinishEmbroidery> createState() => _FinishEmbroideryState();
}

class _FinishEmbroideryState extends State<FinishEmbroidery> {
  int number = 0;

  late List<dynamic> workOrderOption = [];

  final Map<String, dynamic> _form = {
    'wo_id': null,
    'machine_id': null,
    'item_unit_id': null,
    'weight_unit_id': null,
    'width_unit_id': null,
    'length_unit_id': null,
    'rework_reference_id': null,
    'start_by_id': null,
    'end_by_id': null,
    'item_qty': null,
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
    'no_emb': '',
    'nama_mesin': '',
    'nama_satuan_berat': '',
    'nama_satuan_panjang': '',
    'nama_satuan_lebar': '',
    'nama_satuan': '',
    'maklon': false,
    'maklon_name': ''
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
        .fetchEmbroideryFinishOptions();
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
      title: 'Selesai Embroidery',
      fetchWorkOrder: (service) async =>
          await service.fetchEmbroideryFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      formPageBuilder: (context, id, processId, data, form, handleSubmit,
              handleChangeInput) =>
          FinishEmbroideryManual(
        id: id,
        processId: processId,
        data: data,
        form: form,
        handleSubmit: handleSubmit,
        handleChangeInput: handleChangeInput,
      ),
      handleSubmitToService: (context, id, form, isLoading) async {
        final embroidery = Embroidery(
            wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
            machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
            unit_id: int.tryParse(form['item_unit_id']?.toString() ?? ''),
            weight_unit_id:
                int.tryParse(form['weight_unit_id']?.toString() ?? ''),
            width_unit_id:
                int.tryParse(form['width_unit_id']?.toString() ?? ''),
            length_unit_id:
                int.tryParse(form['length_unit_id']?.toString() ?? ''),
            qty: form['item_qty'],
            weight: form['weight'],
            width: form['width'],
            length: form['length'],
            notes: form['notes'],
            start_time: form['start_time'],
            end_time: form['end_time'],
            start_by_id: int.tryParse(form['start_by_id']?.toString() ?? ''),
            end_by_id: int.tryParse(form['end_by_id']?.toString() ?? ''),
            attachments: form['attachments'],
            maklon: form['maklon'],
            maklon_name: form['maklon_name']);

        final message =
            await Provider.of<EmbroideryService>(context, listen: false)
                .finishItem(id, embroidery, isLoading);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        Navigator.pushNamedAndRemoveUntil(
            context, '/embroideries', (_) => false);
      },
    );
  }
}
