import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/dyeing/finish/create_form.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/models/process/dyeing.dart';

class FinishProcessManual extends StatefulWidget {
  final String title;
  final String? machineFilterValue;
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final Future<void> Function()? handleSubmit;
  final Future<void> Function(dynamic service)? fetchWorkOrder;
  final List<dynamic> Function(dynamic service)? getWorkOrderOptions;
  final void Function(String fieldName, dynamic value)? handleChangeInput;

  const FinishProcessManual({
    super.key,
    required this.title,
    this.machineFilterValue,
    this.id,
    this.data,
    this.form,
    this.handleSubmit,
    this.fetchWorkOrder,
    this.getWorkOrderOptions,
    this.handleChangeInput,
  });

  @override
  State<FinishProcessManual> createState() => _FinishProcessManualState();
}

class _FinishProcessManualState extends State<FinishProcessManual> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final WorkOrderService _workOrderService = WorkOrderService();
  final DyeingService _dyeingService = DyeingService();

  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();

  bool _firstLoading = false;
  List<dynamic> workOrderOption = [];
  List<dynamic> unitOption = [];
  Map<String, dynamic> woData = {};
  Map<String, dynamic> dyeingData = {};

  String dyeingId = '';

  @override
  void initState() {
    super.initState();

    _qtyController.text = widget.form?['qty']?.toString() ?? '';
    _lengthController.text = widget.form?['length']?.toString() ?? '';
    _widthController.text = widget.form?['width']?.toString() ?? '';
    _noteController.text = widget.form?['notes']?.toString() ?? '';

    _fetchWorkOrder();
    _handleFetchUnit();

    if (widget.data != null) {
      woData = widget.data!;
    }
  }

  Future<void> _fetchWorkOrder() async {
    final service = Provider.of<OptionWorkOrderService>(context, listen: false);
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

  Future<void> _getDataView(String id) async {
    setState(() => _firstLoading = true);
    await _workOrderService.getDataView(id);
    setState(() {
      woData = _workOrderService.dataView;
      _firstLoading = false;
    });
  }

  Future<void> _getDyeingView(String id) async {
    await _dyeingService.getDataView(id);
    final dyeing = _dyeingService.dataView;

    setState(() {
      dyeingData = dyeing;

      void updateField(String key, dynamic value) {
        if (value != null) {
          widget.form?[key] = value;
        }
      }

      updateField('length', dyeing['length']);
      updateField('width', dyeing['width']);
      updateField('qty', dyeing['qty']);
      updateField('notes', dyeing['notes']);

      if (dyeing['machine'] != null) {
        widget.form?['machine_id'] = dyeing['machine']['id'].toString();
        widget.form?['nama_mesin'] = dyeing['machine']['name'].toString();
      }
      if (dyeing['unit'] != null) {
        widget.form?['unit_id'] = dyeing['unit']['id'].toString();
        widget.form?['nama_satuan'] = dyeing['unit']['name'].toString();
      }
      if (dyeing['attachments'] != null) {
        widget.form?['attachments'] = List.from(dyeing['attachments']);
      }

      // Update controllers
      _lengthController.text = dyeing['length']?.toString() ?? '';
      _widthController.text = dyeing['width']?.toString() ?? '';
      _qtyController.text = dyeing['qty']?.toString() ?? '';
      _noteController.text = dyeing['notes']?.toString() ?? '';
    });
  }

  void _selectWorkOrder() {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SelectDialog(
          label: 'Work Order',
          options: workOrderOption,
          selected: widget.form?['wo_id']?.toString() ?? '',
          handleChangeValue: (selected) async {
            final selectedId = selected['value'].toString();
            final selectedDyeingId = selected['dyeing_id']?.toString();

            setState(() {
              widget.form?['wo_id'] = selectedId;
              widget.form?['no_wo'] = selected['label'].toString();
            });

            await _getDataView(selectedId);
            if (selectedDyeingId != null) {
              await _getDyeingView(selectedDyeingId);
            }
          },
        );
      },
    );
  }

  void _selectUnit() {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SelectDialog(
          label: 'Satuan',
          options: unitOption,
          selected: widget.form?['unit_id']?.toString() ?? '',
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
    _noteController.dispose();
    _qtyController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
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
        handleSubmit: widget.handleSubmit,
        data: woData,
        id: widget.id,
        isLoading: _firstLoading,
        handleChangeInput: widget.handleChangeInput,
        handleSelectWo: _selectWorkOrder,
        note: _noteController,
        qty: _qtyController,
        width: _widthController,
        length: _lengthController,
        handleSelectUnit: _selectUnit,
        dyeingData: dyeingData,
        dyeingId: dyeingId,
      ),
    );
  }
}
