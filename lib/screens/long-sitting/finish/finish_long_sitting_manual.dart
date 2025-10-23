import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/models/process/long_sitting.dart';
import 'package:textile_tracking/components/master/form/finish/create_form.dart';

class FinishLongSittingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;

  const FinishLongSittingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput});

  @override
  State<FinishLongSittingManual> createState() =>
      _FinishLongSittingManualState();
}

class _FinishLongSittingManualState extends State<FinishLongSittingManual> {
  final WorkOrderService _workOrderService = WorkOrderService();
  final LongSittingService _longSittingService = LongSittingService();
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
  Map<String, dynamic> longSittingData = {};

  var lsId = '';

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
          .fetchSittingFinishOptions();
      // ignore: use_build_context_synchronously
      final result = Provider.of<OptionWorkOrderService>(context, listen: false)
          .dataListSittingFinish;

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

  Future<void> _getLongSittingView(id) async {
    await _longSittingService.getDataView(id);

    setState(() {
      longSittingData = _longSittingService.dataView;

      if (longSittingData['length'] != null) {
        _lengthController.text = longSittingData['length'].toString();
        widget.form?['length'] = longSittingData['length'];
      }
      if (longSittingData['width'] != null) {
        _widthController.text = longSittingData['width'].toString();
        widget.form?['width'] = longSittingData['width'];
      }
      if (longSittingData['weight'] != null) {
        _weightController.text = longSittingData['weight'].toString();
        widget.form?['weight'] = longSittingData['weight'];
      }
      if (longSittingData['notes'] != null) {
        _noteController.text = longSittingData['notes'].toString();
        widget.form?['notes'] = longSittingData['notes'];
      }
      if (longSittingData['machine'] != null) {
        widget.form?['machine_id'] =
            longSittingData['machine']['id'].toString();
        widget.form?['nama_mesin'] =
            longSittingData['machine']['name'].toString();
      }
      if (longSittingData['weight_unit'] != null) {
        widget.form?['weight_unit_id'] =
            longSittingData['weight_unit']['id'].toString();
        widget.form?['nama_satuan_berat'] =
            longSittingData['weight_unit']['name'].toString();
      }
      if (longSittingData['length_unit'] != null) {
        widget.form?['length_unit_id'] =
            longSittingData['length_unit']['id'].toString();
        widget.form?['nama_satuan_panjang'] =
            longSittingData['length_unit']['name'].toString();
      }
      if (longSittingData['width_unit'] != null) {
        widget.form?['width_unit_id'] =
            longSittingData['width_unit']['id'].toString();
        widget.form?['nama_satuan_lebar'] =
            longSittingData['width_unit']['name'].toString();
      }

      if (longSittingData['attachments'] != null) {
        widget.form?['attachments'] = List.from(longSittingData['attachments']);
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
              lsId = e['long_sitting_id'].toString();
            });

            _getDataView(e['value'].toString());
            _getLongSittingView(e['long_sitting_id'].toString());
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
        title: 'Selesai Long Sitting',
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
        processId: lsId,
        processData: longSittingData,
        isLoading: _firstLoading,
        handleSelectLengthUnit: _selectLengthUnit,
        handleSelectWidthUnit: _selectWidthUnit,
      ),
    );
  }
}
