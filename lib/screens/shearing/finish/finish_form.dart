import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:textile_tracking/screens/shearing/finish/finish_shearing_process_manual.dart';
=======
import 'package:textile_tracking/screens/finish/%5Bfinish_process_id%5D.dart';
import 'package:textile_tracking/screens/shearing/model/shearing.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)

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
=======
  final ShearingService _shearingService = ShearingService();

>>>>>>> 7fd183d (feat: create and finish warping, weaving)
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
    return FinishShearingProcessManual(
      id: widget.id,
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      handleChangeInput: widget.handleChangeInput,
      processId: widget.processId,
=======
    return FinishProcessManual(
      title: 'Selesai Shearing',
      id: widget.id,
      data: widget.data,
      label: 'Shearing',
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      fetchWorkOrder: (service) => service.fetchShearingFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      processService: _shearingService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'shearing_id',
      processId: widget.processId,
      forDyeing: widget.forDyeing,
      withItemGrade: widget.withItemGrade,
      withQtyAndWeight: widget.withQtyAndWeight,
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
    );
  }
}
