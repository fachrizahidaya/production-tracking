import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/form/finish/create_form.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_item_grade.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';

class FinishProcessManual extends StatefulWidget {
  final title;
  final String? machineFilterValue;
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final getWorkOrderOptions;
  final void Function(String fieldName, dynamic value)? handleChangeInput;
  final label;
  final processService;
  final idProcess;
  final withItemGrade;
  final withQtyAndWeight;
  final itemGradeOption;
  final fetchItemGrade;
  final getItemGradeOptions;

  const FinishProcessManual(
      {super.key,
      this.title,
      this.machineFilterValue,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.getWorkOrderOptions,
      this.handleChangeInput,
      this.label,
      this.processService,
      this.idProcess,
      this.withItemGrade,
      this.itemGradeOption,
      this.fetchItemGrade,
      this.getItemGradeOptions,
      this.withQtyAndWeight});

  @override
  State<FinishProcessManual> createState() => _FinishProcessManualState();
}

class _FinishProcessManualState extends State<FinishProcessManual> {
  final WorkOrderService _workOrderService = WorkOrderService();
  bool _firstLoading = false;
  bool _isFetchingWorkOrder = false;
  bool _isFetchingUnit = false;
  bool _isFetchingGrade = false;
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _qtyItemController = TextEditingController();
  List<TextEditingController> _qtyControllers = [];
  List<TextEditingController> _notesControllers = [];
  List<Map<String, dynamic>> _selectedUnits = [];

  late List<dynamic> workOrderOption = [];
  late List<dynamic> itemGradeOption = [];
  late List<dynamic> unitOption = [];

  Map<String, dynamic> woData = {};
  Map<String, dynamic> data = {};

  var processId = '';

  @override
  void initState() {
    _qtyItemController.text = widget.form?['item_qty']?.toString() ?? '';
    _weightController.text = widget.form?['weight']?.toString() ?? '';
    _lengthController.text = widget.form?['length']?.toString() ?? '';
    _widthController.text = widget.form?['width']?.toString() ?? '';
    _noteController.text = widget.form?['notes']?.toString() ?? '';

    if (widget.data != null) {
      woData = widget.data!;
    }

    _handleFetchWorkOrder();
    _handleFetchItemGrade();
    _handleFetchUnit();
    // _initControllers();

    super.initState();
  }

  void _initControllers() {
    final length = widget.itemGradeOption.length;

    _qtyControllers = List.generate(length, (index) => TextEditingController());
    _notesControllers =
        List.generate(length, (index) => TextEditingController());
    _selectedUnits = List.generate(
        length,
        (index) => {
              'value': null,
              'label': '',
            });
  }

  Future<void> _handleFetchWorkOrder() async {
    setState(() {
      _isFetchingWorkOrder = true;
    });

    final service = Provider.of<OptionWorkOrderService>(context, listen: false);

    try {
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
      // await Provider.of<OptionWorkOrderService>(context, listen: false)
      //     .fetchPressFinishOptions();
      // // ignore: use_build_context_synchronously
      // final result = Provider.of<OptionWorkOrderService>(context, listen: false)
      //     .dataListPressFinish;

      // setState(() {
      //   workOrderOption = result;
      // });
    } catch (e) {
      debugPrint("Error fetching work orders: $e");
    } finally {
      setState(() {
        _isFetchingWorkOrder = false;
      });
    }
  }

  Future<void> _handleFetchItemGrade() async {
    setState(() {
      _isFetchingGrade = true;
    });

    final service = Provider.of<OptionItemGradeService>(context, listen: false);

    try {
      if (widget.fetchItemGrade != null) {
        await widget.fetchItemGrade!(service);
      } else {
        await service.fetchOptions();
      }

      final data = widget.getItemGradeOptions != null
          ? widget.getItemGradeOptions!(service)
          : service.dataListOption;

      setState(() {
        itemGradeOption = data;
      });
    } catch (e) {
      debugPrint("Error fetching item grade: $e");
    } finally {
      setState(() {
        _isFetchingGrade = false;
      });
    }
  }

  Future<void> _handleFetchUnit() async {
    setState(() {
      _isFetchingUnit = true;
    });

    try {
      await Provider.of<OptionUnitService>(context, listen: false)
          .getDataListOption();
      final result =
          // ignore: use_build_context_synchronously
          Provider.of<OptionUnitService>(context, listen: false).dataListOption;

      setState(() {
        unitOption = result;
      });
    } catch (e) {
      debugPrint("Error fetching work units: $e");
    } finally {
      setState(() {
        _isFetchingUnit = false;
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

  Future<void> _getProcessView(id) async {
    await widget.processService.getDataView(id);

    setState(() {
      data = widget.processService.dataView;
      // final grades = data['grades'] ?? [];
      // _qtyControllers = List.generate(grades.length, (i) {
      //   return TextEditingController(
      //     text: grades[i]['qty']?.toString() ?? '',
      //   );
      // });
      // _notesControllers = List.generate(grades.length, (i) {
      //   return TextEditingController(
      //     text: grades[i]['notes']?.toString() ?? '',
      //   );
      // });

      if (data['length'] != null) {
        _lengthController.text = data['length'].toString();
        widget.form?['length'] = data['length'];
      }
      if (data['width'] != null) {
        _widthController.text = data['width'].toString();
        widget.form?['width'] = data['width'];
      }
      if (data['weight'] != null) {
        _weightController.text = data['weight'].toString();
        widget.form?['weight'] = data['weight'];
      }
      if (data['item_qty'] != null) {
        _qtyItemController.text = data['item_qty'].toString();
        widget.form?['item_qty'] = data['item_qty'];
      }
      if (data['notes'] != null) {
        _noteController.text = data['notes'].toString();
        widget.form?['notes'] = data['notes'];
      }
      if (data['machine'] != null) {
        widget.form?['machine_id'] = data['machine']['id'].toString();
        widget.form?['nama_mesin'] = data['machine']['name'].toString();
      }
      if (data['item_unit'] != null) {
        widget.form?['item_unit_id'] = data['item_unit']['id'].toString();
        widget.form?['nama_satuan_'] = data['item_unit']['name'].toString();
      }
      if (data['weight_unit'] != null) {
        widget.form?['weight_unit_id'] = data['weight_unit']['id'].toString();
        widget.form?['nama_satuan_berat'] =
            data['weight_unit']['name'].toString();
      }
      if (data['length_unit'] != null) {
        widget.form?['length_unit_id'] = data['length_unit']['id'].toString();
        widget.form?['nama_satuan_panjang'] =
            data['length_unit']['name'].toString();
      }
      if (data['width_unit'] != null) {
        widget.form?['width_unit_id'] = data['width_unit']['id'].toString();
        widget.form?['nama_satuan_lebar'] =
            data['width_unit']['name'].toString();
      }

      if (data['attachments'] != null) {
        widget.form?['attachments'] = List.from(data['attachments']);
      }
      if (data['grades'] != null) {
        widget.form?['grades'] = List.from(data['grades']);
      }
      if (data['maklon'] != null) {
        widget.form?['maklon'] = data['maklon'];
        widget.form?['maklon'] = data['maklon'];
      }
      if (data['maklon_name'] != null) {
        widget.form?['maklon_name'] = data['maklon_name'].toString();
        widget.form?['maklon_name'] = data['maklon_name'].toString();
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
              processId = e[widget.idProcess].toString();
            });

            _getDataView(e['value'].toString());
            _getProcessView(e[widget.idProcess].toString());
          },
        );
      },
    );
  }

  _selectUnit() {
    if (_isFetchingUnit) {
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
    if (_isFetchingUnit) {
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
    if (_isFetchingUnit) {
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

  _selectQtyUnit(int index) {
    if (_isFetchingUnit) {
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
      builder: (_) => SelectDialog(
        label: 'Satuan',
        options: unitOption,
        // 👇 Preselect current unit for this grade
        selected: '',
        handleChangeValue: (e) {
          setState(() {
            widget.form?['grades'][index]['unit_id'] = e['value'].toString();
            widget.form?['grades'][index]['unit']['name'] =
                e['label'].toString();
          });
        },
      ),
    );
  }

  _selectQtyItemUnit() {
    if (_isFetchingUnit) {
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
      builder: (_) => SelectDialog(
        label: 'Satuan',
        options: unitOption,
        // 👇 Preselect current unit for this grade
        selected: widget.form?['item_unit_id'].toString(),
        handleChangeValue: (e) {
          setState(() {
            widget.form?['item_unit_id'] = e['value'].toString();
            widget.form?['nama_satuan'] = e['label'].toString();
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    if (widget.form != null) {
      widget.form!.clear();
    }
    for (var controller in _qtyControllers) {
      controller.dispose();
    }
    for (var controller in _notesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar: CustomAppBar(
        title: widget.title,
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
        handleSelectQtyUnitItem: _selectQtyItemUnit,
        handleSubmit: widget.handleSubmit,
        id: widget.id,
        data: woData,
        processId: processId,
        processData: data,
        isLoading: _firstLoading,
        handleSelectLengthUnit: _selectLengthUnit,
        handleSelectWidthUnit: _selectWidthUnit,
        withItemGrade: widget.withItemGrade,
        itemGradeOption: itemGradeOption,
        handleSelectQtyUnit: _selectQtyUnit,
        notes: _notesControllers,
        qty: _qtyItemController,
        withQtyAndWeight: widget.withQtyAndWeight,
        qtyItem: _qtyControllers,
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
                        await widget.handleSubmit(data['id'].toString());
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
