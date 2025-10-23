import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/form/finish/create_form.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/models/process/embroidery.dart';

class FinishEmbroideryManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;

  const FinishEmbroideryManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput});

  @override
  State<FinishEmbroideryManual> createState() => _FinishEmbroideryManualState();
}

class _FinishEmbroideryManualState extends State<FinishEmbroideryManual> {
  final WorkOrderService _workOrderService = WorkOrderService();
  final EmbroideryService _embroideryService = EmbroideryService();
  bool _firstLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();

  late List<dynamic> workOrderOption = [];
  late List<dynamic> unitOption = [];

  Map<String, dynamic> woData = {};
  Map<String, dynamic> embroideryData = {};

  var embroideryId = '';

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
        .fetchEmbroideryFinishOptions();
    // ignore: use_build_context_synchronously
    final result = Provider.of<OptionWorkOrderService>(context, listen: false)
        .dataListEmbroideryFinish;

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

  Future<void> _getEmbroideryView(id) async {
    await _embroideryService.getDataView(id);

    setState(() {
      embroideryData = _embroideryService.dataView;

      if (embroideryData['length'] != null) {
        _lengthController.text = embroideryData['length'].toString();
        widget.form?['length'] = embroideryData['length'];
      }
      if (embroideryData['width'] != null) {
        _widthController.text = embroideryData['width'].toString();
        widget.form?['width'] = embroideryData['width'];
      }
      if (embroideryData['weight'] != null) {
        _weightController.text = embroideryData['weight'].toString();
        widget.form?['weight'] = embroideryData['weight'];
      }
      if (embroideryData['notes'] != null) {
        _noteController.text = embroideryData['notes'].toString();
        widget.form?['notes'] = embroideryData['notes'];
      }
      if (embroideryData['machine'] != null) {
        widget.form?['machine_id'] = embroideryData['machine']['id'].toString();
        widget.form?['nama_mesin'] =
            embroideryData['machine']['name'].toString();
      }
      if (embroideryData['weight_unit'] != null) {
        widget.form?['weight_unit_id'] =
            embroideryData['weight_unit']['id'].toString();
        widget.form?['nama_satuan_berat'] =
            embroideryData['weight_unit']['name'].toString();
      }
      if (embroideryData['length_unit'] != null) {
        widget.form?['length_unit_id'] =
            embroideryData['length_unit']['id'].toString();
        widget.form?['nama_satuan_panjang'] =
            embroideryData['length_unit']['name'].toString();
      }
      if (embroideryData['width_unit'] != null) {
        widget.form?['width_unit_id'] =
            embroideryData['width_unit']['id'].toString();
        widget.form?['nama_satuan_lebar'] =
            embroideryData['width_unit']['name'].toString();
      }

      if (embroideryData['attachments'] != null) {
        widget.form?['attachments'] = List.from(embroideryData['attachments']);
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
              embroideryId = e['emb_id'].toString();
            });

            _getDataView(e['value'].toString());
            _getEmbroideryView(e['emb_id'].toString());
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
        title: 'Selesai Embroidery',
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
        processId: embroideryId,
        processData: embroideryData,
        isLoading: _firstLoading,
        handleSelectLengthUnit: _selectLengthUnit,
        handleSelectWidthUnit: _selectWidthUnit,
      ),
    );
  }
}
