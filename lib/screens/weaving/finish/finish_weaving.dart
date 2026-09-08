<<<<<<< HEAD
<<<<<<< HEAD
// ignore_for_file: use_build_context_synchronously

<<<<<<< HEAD
=======
=======
// ignore_for_file: use_build_context_synchronously

>>>>>>> bb29b60 (fix: clear warning)
import 'package:easy_localization/easy_localization.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
>>>>>>> 95d1a035 (fix: weaving, shearing)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/providers/user_provider.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/screens/weaving/finish/finish_form.dart';
import 'package:textile_tracking/screens/weaving/finish/finish_weaving_process.dart';
=======
import 'package:textile_tracking/screens/finish/index.dart';
import 'package:textile_tracking/screens/weaving/finish/finish_form.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
import 'package:textile_tracking/screens/weaving/finish/finish_form.dart';
import 'package:textile_tracking/screens/weaving/finish/finish_weaving_process.dart';
>>>>>>> 95d1a035 (fix: weaving, shearing)
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
<<<<<<< HEAD
=======
    'wo_id': null,
=======
    'order_greige_id': null,
>>>>>>> 95d1a035 (fix: weaving, shearing)
    'machine_id': null,
    'notes': '',
<<<<<<< HEAD
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
=======
    'qty': null,
    'weight': null,
    'waste': null,
    'skip_shearing': ''
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
  };

  @override
  void dispose() {
    _form.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
<<<<<<< HEAD
    return FinishWeavingProcess(
      title: 'Selesai Weaving',
      formPageBuilder: (context, id, processId, data, form, handleSubmit,
              handleChangeInput) =>
=======
    return FinishProcess(
=======
    return FinishWeavingProcess(
>>>>>>> 95d1a035 (fix: weaving, shearing)
      title: 'Selesai Weaving',
      formPageBuilder: (context, id, processId, data, form, handleSubmit,
<<<<<<< HEAD
              handleChangeInput, finishedItemOption, finishedItemOptionGrb) =>
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
              handleChangeInput) =>
>>>>>>> 95d1a035 (fix: weaving, shearing)
          FinishForm(
        id: id,
        processId: processId,
        data: data,
        form: form,
        handleSubmit: handleSubmit,
        handleChangeInput: handleChangeInput,
<<<<<<< HEAD
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
<<<<<<< HEAD
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
=======
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
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
          attachments: form['attachments'],
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
        );

        final message =
            await Provider.of<WeavingService>(context, listen: false)
                .finishItem(context, id, weaving, isLoading);

<<<<<<< HEAD
<<<<<<< HEAD
        Navigator.pushNamedAndRemoveUntil(context, '/weavings', (_) => false);
=======
        Navigator.pushNamedAndRemoveUntil(context, '/weaving', (_) => false);
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
        Navigator.pushNamedAndRemoveUntil(context, '/weavings', (_) => false);
>>>>>>> 95d1a035 (fix: weaving, shearing)

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Weaving Selesai',
              child: buildBoldMessage(
                message: message,
<<<<<<< HEAD
<<<<<<< HEAD
                prefix: "WVG",
=======
                prefix: "WEA",
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
                prefix: "WVG",
>>>>>>> 95d1a035 (fix: weaving, shearing)
              ));
        });
      },
    );
  }
}
