// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/master/finish_process_manual.dart';
import 'package:textile_tracking/models/process/dyeing.dart';

class FinishDyeingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;
  final processId;

  const FinishDyeingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput,
      this.processId});

  @override
  State<FinishDyeingManual> createState() => _FinishDyeingManualState();
}

class _FinishDyeingManualState extends State<FinishDyeingManual> {
  final DyeingService _dyeingService = DyeingService();

  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();

  late List<dynamic> workOrderOption = [];
  late List<dynamic> unitOption = [];

  Map<String, dynamic> woData = {};
  Map<String, dynamic> dyeingData = {};

  var dyeingId = '';

  @override
  void initState() {
    _qtyController.text = widget.form?['qty']?.toString() ?? '';
    _lengthController.text = widget.form?['length']?.toString() ?? '0';
    _widthController.text = widget.form?['width']?.toString() ?? '0';
    _noteController.text = widget.form?['notes']?.toString() ?? '';

    if (widget.data != null) {
      woData = widget.data!;
    }

    widget.form?['length'] ??= '0';
    widget.form?['width'] ??= '0';
    widget.form?['length_unit_id'] ??= 4;
    widget.form?['width_unit_id'] ??= 4;

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
    return FinishProcessManual(
      title: 'Selesai Dyeing',
      id: widget.id,
      label: 'Dyeing',
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      fetchWorkOrder: (service) => service.fetchFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      processService: _dyeingService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'dyeing_id',
      withItemGrade: false,
      processId: widget.processId,
      withQtyAndWeight: false,
      forDyeing: true,
    );
  }
}
