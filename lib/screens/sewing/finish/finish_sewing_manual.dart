import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/components/stenter/finish/create_form.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/models/process/sewing.dart';

class FinishSewingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;

  const FinishSewingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput});

  @override
  State<FinishSewingManual> createState() => _FinishSewingManualState();
}

class _FinishSewingManualState extends State<FinishSewingManual> {
  final WorkOrderService _workOrderService = WorkOrderService();
  final SewingService _sewingService = SewingService();
  bool _firstLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();

  late List<dynamic> workOrderOption = [];
  late List<dynamic> unitOption = [];

  Map<String, dynamic> woData = {};
  Map<String, dynamic> sewingData = {};

  var sewingId = '';

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
    await Provider.of<OptionWorkOrderService>(context, listen: false)
        .fetchSewingFinishOptions();
    // ignore: use_build_context_synchronously
    final result = Provider.of<OptionWorkOrderService>(context, listen: false)
        .dataListSewingFinish;

    setState(() {
      workOrderOption = result;
    });
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

  Future<void> _getSewingView(id) async {
    await _sewingService.getDataView(id);

    setState(() {
      sewingData = _sewingService.dataView;

      if (sewingData['length'] != null) {
        _lengthController.text = sewingData['length'].toString();
        widget.form?['length'] = sewingData['length'];
      }
      if (sewingData['width'] != null) {
        _widthController.text = sewingData['width'].toString();
        widget.form?['width'] = sewingData['width'];
      }
      if (sewingData['weight'] != null) {
        _weightController.text = sewingData['weight'].toString();
        widget.form?['weight'] = sewingData['weight'];
      }
      if (sewingData['notes'] != null) {
        _noteController.text = sewingData['notes'].toString();
        widget.form?['notes'] = sewingData['notes'];
      }
      if (sewingData['machine'] != null) {
        widget.form?['machine_id'] = sewingData['machine']['id'].toString();
        widget.form?['nama_mesin'] = sewingData['machine']['name'].toString();
      }
      if (sewingData['weight_unit'] != null) {
        widget.form?['weight_unit_id'] =
            sewingData['weight_unit']['id'].toString();
        widget.form?['nama_satuan_berat'] =
            sewingData['weight_unit']['name'].toString();
      }
      if (sewingData['length_unit'] != null) {
        widget.form?['length_unit_id'] =
            sewingData['length_unit']['id'].toString();
        widget.form?['nama_satuan_panjang'] =
            sewingData['length_unit']['name'].toString();
      }
      if (sewingData['width_unit'] != null) {
        widget.form?['width_unit_id'] =
            sewingData['width_unit']['id'].toString();
        widget.form?['nama_satuan_lebar'] =
            sewingData['width_unit']['name'].toString();
      }

      if (sewingData['attachments'] != null) {
        widget.form?['attachments'] = List.from(sewingData['attachments']);
      }
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
              sewingId = e['sewing_id'].toString();
            });

            _getDataView(e['value'].toString());
            _getSewingView(e['sewing_id'].toString());
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
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar: CustomAppBar(
        title: 'Selesai Sewing',
        onReturn: () {
          Navigator.pop(context);
        },
      ),
      body: CreateForm(
        formKey: _formKey,
        form: widget.form,
        note: _noteController,
        weight: _weightController,
        width: _widthController,
        length: _lengthController,
        handleSelectWo: _selectWorkOrder,
        handleSelectUnit: _selectUnit,
        handleChangeInput: widget.handleChangeInput,
        handleSubmit: widget.handleSubmit,
        id: widget.id,
        data: woData,
        stenterId: sewingId,
        stenterData: sewingData,
        isLoading: _firstLoading,
        handleSelectLengthUnit: _selectLengthUnit,
        handleSelectWidthUnit: _selectWidthUnit,
      ),
    );
  }
}
