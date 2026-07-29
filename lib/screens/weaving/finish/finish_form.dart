import 'package:flutter/material.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/screens/weaving/finish/finish_weaving_process_manual.dart';
=======
import 'package:textile_tracking/screens/finish/%5Bfinish_process_id%5D.dart';
import 'package:textile_tracking/screens/weaving/model/weaving.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
import 'package:textile_tracking/screens/weaving/finish/finish_weaving_process_manual.dart';
>>>>>>> 95d1a035 (fix: weaving, shearing)

class FinishForm extends StatefulWidget {
  final id;
  final data;
  final form;
  final handleSubmit;
  final handleChangeInput;
  final processId;
  final forPacking;
  final withItemGrade;
  final withQtyAndWeight;
  final forDyeing;

  const FinishForm(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput,
      this.processId,
      this.forDyeing,
      this.forPacking,
      this.withItemGrade,
      this.withQtyAndWeight});

  @override
  State<FinishForm> createState() => _FinishFormState();
}

class _FinishFormState extends State<FinishForm> {
<<<<<<< HEAD
<<<<<<< HEAD
=======
  final WeavingService _weavingService = WeavingService();

>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
>>>>>>> 95d1a035 (fix: weaving, shearing)
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (widget.form != null) {
      widget.form!.clear();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
<<<<<<< HEAD
    return FinishWeavingProcessManual(
      id: widget.id,
      processId: widget.processId,
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      handleChangeInput: widget.handleChangeInput,
=======
    return FinishProcessManual(
      title: 'Selesai Weaving',
=======
    return FinishWeavingProcessManual(
>>>>>>> 95d1a035 (fix: weaving, shearing)
      id: widget.id,
      processId: widget.processId,
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      handleChangeInput: widget.handleChangeInput,
<<<<<<< HEAD
      idProcess: 'weaving_id',
      processId: widget.processId,
      forDyeing: widget.forDyeing,
      withItemGrade: widget.withItemGrade,
      withQtyAndWeight: widget.withQtyAndWeight,
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
>>>>>>> 95d1a035 (fix: weaving, shearing)
    );
  }
}
