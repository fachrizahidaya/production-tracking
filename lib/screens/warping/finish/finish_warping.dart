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
import 'package:textile_tracking/providers/user_provider.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/screens/warping/finish/finish_form.dart';
import 'package:textile_tracking/screens/warping/finish/finish_warping_process.dart';
=======
import 'package:textile_tracking/screens/finish/index.dart';
import 'package:textile_tracking/screens/warping/finish/finish_form.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
import 'package:textile_tracking/screens/warping/finish/finish_form.dart';
import 'package:textile_tracking/screens/warping/finish/finish_warping_process.dart';
>>>>>>> 5d1f483f (fix: warping, sizing)
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
<<<<<<< HEAD
    'order_greige_id': null,
    'machine_id': null,
    'yarn_qty': null,
    'notes': '',
    'warping_type': '',
    'beam_qty': null,
    'section': null,
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
    'length': null,
    'weight': null,
    'broken_yarns': [],
    'machines': [],
    'attachments': []
=======
    'wo_id': null,
=======
    'order_greige_id': null,
>>>>>>> 5d1f483f (fix: warping, sizing)
    'machine_id': null,
    'yarn_qty': null,
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
    'warping_type': '',
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
    'lengths': [],
<<<<<<< HEAD
>>>>>>> e02e3ffb (fix: finish warping)
=======
    'attachments': []
>>>>>>> 64274789 (fix: selesai warping-shearing)
=======
    'lengths': [],
>>>>>>> 11f11e32 (fix: finish warping)
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
    return FinishWarpingProcess(
      title: 'Selesai Warping',
      formPageBuilder: (context, id, processId, data, form, handleSubmit,
              handleChangeInput) =>
=======
    return FinishProcess(
=======
    return FinishWarpingProcess(
>>>>>>> 5d1f483f (fix: warping, sizing)
      title: 'Selesai Warping',
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
      ),
      handleSubmitToService: (context, id, form, isLoading) async {
        final warping = Warping(
          machineId: int.tryParse(form['machine_id']?.toString() ?? ''),
          warpingType: form['warping_type']?.toString(),
          yarnQty: num.tryParse(form['yarn_qty']?.toString() ?? '0') ?? 0,
          section: int.tryParse(form['section']?.toString() ?? '0') ?? 0,
          notes: form['notes']?.toString() ?? '',
<<<<<<< HEAD
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
=======
      ),
      handleSubmitToService: (context, id, form, isLoading) async {
        final warping = Warping(
          section: form['section'] == null
              ? null
              : int.tryParse(form['section'].toString()),
          notes: form['notes']?.toString() ?? '',
<<<<<<< HEAD
          orderGreigeId:
              int.tryParse(form['order_greige_id']?.toString() ?? ''),
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
          beamQty: int.tryParse(form['beam_qty']?.toString() ?? '0') ?? 0,
=======
          beamQty: form['beam_qty'] == null
              ? null
              : int.tryParse(form['beam_qty'].toString()),
>>>>>>> 64274789 (fix: selesai warping-shearing)
=======
          orderGreigeId:
              int.tryParse(form['order_greige_id']?.toString() ?? ''),
          beamQty: int.tryParse(form['beam_qty']?.toString() ?? '0') ?? 0,
>>>>>>> 11f11e32 (fix: finish warping)
          lengths: (form['lengths'] as List?)
                  ?.map((e) => num.tryParse(e.toString()) ?? 0)
                  .toList() ??
              [],
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> e02e3ffb (fix: finish warping)
=======
          attachments: form['attachments'],
>>>>>>> 64274789 (fix: selesai warping-shearing)
=======
          length: num.tryParse(form['length']?.toString() ?? ''),
          brokenYarns: List<Map<String, dynamic>>.from(
            form['broken_yarns'] ?? [],
          ),
          attachments: form['attachments'],
          weight: num.tryParse(form['weight']?.toString() ?? '0') ?? 0,
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
=======
>>>>>>> 11f11e32 (fix: finish warping)
        );

        final message =
            await Provider.of<WarpingService>(context, listen: false)
                .finishItem(context, id, warping, isLoading);

<<<<<<< HEAD
<<<<<<< HEAD
        Navigator.pushNamedAndRemoveUntil(context, '/warpings', (_) => false);
=======
        Navigator.pushNamedAndRemoveUntil(context, '/warping', (_) => false);
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
        Navigator.pushNamedAndRemoveUntil(context, '/warpings', (_) => false);
>>>>>>> 5d1f483f (fix: warping, sizing)

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Warping Selesai',
              child: buildBoldMessage(
                message: message,
<<<<<<< HEAD
<<<<<<< HEAD
                prefix: "WRP",
=======
                prefix: "WAR",
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
                prefix: "WRP",
>>>>>>> 5d1f483f (fix: warping, sizing)
              ));
        });
      },
    );
  }
}
