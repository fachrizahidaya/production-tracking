import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/dyeing/create/create_form.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';

class CreateDyeingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;

  const CreateDyeingManual(
      {super.key, this.id, this.data, this.form, this.handleSubmit});

  @override
  State<CreateDyeingManual> createState() => _CreateDyeingManualState();
}

class _CreateDyeingManualState extends State<CreateDyeingManual> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final WorkOrderService _workOrderService = WorkOrderService();
  bool _firstLoading = false;

  late List<dynamic> workOrderOption = [];
  late List<dynamic> machineOption = [];

  Map<String, dynamic> woData = {};

  @override
  void initState() {
    _handleFetchWorkOrder();
    _handleFetchMachine();

    if (widget.data != null) {
      woData = widget.data!;
    }
    super.initState();
  }

  Future<void> _handleFetchWorkOrder() async {
    await Provider.of<OptionWorkOrderService>(context, listen: false)
        .fetchOptions();
    // ignore: use_build_context_synchronously
    final result = Provider.of<OptionWorkOrderService>(context, listen: false)
        .dataListOption;

    setState(() {
      workOrderOption = result;
    });
  }

  Future<void> _handleFetchMachine() async {
    await Provider.of<OptionMachineService>(context, listen: false)
        .fetchOptions();
    // ignore: use_build_context_synchronously
    final result = Provider.of<OptionMachineService>(context, listen: false)
        .dataListOption;

    setState(() {
      machineOption = result;
    });
  }

  Future<void> _getDataView(id) async {
    setState(() {
      _firstLoading = true;
    });

    await _workOrderService.getDataView(id);

    setState(() {
      woData = _workOrderService.dataView;
      _firstLoading = false;
    });
  }

  _selectWorkOrder() {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SelectDialog(
          label: 'Work Order',
          options: workOrderOption,
          selected: widget.form?['wo_id'].toString() ?? '',
          handleChangeValue: (e) {
            setState(() {
              widget.form?['wo_id'] = e['value'].toString();
              widget.form?['no_wo'] = e['label'].toString();
            });

            _getDataView(e['value'].toString());
          },
        );
      },
    );
  }

  _selectMachine() {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SelectDialog(
          label: 'Mesin',
          options: machineOption
              .where((item) => item['value'].toString() == '1')
              .toList(),
          selected: widget.form?['machine_id'].toString() ?? '',
          handleChangeValue: (e) {
            setState(() {
              widget.form?['machine_id'] = e['value'].toString();
              widget.form?['nama_mesin'] = e['label'].toString();
            });
          },
        );
      },
    );
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
    return Scaffold(
        backgroundColor: const Color(0xFFEBEBEB),
        appBar: CustomAppBar(
          title: 'Mulai Dyeing',
          onReturn: () {
            Navigator.pop(context);
          },
        ),
        body: CreateForm(
          form: widget.form,
          formKey: _formKey,
          handleSubmit: widget.handleSubmit,
          data: woData,
          selectWorkOrder: _selectWorkOrder,
          selectMachine: _selectMachine,
          id: widget.id,
          isLoading: _firstLoading,
        ));
  }
}
