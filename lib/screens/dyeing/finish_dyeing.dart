import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:production_tracking/components/dyeing/create_form.dart';
import 'package:production_tracking/components/master/dialog/select_dialog.dart';
import 'package:production_tracking/components/master/layout/custom_app_bar.dart';
import 'package:production_tracking/helpers/result/show_alert_dialog.dart';
import 'package:production_tracking/models/option/option_dyeing.dart';
import 'package:production_tracking/models/option/option_machine.dart';
import 'package:production_tracking/models/option/option_unit.dart';
import 'package:production_tracking/models/option/option_work_order.dart';
import 'package:production_tracking/models/process/dyeing.dart';
import 'package:provider/provider.dart';

class FinishDyeing extends StatefulWidget {
  const FinishDyeing({super.key});

  @override
  State<FinishDyeing> createState() => _FinishDyeingState();
}

class _FinishDyeingState extends State<FinishDyeing> {
  final ValueNotifier<bool> _firstLoading = ValueNotifier(false);

  final GlobalKey<FormState> _formKey = GlobalKey();
  late final List<dynamic> _addItems = [];
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();

  late List<dynamic> workOrderOption = [];
  late List<dynamic> machineOption = [];
  late List<dynamic> unitOption = [];
  late List<dynamic> dyeingOption = [];

  final Map<String, dynamic> _form = {
    'wo_id': null,
    'machine_id': null,
    'unit_id': null,
    'rework_reference_id': null,
    'start_by_id': null,
    'end_by_id': null,
    'qty': null,
    'width': null,
    'length': null,
    'notes': '',
    'rework': null,
    'status': null,
    'start_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'end_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'attachments': [],
    'no_wo': '',
    'no_dyeing': '',
    'nama_mesin': '',
    'nama_satuan': '',
  };

  @override
  void initState() {
    _handleFetchWorkOrder();
    _handleFetchMachine();
    _handleFetchUnit();
    _handleFetchDyeing();
    super.initState();
  }

  void _handleChangeInput(fieldName, value) {
    setState(() {
      _form[fieldName] = value;
    });
  }

  Future<void> _handleFetchWorkOrder() async {
    await Provider.of<OptionWorkOrderService>(context, listen: false)
        .fetchOptions();
    final result = Provider.of<OptionWorkOrderService>(context, listen: false)
        .dataListOption;

    setState(() {
      workOrderOption = result;
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

  Future<void> _handleFetchUnit() async {
    await Provider.of<OptionUnitService>(context, listen: false)
        .getDataListOption();
    final result =
        Provider.of<OptionUnitService>(context, listen: false).dataListOption;

    setState(() {
      unitOption = result;
    });
  }

  Future<void> _handleFetchDyeing() async {
    await Provider.of<OptionDyeingService>(context, listen: false)
        .fetchOptions();
    final result =
        Provider.of<OptionDyeingService>(context, listen: false).dataListOption;

    setState(() {
      dyeingOption = result;
    });
  }

  Future<void> _handleSubmit() async {
    try {
      if (_addItems.isNotEmpty) {
        final dyeing = Dyeing(
            wo_id: _form['wo_id'],
            unit_id: _form['unit_id'],
            machine_id: _form['machine_id'],
            rework_reference_id: _form['rework_reference_id'],
            qty: _form['qty'],
            width: _form['width'],
            length: _form['length'],
            notes: _form['notes'],
            rework: _form['rework'],
            status: _form['status'],
            start_time: _form['start_time'],
            end_time: _form['end_time'],
            start_by_id: _form['start_by_id'],
            end_by_id: _form['end_by_id'],
            attachments: _form['attachments']);
        await Provider.of<DyeingService>(context, listen: false)
            .addItem(dyeing, _firstLoading);
        Navigator.pop(context);
      } else {
        showAlertDialog(
            context: context,
            title: 'Failed',
            message: 'Data tidak boleh kosong!');
      }
    } catch (e) {
      Navigator.pop(context);
      showAlertDialog(context: context, title: 'Error', message: e.toString());
    }
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
          selected: _form['wo_id'].toString(),
          handleChangeValue: (e) {
            setState(() {
              _form['wo_id'] = e['value'].toString();
              _form['no_wo'] = e['label'].toString();
            });
          },
        );
      },
    );
  }

  _selectDyeing() {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SelectDialog(
          label: 'Dyeing',
          options: dyeingOption,
          selected: _form['rework_reference_id'].toString(),
          handleChangeValue: (e) {
            setState(() {
              _form['rework_reference_id'] = e['value'].toString();
              _form['no_dyeing'] = e['label'].toString();
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
          options: machineOption,
          selected: _form['machine_id'].toString(),
          handleChangeValue: (e) {
            setState(() {
              _form['machine_id'] = e['value'].toString();
              _form['nama_mesin'] = e['label'].toString();
            });
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
          selected: _form['unit_id'].toString(),
          handleChangeValue: (e) {
            setState(() {
              _form['unit_id'] = e['value'].toString();
              _form['nama_satuan'] = e['label'].toString();
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar: CustomAppBar(
        title: 'Finish Dyeing',
        onReturn: () {
          Navigator.pop(context);
        },
      ),
      body: CreateForm(
        formKey: _formKey,
        form: _form,
        note: _noteController,
        qty: _qtyController,
        width: _widthController,
        length: _lengthController,
        handleSelectWo: _selectWorkOrder,
        handleSelectDyeing: _selectDyeing,
        handleSelectUnit: _selectUnit,
        handleSelectMachine: _selectMachine,
        handleChangeInput: _handleChangeInput,
        handleSubmit: _handleSubmit,
      ),
    );
  }
}
