<<<<<<< HEAD
<<<<<<< HEAD
// ignore_for_file: use_build_context_synchronously

=======
=======
// ignore_for_file: use_build_context_synchronously

>>>>>>> bb29b60 (fix: clear warning)
import 'package:easy_localization/easy_localization.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
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
import 'package:textile_tracking/screens/finish/index.dart';
import 'package:textile_tracking/screens/sizing/finish/finish_form.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
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
    'order_greige_id': null,
    'machine_id': null,
    'roll_length': null,
    'notes': '',
    'attachments': [],
    'machines': [],
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
    return FinishSizingProcess(
      title: 'Selesai Sizing',
      formPageBuilder: (context, id, processId, data, form, handleSubmit,
              handleChangeInput) =>
=======
    return FinishProcess(
      title: 'Selesai Sizing',
      label: 'Sizing',
      fetchWorkOrder: (service) async =>
          await service.fetchSizingFinishOptions(),
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
=======
        forDyeing: false,
        withItemGrade: false,
        withQtyAndWeight: false,
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
      ),
      handleSubmitToService: (context, id, form, isLoading) async {
        final sizing = Sizing(
          notes: form['notes'],
<<<<<<< HEAD
          panjangGulungan: form['roll_length'],
          orderGreigeId:
              int.tryParse(form['order_greige_id']?.toString() ?? ''),
          machineId: int.tryParse(form['machine_id']?.toString() ?? ''),
=======
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
          attachments: form['attachments'],
        );

        final message = await Provider.of<SizingService>(context, listen: false)
            .finishItem(context, id, sizing, isLoading);

<<<<<<< HEAD
        Navigator.pushNamedAndRemoveUntil(context, '/sizings', (_) => false);
=======
        Navigator.pushNamedAndRemoveUntil(context, '/sizing', (_) => false);
>>>>>>> 7fd183d (feat: create and finish warping, weaving)

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Sizing Selesai',
              child: buildBoldMessage(
                message: message,
<<<<<<< HEAD
                prefix: "SZG",
=======
                prefix: "SIZ",
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
              ));
        });
      },
    );
  }
}
