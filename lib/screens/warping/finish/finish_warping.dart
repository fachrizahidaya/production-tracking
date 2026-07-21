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
import 'package:textile_tracking/providers/user_provider.dart';
<<<<<<< HEAD
import 'package:textile_tracking/screens/warping/finish/finish_form.dart';
import 'package:textile_tracking/screens/warping/finish/finish_warping_process.dart';
=======
import 'package:textile_tracking/screens/finish/index.dart';
import 'package:textile_tracking/screens/warping/finish/finish_form.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
import 'package:textile_tracking/screens/warping/model/warping.dart';

class FinishWarping extends StatefulWidget {
  const FinishWarping({super.key});

  @override
  State<FinishWarping> createState() => _FinishWarpingState();
}

class _FinishWarpingState extends State<FinishWarping> {
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
    'yarn_qty': null,
    'notes': '',
    'warping_type': '',
    'beam_qty': null,
    'section': null,
    'length': null,
    'weight': null,
    'broken_yarns': [],
    'machines': [],
    'attachments': []
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
    return FinishWarpingProcess(
      title: 'Selesai Warping',
      formPageBuilder: (context, id, processId, data, form, handleSubmit,
              handleChangeInput) =>
=======
    return FinishProcess(
      title: 'Selesai Warping',
      label: 'Warping',
      fetchWorkOrder: (service) async => await null,
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
        final warping = Warping(
          section: form['section'] == null
              ? null
              : int.tryParse(form['section'].toString()),
          notes: form['notes']?.toString() ?? '',
          length: num.tryParse(form['length']?.toString() ?? ''),
          brokenYarns: List<Map<String, dynamic>>.from(
            form['broken_yarns'] ?? [],
          ),
          attachments: form['attachments'],
          weight: num.tryParse(form['weight']?.toString() ?? '0') ?? 0,
=======
        forDyeing: false,
        withItemGrade: false,
        withQtyAndWeight: false,
      ),
      handleSubmitToService: (context, id, form, isLoading) async {
        final warping = Warping(
          notes: form['notes'],
          attachments: form['attachments'],
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
        );

        final message =
            await Provider.of<WarpingService>(context, listen: false)
                .finishItem(context, id, warping, isLoading);

<<<<<<< HEAD
        Navigator.pushNamedAndRemoveUntil(context, '/warpings', (_) => false);
=======
        Navigator.pushNamedAndRemoveUntil(context, '/warping', (_) => false);
>>>>>>> 7fd183d (feat: create and finish warping, weaving)

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Warping Selesai',
              child: buildBoldMessage(
                message: message,
<<<<<<< HEAD
                prefix: "WRP",
=======
                prefix: "WAR",
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
              ));
        });
      },
    );
  }
}
