import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/helpers/service/finish_process_manual.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/models/process/press_tumbler.dart';

class FinishPressTumblerManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;

  const FinishPressTumblerManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput});

  @override
  State<FinishPressTumblerManual> createState() =>
      _FinishPressTumblerManualState();
}

class _FinishPressTumblerManualState extends State<FinishPressTumblerManual> {
  final WorkOrderService _workOrderService = WorkOrderService();
  final PressTumblerService _pressTumblerService = PressTumblerService();
  bool _firstLoading = false;
  bool _isFetchingWorkOrder = false;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();

  late List<dynamic> workOrderOption = [];
  late List<dynamic> unitOption = [];

  Map<String, dynamic> woData = {};
  Map<String, dynamic> pressTumblerData = {};

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
    setState(() {
      _isFetchingWorkOrder = true;
    });

    try {
      await Provider.of<OptionWorkOrderService>(context, listen: false)
          .fetchPressFinishOptions();
      // ignore: use_build_context_synchronously
      final result = Provider.of<OptionWorkOrderService>(context, listen: false)
          .dataListOption;

      setState(() {
        workOrderOption = result;
      });
    } catch (e) {
      debugPrint("Error fetching work orders: $e");
    } finally {
      setState(() {
        _isFetchingWorkOrder = false;
      });
    }
  }

  Future<void> _handleFetchUnit() async {
    await Provider.of<OptionUnitService>(context, listen: false)
        .getDataListOption();
    final result =
        // ignore: use_build_context_synchronously
        Provider.of<OptionUnitService>(context, listen: false).dataListOption;

    setState(() {
      unitOption = result;
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

  Future<void> _getPressTumblerView(id) async {
    await _pressTumblerService.getDataView(id);

    setState(() {
      pressTumblerData = _pressTumblerService.dataView;

      if (pressTumblerData['length'] != null) {
        _lengthController.text = pressTumblerData['length'].toString();
        widget.form?['length'] = pressTumblerData['length'];
      }
      if (pressTumblerData['width'] != null) {
        _widthController.text = pressTumblerData['width'].toString();
        widget.form?['width'] = pressTumblerData['width'];
      }
      if (pressTumblerData['weight'] != null) {
        _weightController.text = pressTumblerData['weight'].toString();
        widget.form?['weight'] = pressTumblerData['weight'];
      }
      if (pressTumblerData['notes'] != null) {
        _noteController.text = pressTumblerData['notes'].toString();
        widget.form?['notes'] = pressTumblerData['notes'];
      }
      if (pressTumblerData['machine'] != null) {
        widget.form?['machine_id'] =
            pressTumblerData['machine']['id'].toString();
        widget.form?['nama_mesin'] =
            pressTumblerData['machine']['name'].toString();
      }
      if (pressTumblerData['weight_unit'] != null) {
        widget.form?['weight_unit_id'] =
            pressTumblerData['weight_unit']['id'].toString();
        widget.form?['nama_satuan_berat'] =
            pressTumblerData['weight_unit']['name'].toString();
      }
      if (pressTumblerData['length_unit'] != null) {
        widget.form?['length_unit_id'] =
            pressTumblerData['length_unit']['id'].toString();
        widget.form?['nama_satuan_panjang'] =
            pressTumblerData['length_unit']['name'].toString();
      }
      if (pressTumblerData['width_unit'] != null) {
        widget.form?['width_unit_id'] =
            pressTumblerData['width_unit']['id'].toString();
        widget.form?['nama_satuan_lebar'] =
            pressTumblerData['width_unit']['name'].toString();
      }

      if (pressTumblerData['attachments'] != null) {
        widget.form?['attachments'] =
            List.from(pressTumblerData['attachments']);
      }
    });
  }

  _selectWorkOrder() {
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
          selected: widget.form?['wo_id'].toString() ?? '',
          handleChangeValue: (e) {
            setState(() {
              widget.form?['wo_id'] = e['value'].toString();
              widget.form?['no_wo'] = e['label'].toString();
              ptId = e['press_tumbler_id'].toString();
            });

            _getDataView(e['value'].toString());
            _getPressTumblerView(e['press_tumbler_id'].toString());
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
          label: 'Satuan Berat',
          options: unitOption,
          selected: widget.form?['weight_unit_id'].toString() ?? '',
          handleChangeValue: (e) {
            setState(() {
              widget.form?['weight_unit_id'] = e['value'].toString();
              widget.form?['nama_satuan_berat'] = e['label'].toString();
            });
          },
        );
      },
    );
  }

  _selectLengthUnit() {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SelectDialog(
          label: 'Satuan Panjang',
          options: unitOption,
          selected: widget.form?['length_unit_id'].toString() ?? '',
          handleChangeValue: (e) {
            setState(() {
              widget.form?['length_unit_id'] = e['value'].toString();
              widget.form?['nama_satuan_panjang'] = e['label'].toString();
            });
          },
        );
      },
    );
  }

  _selectWidthUnit() {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SelectDialog(
          label: 'Satuan Lebar',
          options: unitOption,
          selected: widget.form?['width_unit_id'].toString() ?? '',
          handleChangeValue: (e) {
            setState(() {
              widget.form?['width_unit_id'] = e['value'].toString();
              widget.form?['nama_satuan_lebar'] = e['label'].toString();
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
    return FinishProcessManual(
      title: 'Selesai Press Tumbler',
      id: widget.id,
      data: widget.data,
      form: widget.form,
      handleSubmit: widget.handleSubmit,
      machineFilterValue: '2',
      fetchWorkOrder: (service) => service.fetchPressFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListOption,
      processService: _pressTumblerService,
      handleChangeInput: widget.handleChangeInput,
      idProcess: 'press_tumbler_id',
      withItemGrade: false,
    );
  }
}
