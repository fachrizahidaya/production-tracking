import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/finish/create_form.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/models/process/dyeing.dart';

class FinishDyeingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;

  const FinishDyeingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput});

  @override
  State<FinishDyeingManual> createState() => _FinishDyeingManualState();
}

class _FinishDyeingManualState extends State<FinishDyeingManual> {
  final WorkOrderService _workOrderService = WorkOrderService();
  final DyeingService _dyeingService = DyeingService();
  bool _firstLoading = false;
  bool _isFetchingWorkOrder = false;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();

  late List<dynamic> workOrderOption = [];
  late List<dynamic> unitOption = [];

  Map<String, dynamic> woData = {};
  Map<String, dynamic> dyeingData = {};

  var dyeingId = '';

  @override
  void initState() {
    _qtyController.text = widget.form?['qty']?.toString() ?? '';
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
          .fetchFinishOptions();
      // ignore: use_build_context_synchronously
      final result = Provider.of<OptionWorkOrderService>(context, listen: false)
          .dataListFinish;

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

  Future<void> _getDyeingView(id) async {
    await _dyeingService.getDataView(id);

    setState(() {
      dyeingData = _dyeingService.dataView;

      if (dyeingData['length'] != null) {
        _lengthController.text = dyeingData['length'].toString();
        widget.form?['length'] = dyeingData['length'];
      }
      if (dyeingData['width'] != null) {
        _widthController.text = dyeingData['width'].toString();
        widget.form?['width'] = dyeingData['width'];
      }
      if (dyeingData['qty'] != null) {
        _qtyController.text = dyeingData['qty'].toString();
        widget.form?['qty'] = dyeingData['qty'];
      }
      if (dyeingData['notes'] != null) {
        _noteController.text = dyeingData['notes'].toString();
        widget.form?['notes'] = dyeingData['notes'];
      }
      if (dyeingData['machine'] != null) {
        widget.form?['machine_id'] = dyeingData['machine']['id'].toString();
        widget.form?['nama_mesin'] = dyeingData['machine']['name'].toString();
      }
      if (dyeingData['unit'] != null) {
        widget.form?['unit_id'] = dyeingData['unit']['id'].toString();
        widget.form?['nama_satuan'] = dyeingData['unit']['name'].toString();
      }
      if (dyeingData['attachments'] != null) {
        widget.form?['attachments'] = List.from(dyeingData['attachments']);
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
        title: 'Finish Dyeing',
        onReturn: () {
          Navigator.pop(context);
        },
      ),
      body: CreateForm(
        formKey: _formKey,
        form: widget.form,
        note: _noteController,
        qty: _qtyController,
        width: _widthController,
        length: _lengthController,
        handleSelectWo: _selectWorkOrder,
        handleSelectUnit: _selectUnit,
        handleChangeInput: widget.handleChangeInput,
        handleSubmit: widget.handleSubmit,
        id: widget.id,
        data: woData,
        dyeingId: dyeingId,
        dyeingData: dyeingData,
        isLoading: _firstLoading,
      ),
    );
  }
}
