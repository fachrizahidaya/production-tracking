// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/service/finish_process_manual.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/models/process/press_tumbler.dart';

class FinishPressTumblerManual extends StatefulWidget {
  final id;
  final data;
  final form;
  final handleSubmit;
  final handleChangeInput;
  final processId;

  const FinishPressTumblerManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput,
      this.processId});

  @override
  State<FinishPressTumblerManual> createState() =>
      _FinishPressTumblerManualState();
}

class _FinishPressTumblerManualState extends State<FinishPressTumblerManual> {
  final PressTumblerService _pressTumblerService = PressTumblerService();

  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();

  late List<dynamic> workOrderOption = [];
  late List<dynamic> unitOption = [];

  Map<String, dynamic> woData = {};

  var ptId = '';

  @override
  void initState() {
    _weightController.text = widget.form?['weight']?.toString() ?? '';
    _lengthController.text = widget.form?['length']?.toString() ?? '';
    _widthController.text = widget.form?['width']?.toString() ?? '';
    _noteController.text = widget.form?['notes']?.toString() ?? '';

    if (widget.data != null) {
      woData = widget.data!;
    }

    _handleFetchWorkOrder();
    _handleFetchUnit();
    super.initState();
  }

  Future<void> _handleFetchWorkOrder() async {
    try {
      await Provider.of<OptionWorkOrderService>(context, listen: false)
          .fetchPressFinishOptions();
      final result = Provider.of<OptionWorkOrderService>(context, listen: false)
          .dataListOption;

      setState(() {
        workOrderOption = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    } finally {}
  }

  Future<void> _handleFetchUnit() async {
    await Provider.of<OptionUnitService>(context, listen: false)
        .getDataListOption();
    final result =
        Provider.of<OptionUnitService>(context, listen: false).dataListOption;

    setState(() {
      unitOption = result;
    });
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
      title: 'Selesai Press',
      id: widget.id,
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      machineFilterValue: '2',
      fetchWorkOrder: (service) => service.fetchPressFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      processService: _pressTumblerService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'press_id',
      withItemGrade: false,
      processId: widget.processId,
    );
  }
}
