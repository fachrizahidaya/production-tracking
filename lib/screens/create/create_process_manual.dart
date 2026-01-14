// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/process/create/tab_section.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';

class CreateProcessManual extends StatefulWidget {
  final String title;
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final getWorkOrderOptions;
  final fetchMachine;
  final getMachineOptions;
  final maklon;
  final label;
  final withMaklonOrMachine;
  final withOnlyMaklon;
  final withNoMaklonOrMachine;
  final processService;
  final processId;
  final idProcess;

  const CreateProcessManual(
      {super.key,
      required this.title,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.getWorkOrderOptions,
      this.fetchMachine,
      this.getMachineOptions,
      this.maklon,
      this.label,
      this.withMaklonOrMachine,
      this.withOnlyMaklon,
      this.withNoMaklonOrMachine,
      this.processService,
      this.processId,
      this.idProcess});

  @override
  State<CreateProcessManual> createState() => _CreateProcessManualState();
}

class _CreateProcessManualState extends State<CreateProcessManual> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final WorkOrderService _workOrderService = WorkOrderService();
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

  bool _firstLoading = false;
  bool _isFetchingWorkOrder = false;
  bool _isFetchingMachine = false;
  List<dynamic> workOrderOption = [];
  List<dynamic> machineOption = [];

  Map<String, dynamic> data = {};
  Map<String, dynamic> woData = {};

  var processId = '';

  @override
  void initState() {
    super.initState();
    _fetchWorkOrder();
    _fetchMachine();

    if (widget.processId != null) {
      _getProcessView(widget.processId);
    }
  }

  Future<void> _fetchWorkOrder() async {
    setState(() {
      _isFetchingWorkOrder = true;
    });

    final service = Provider.of<OptionWorkOrderService>(context, listen: false);

    try {
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    } finally {
      setState(() {
        _isFetchingWorkOrder = false;
      });
    }
  }

  Future<void> _fetchMachine() async {
    setState(() {
      _isFetchingMachine = true;
    });

    final service = Provider.of<OptionMachineService>(context, listen: false);

    try {
      if (widget.fetchMachine != null) {
        await widget.fetchMachine!(service);
      } else {
        await service.fetchOptions();
      }

      final data = widget.getMachineOptions != null
          ? widget.getMachineOptions!(service)
          : service.dataListOption;

      setState(() {
        machineOption = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    } finally {
      setState(() {
        _isFetchingMachine = false;
      });
    }
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

  Future<void> _getProcessView(id) async {
    await widget.processService.getDataView(id);

    setState(() {
      data = widget.processService.dataView;
    });
  }

  void _selectWorkOrder() {
    if (_isFetchingWorkOrder) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      return;
    }

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
              processId = selected[widget.idProcess].toString();
            });
            _getDataView(selected['value'].toString());
            _getProcessView(selected[widget.idProcess].toString());
          },
        );
      },
    );
  }

  void _selectMachine() {
    if (_isFetchingMachine) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      return;
    }

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
    return DefaultTabController(
      length:
          // 1,
          2,
      child: TabSection(
        id: widget.id,
        title: widget.title,
        maklon: widget.maklon,
        form: widget.form,
        label: widget.label,
        formKey: _formKey,
        woData: woData,
        processData: data,
        withMaklonOrMachine: widget.withMaklonOrMachine,
        withNoMaklonOrMachine: widget.withNoMaklonOrMachine,
        withOnlyMaklon: widget.withOnlyMaklon,
        handleSubmit: widget.handleSubmit,
        firstLoading: _firstLoading,
        isSubmitting: _isSubmitting,
        selectMachine: _selectMachine,
        selectWorkOrder: _selectWorkOrder,
      ),
    );
  }
}
