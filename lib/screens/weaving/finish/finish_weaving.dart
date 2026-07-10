<<<<<<< HEAD
// ignore_for_file: use_build_context_synchronously

=======
import 'package:easy_localization/easy_localization.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/providers/user_provider.dart';
<<<<<<< HEAD
import 'package:textile_tracking/screens/weaving/finish/finish_form.dart';
import 'package:textile_tracking/screens/weaving/finish/finish_weaving_process.dart';
=======
import 'package:textile_tracking/screens/finish/index.dart';
import 'package:textile_tracking/screens/weaving/finish/finish_form.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
import 'package:textile_tracking/screens/weaving/model/weaving.dart';

class FinishWeaving extends StatefulWidget {
  const FinishWeaving({super.key});

  @override
  State<FinishWeaving> createState() => _FinishWeavingState();
}

class _FinishWeavingState extends State<FinishWeaving> {
  @override
  void initState() {
    final loggedInUser = Provider.of<UserProvider>(context, listen: false).user;

    setState(() {
      _form['end_by_id'] = loggedInUser?.id;
    });

    super.initState();
  }

  final Map<String, dynamic> _form = {
<<<<<<< HEAD
    'order_greige_id': null,
    'machine_id': null,
    'notes': '',
    'qty': null,
    'weight': null,
    'waste': null,
    'skip_shearing': '',
    'machines': [],
    'attachments': [],
=======
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
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
  };

  @override
  void dispose() {
    _form.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return FinishWeavingProcess(
      title: 'Selesai Weaving',
      formPageBuilder: (context, id, processId, data, form, handleSubmit,
              handleChangeInput) =>
=======
    return FinishProcess(
      title: 'Selesai Weaving',
      label: 'Weaving',
      fetchWorkOrder: (service) async =>
          await service.fetchWeavingFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      formPageBuilder: (context, id, processId, data, form, handleSubmit,
              handleChangeInput, finishedItemOption, finishedItemOptionGrb) =>
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
          FinishForm(
        id: id,
        processId: processId,
        data: data,
        form: form,
        handleSubmit: handleSubmit,
        handleChangeInput: handleChangeInput,
<<<<<<< HEAD
      ),
      handleSubmitToService: (context, id, form, isLoading) async {
        final weaving = Weaving(
          machineId: int.tryParse(form['machine_id']?.toString() ?? ''),
          notes: form['notes']?.toString() ?? '',
          qty: num.tryParse(form['qty']?.toString() ?? '0') ?? 0,
          weight: num.tryParse(form['weight']?.toString() ?? '0') ?? 0,
          waste: num.tryParse(form['waste']?.toString() ?? '0') ?? 0,
          orderGreigeId:
              int.tryParse(form['order_greige_id']?.toString() ?? ''),
=======
        forDyeing: false,
        withItemGrade: false,
        withQtyAndWeight: false,
      ),
      handleSubmitToService: (context, id, form, isLoading) async {
        final weaving = Weaving(
          notes: form['notes'],
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
          attachments: form['attachments'],
        );

        final message =
            await Provider.of<WeavingService>(context, listen: false)
                .finishItem(context, id, weaving, isLoading);

<<<<<<< HEAD
        Navigator.pushNamedAndRemoveUntil(context, '/weavings', (_) => false);
=======
        Navigator.pushNamedAndRemoveUntil(context, '/weaving', (_) => false);
>>>>>>> 7fd183d (feat: create and finish warping, weaving)

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Weaving Selesai',
              child: buildBoldMessage(
                message: message,
<<<<<<< HEAD
                prefix: "WVG",
=======
                prefix: "WEA",
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
              ));
        });
      },
    );
  }
}
