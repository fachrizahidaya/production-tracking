import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/form/create/create_form.dart';
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
  final fetchMachine;
  final getMachineOptions;
  final maklon;
  final isMaklon;
  final canMaklonAndMachine;

  const CreateProcessManual(
      {super.key,
      required this.title,
      this.machineFilterValue,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.getWorkOrderOptions,
      this.fetchMachine,
      this.getMachineOptions,
      this.maklon,
      this.isMaklon,
      this.canMaklonAndMachine});

  @override
  State<CreateProcessManual> createState() => _CreateProcessManualState();
}

class _CreateProcessManualState extends State<CreateProcessManual> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final WorkOrderService _workOrderService = WorkOrderService();

  bool _firstLoading = false;
  bool _isFetchingWorkOrder = false;
  bool _isFetchingMachine = false;
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
      debugPrint("Error fetching work orders: $e");
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

      // await service.fetchOptionsPressTumbler();
      // var result = service.dataListOption;

      // if (widget.machineFilterValue != null &&
      //     widget.machineFilterValue!.isNotEmpty) {
      //   result = result.toList();
      // }

      final data = widget.getMachineOptions != null
          ? widget.getMachineOptions!(service)
          : service.dataListOption;

      setState(() {
        machineOption = data;
      });
    } catch (e) {
      debugPrint("Error fetching work orders: $e");
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
            });
            _getDataView(selected['value'].toString());
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
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar: CustomAppBar(
        title: widget.title,
        onReturn: () => Navigator.pop(context),
      ),
      body: CreateForm(
        formKey: _formKey,
        form: widget.form,
        maklon: widget.maklon,
        isMaklon: widget.isMaklon,
        handleSubmit: widget.handleSubmit,
        data: woData,
        selectWorkOrder: _selectWorkOrder,
        selectMachine: _selectMachine,
        id: widget.id,
        isLoading: _firstLoading,
        canMaklonAndMachine: widget.canMaklonAndMachine,
      ),
    );
  }
}
