import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/dyeing/create/create_form.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';

class CreateProcessManual extends StatefulWidget {
  final String title;
  final String? machineFilterValue;
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final getWorkOrderOptions;

  const CreateProcessManual(
      {super.key,
      required this.title,
      this.machineFilterValue,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.getWorkOrderOptions});

  @override
  State<CreateProcessManual> createState() => _CreateProcessManualState();
}

class _CreateProcessManualState extends State<CreateProcessManual> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final WorkOrderService _workOrderService = WorkOrderService();

  bool _firstLoading = false;
  List<dynamic> workOrderOption = [];
  List<dynamic> machineOption = [];
  Map<String, dynamic> woData = {};

  @override
  void initState() {
    super.initState();
    _fetchWorkOrder();
    _fetchMachine();

    if (widget.data != null) {
      woData = widget.data!;
    }
  }

  Future<void> _fetchWorkOrder() async {
    final service = Provider.of<OptionWorkOrderService>(context, listen: false);

    if (widget.fetchWorkOrder != null) {
      await widget.fetchWorkOrder!(service);
    } else {
      await service.fetchOptions();
    }

    final data = widget.getWorkOrderOptions != null
        ? widget.getWorkOrderOptions!(service)
        : service.dataListOption;

    setState(() {
      workOrderOption = data;
    });
  }

  Future<void> _fetchMachine() async {
    final machineService =
        Provider.of<OptionMachineService>(context, listen: false);
    await machineService.fetchOptions();
    var result = machineService.dataListOption;

    if (widget.machineFilterValue != null &&
        widget.machineFilterValue!.isNotEmpty) {
      result = result
          .where((item) =>
              item['value'].toString() == widget.machineFilterValue.toString())
          .toList();
    }

    setState(() {
      machineOption = result;
    });
  }

  Future<void> _getDataView(String id) async {
    setState(() {
      _firstLoading = true;
    });

    await _workOrderService.getDataView(id);

    setState(() {
      woData = _workOrderService.dataView;
      _firstLoading = false;
    });
  }

  void _selectWorkOrder() {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SelectDialog(
          label: 'Work Order',
          options: workOrderOption,
          selected: widget.form?['wo_id']?.toString() ?? '',
          handleChangeValue: (selected) {
            setState(() {
              widget.form?['wo_id'] = selected['value'].toString();
              widget.form?['no_wo'] = selected['label'].toString();
            });
            _getDataView(selected['value'].toString());
          },
        );
      },
    );
  }

  void _selectMachine() {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SelectDialog(
          label: 'Mesin',
          options: machineOption,
          selected: widget.form?['machine_id']?.toString() ?? '',
          handleChangeValue: (selected) {
            setState(() {
              widget.form?['machine_id'] = selected['value'].toString();
              widget.form?['nama_mesin'] = selected['label'].toString();
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    widget.form?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar: CustomAppBar(
        title: widget.title,
        onReturn: () => Navigator.pop(context),
      ),
      body: CreateForm(
        formKey: _formKey,
        form: widget.form,
        handleSubmit: widget.handleSubmit,
        data: woData,
        selectWorkOrder: _selectWorkOrder,
        selectMachine: _selectMachine,
        id: widget.id,
        isLoading: _firstLoading,
      ),
    );
  }
}
