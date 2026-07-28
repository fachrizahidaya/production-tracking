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
>>>>>>> 5d1f483f (fix: warping, sizing)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/sizing/finish/finish_form.dart';
import 'package:textile_tracking/screens/sizing/finish/finish_sizing_process.dart';
=======
import 'package:textile_tracking/models/process/press_tumbler.dart';
=======
>>>>>>> bb29b60 (fix: clear warning)
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/sizing/finish/finish_form.dart';
<<<<<<< HEAD
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
import 'package:textile_tracking/screens/sizing/finish/finish_sizing_process.dart';
>>>>>>> 5d1f483f (fix: warping, sizing)
import 'package:textile_tracking/screens/sizing/model/sizing.dart';

class FinishSizing extends StatefulWidget {
  const FinishSizing({super.key});

  @override
  State<FinishSizing> createState() => _FinishSizingState();
}

class _FinishSizingState extends State<FinishSizing> {
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
    'roll_length': null,
    'notes': '',
    'attachments': [],
    'machines': [],
=======
    'wo_id': null,
=======
    'order_greige_id': null,
>>>>>>> 5d1f483f (fix: warping, sizing)
    'machine_id': null,
    'roll_length': null,
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
>>>>>>> 5d1f483f (fix: warping, sizing)
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
    return FinishSizingProcess(
      title: 'Selesai Sizing',
      formPageBuilder: (context, id, processId, data, form, handleSubmit,
              handleChangeInput) =>
=======
    return FinishProcess(
=======
    return FinishSizingProcess(
>>>>>>> 5d1f483f (fix: warping, sizing)
      title: 'Selesai Sizing',
      formPageBuilder: (context, id, processId, data, form, handleSubmit,
<<<<<<< HEAD
              handleChangeInput, finishedItemOption, finishedItemOptionGrb) =>
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
              handleChangeInput) =>
>>>>>>> 5d1f483f (fix: warping, sizing)
          FinishForm(
        id: id,
        processId: processId,
        data: data,
        form: form,
        handleSubmit: handleSubmit,
        handleChangeInput: handleChangeInput,
<<<<<<< HEAD
<<<<<<< HEAD
=======
        forDyeing: false,
        withItemGrade: false,
        withQtyAndWeight: false,
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
>>>>>>> 5d1f483f (fix: warping, sizing)
      ),
      handleSubmitToService: (context, id, form, isLoading) async {
        final sizing = Sizing(
          notes: form['notes'],
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 5d1f483f (fix: warping, sizing)
          panjangGulungan: form['roll_length'],
          orderGreigeId:
              int.tryParse(form['order_greige_id']?.toString() ?? ''),
          machineId: int.tryParse(form['machine_id']?.toString() ?? ''),
<<<<<<< HEAD
=======
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
          attachments: form['attachments'],
=======
>>>>>>> 5d1f483f (fix: warping, sizing)
        );

        final message = await Provider.of<SizingService>(context, listen: false)
            .finishItem(context, id, sizing, isLoading);

<<<<<<< HEAD
<<<<<<< HEAD
        Navigator.pushNamedAndRemoveUntil(context, '/sizings', (_) => false);
=======
        Navigator.pushNamedAndRemoveUntil(context, '/sizing', (_) => false);
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
        Navigator.pushNamedAndRemoveUntil(context, '/sizings', (_) => false);
>>>>>>> 5d1f483f (fix: warping, sizing)

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Sizing Selesai',
              child: buildBoldMessage(
                message: message,
<<<<<<< HEAD
<<<<<<< HEAD
                prefix: "SZG",
=======
                prefix: "SIZ",
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
                prefix: "SZG",
>>>>>>> 5d1f483f (fix: warping, sizing)
              ));
        });
      },
    );
  }
}
