import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/dyeing/rework/create_form.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/models/process/dyeing.dart';

class ReworkDyeingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;

  const ReworkDyeingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput});

  @override
  State<ReworkDyeingManual> createState() => _ReworkDyeingManualState();
}

class _ReworkDyeingManualState extends State<ReworkDyeingManual> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final WorkOrderService _workOrderService = WorkOrderService();
  final DyeingService _dyeingService = DyeingService();

  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();

  late List<dynamic> workOrderOption = [];
  late List<dynamic> machineOption = [];
  late List<dynamic> unitOption = [];

  Map<String, dynamic> woData = {};
  Map<String, dynamic> dyeingData = {};

  var dyeingId = '';

  @override
  void initState() {
    _handleFetchWorkOrder();
    _handleFetchUnit();
    _handleFetchMachine();

    _qtyController.text = widget.form?['qty']?.toString() ?? '';
    _lengthController.text = widget.form?['length']?.toString() ?? '';
    _widthController.text = widget.form?['width']?.toString() ?? '';
    _noteController.text = widget.form?['notes']?.toString() ?? '';

    if (widget.data != null) {
      woData = widget.data!;
    }
    super.initState();
  }

  Future<void> _handleFetchWorkOrder() async {
    await Provider.of<OptionWorkOrderService>(context, listen: false)
        .fetchReworkOptions();
    final result = Provider.of<OptionWorkOrderService>(context, listen: false)
        .dataListRework;

    setState(() {
      workOrderOption = result;
    });
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

  Future<void> _handleFetchMachine() async {
    await Provider.of<OptionMachineService>(context, listen: false)
        .fetchOptions();
    final result = Provider.of<OptionMachineService>(context, listen: false)
        .dataListOption;

    setState(() {
      machineOption = result;
    });
  }

  Future<void> _getDataView(id) async {
    await _workOrderService.getDataView(id);

    setState(() {
      woData = _workOrderService.dataView;
    });
  }

  Future<void> _getDyeingView(id) async {
    await _dyeingService.getDataView(id);

    setState(() {
      dyeingData = _dyeingService.dataView;
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
              dyeingId = e['dyeing_id'].toString();
            });

            _getDataView(e['value'].toString());
            _getDyeingView(e['dyeing_id'].toString());
          },
        );
      },
    );
  }

  _selectUnit() {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SelectDialog(
          label: 'Satuan',
          options: unitOption,
          selected: widget.form?['unit_id'].toString() ?? '',
          handleChangeValue: (e) {
            setState(() {
              widget.form?['unit_id'] = e['value'].toString();
              widget.form?['nama_satuan'] = e['label'].toString();
            });
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
          title: 'Rework Dyeing',
          onReturn: () {
            Navigator.pop(context);
          },
        ),
        body: CreateForm(
          data: woData,
          form: widget.form,
          formKey: _formKey,
          note: _noteController,
          qty: _qtyController,
          width: _widthController,
          length: _lengthController,
          handleSelectWo: _selectWorkOrder,
          handleSelectUnit: _selectUnit,
          handleChangeInput: widget.handleChangeInput,
          handleSubmit: widget.handleSubmit,
          dyeingId: dyeingId,
          dyeingData: dyeingData,
          selectMachine: _selectMachine,
        ));
  }
}
