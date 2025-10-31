import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/dyeing/rework/create_form.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
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
  bool _firstLoading = false;
  bool _isFetchingMachine = false;
  bool _isFetchingWorkOrder = false;
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

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
    setState(() {
      _isFetchingWorkOrder = true;
    });

    try {
      await Provider.of<OptionWorkOrderService>(context, listen: false)
          .fetchReworkOptions();
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
        _isFetchingMachine = false;
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

  Future<void> _handleFetchMachine() async {
    setState(() {
      _isFetchingMachine = true;
    });

    try {
      await Provider.of<OptionMachineService>(context, listen: false)
          .fetchOptionsDyeing();
      // ignore: use_build_context_synchronously
      final result = Provider.of<OptionMachineService>(context, listen: false)
          .dataListOption;

      setState(() {
        machineOption = result;
      });
    } catch (e) {
      debugPrint("Error fetching machines: $e");
    } finally {
      setState(() {
        _isFetchingWorkOrder = false;
      });
    }
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

  _selectMachine() {
    if (_isFetchingMachine) {
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
          label: 'Mesin',
          options: machineOption.toList(),
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
        isLoading: _firstLoading,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: PaddingColumn.screen,
          child: ValueListenableBuilder<bool>(
            valueListenable: _isSubmitting,
            builder: (context, isSubmitting, _) {
              return Row(
                children: [
                  Expanded(
                    child: CancelButton(
                      label: 'Batal',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Expanded(
                      child: FormButton(
                    label: 'Simpan',
                    isLoading: isSubmitting,
                    onPressed: () async {
                      _isSubmitting.value = true;
                      try {
                        await widget.handleSubmit(dyeingData['id'].toString());
                        setState(() {
                          // _initialQty = _qtyController.text;
                          // _initialLength = _lengthController.text;
                          // _initialWidth = _widthController.text;
                          // _initialNotes = _noteController.text;
                          // _isChanged = false;
                        });
                      } finally {
                        _isSubmitting.value = false;
                      }
                    },
                  ))
                ].separatedBy(SizedBox(
                  width: 16,
                )),
              );
            },
          ),
        ),
      ),
    );
  }
}
