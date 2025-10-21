import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/form/create_form.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/models/process/sorting.dart';

class FinishSortingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;

  const FinishSortingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput});

  @override
  State<FinishSortingManual> createState() => _FinishSortingManualState();
}

class _FinishSortingManualState extends State<FinishSortingManual> {
  final WorkOrderService _workOrderService = WorkOrderService();
  final SortingService _sortingService = SortingService();
  bool _firstLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();

  late List<dynamic> workOrderOption = [];
  late List<dynamic> unitOption = [];

  Map<String, dynamic> woData = {};
  Map<String, dynamic> sortingData = {};

  var sortingId = '';

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
        .fetchSortingFinishOptions();
    // ignore: use_build_context_synchronously
    final result = Provider.of<OptionWorkOrderService>(context, listen: false)
        .dataListSortingFinish;

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

  Future<void> _getSortingView(id) async {
    await _sortingService.getDataView(id);

    setState(() {
      sortingData = _sortingService.dataView;

      if (sortingData['length'] != null) {
        _lengthController.text = sortingData['length'].toString();
        widget.form?['length'] = sortingData['length'];
      }
      if (sortingData['width'] != null) {
        _widthController.text = sortingData['width'].toString();
        widget.form?['width'] = sortingData['width'];
      }
      if (sortingData['weight'] != null) {
        _weightController.text = sortingData['weight'].toString();
        widget.form?['weight'] = sortingData['weight'];
      }
      if (sortingData['notes'] != null) {
        _noteController.text = sortingData['notes'].toString();
        widget.form?['notes'] = sortingData['notes'];
      }
      if (sortingData['machine'] != null) {
        widget.form?['machine_id'] = sortingData['machine']['id'].toString();
        widget.form?['nama_mesin'] = sortingData['machine']['name'].toString();
      }
      if (sortingData['weight_unit'] != null) {
        widget.form?['weight_unit_id'] =
            sortingData['weight_unit']['id'].toString();
        widget.form?['nama_satuan_berat'] =
            sortingData['weight_unit']['name'].toString();
      }
      if (sortingData['length_unit'] != null) {
        widget.form?['length_unit_id'] =
            sortingData['length_unit']['id'].toString();
        widget.form?['nama_satuan_panjang'] =
            sortingData['length_unit']['name'].toString();
      }
      if (sortingData['width_unit'] != null) {
        widget.form?['width_unit_id'] =
            sortingData['width_unit']['id'].toString();
        widget.form?['nama_satuan_lebar'] =
            sortingData['width_unit']['name'].toString();
      }

      if (sortingData['attachments'] != null) {
        widget.form?['attachments'] = List.from(sortingData['attachments']);
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
              sortingId = e['sorting_id'].toString();
            });

            _getDataView(e['value'].toString());
            _getSortingView(e['sorting_id'].toString());
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
        title: 'Selesai Sorting',
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
        processId: sortingId,
        processData: sortingData,
        isLoading: _firstLoading,
        handleSelectLengthUnit: _selectLengthUnit,
        handleSelectWidthUnit: _selectWidthUnit,
      ),
    );
  }
}
