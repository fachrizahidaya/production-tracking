// ignore_for_file: use_build_context_synchronously, unused_field, prefer_final_fields, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/button/process_button.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/process/finish/work_order_info_tab.dart';
import 'package:textile_tracking/components/process/finish/finish_form_tab.dart';
import 'package:textile_tracking/components/process/finish/work_order_item_tab.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_item_grade.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';

class FinishProcessManual extends StatefulWidget {
  final title;
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final void Function(String fieldName, dynamic value)? handleChangeInput;
  final handleSubmit;
  final fetchWorkOrder;
  final getWorkOrderOptions;
  final label;
  final forDyeing;
  final processService;
  final idProcess;
  final withItemGrade;
  final withQtyAndWeight;
  final itemGradeOption;
  final fetchItemGrade;
  final getItemGradeOptions;
  final processId;

  const FinishProcessManual(
      {super.key,
      this.title,
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
      this.withQtyAndWeight,
      this.processId,
      this.forDyeing});

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
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _listFormKey = GlobalKey();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _qtyItemController = TextEditingController();
  final List<TextEditingController> _qtyControllers = [];
  final List<TextEditingController> _notesControllers = [];
  List<Map<String, dynamic>> _selectedUnits = [];

  late List<dynamic> workOrderOption = [];
  late List<dynamic> itemGradeOption = [];
  late List<dynamic> unitOption = [];

  Map<String, dynamic> woData = {};
  Map<String, dynamic> data = {};

  var processId = '';

  @override
  void initState() {
    _qtyController.text = widget.form?['qty']?.toString() ?? '';
    _qtyItemController.text = widget.form?['item_qty']?.toString() ?? '';
    _weightController.text = widget.form?['weight']?.toString() ?? '';
    _lengthController.text = widget.form?['length']?.toString() ?? '';
    _widthController.text = widget.form?['width']?.toString() ?? '';
    _noteController.text = widget.form?['notes']?.toString() ?? '';

    if (widget.processId != null) {
      _getProcessView(widget.processId);
    }

    _handleFetchWorkOrder();
    _handleFetchItemGrade();
    _handleFetchUnit();

    super.initState();
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
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
          Provider.of<OptionUnitService>(context, listen: false).dataListOption;

      setState(() {
        unitOption = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
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
      if (data['qty'] != null) {
        _qtyController.text = data['qty'].toString();
        widget.form?['qty'] = data['qty'];
      }
      if (data['notes'] != null) {
        _noteController.text = data['notes'].toString();
        widget.form?['notes'] = data['notes'];
      }
      if (data['machine'] != null) {
        widget.form?['machine_id'] = data['machine']['id'].toString();
        widget.form?['nama_mesin'] = data['machine']['name'].toString();
      }
      if (data['unit'] != null) {
        widget.form?['unit_id'] = data['unit']['id'].toString();
        widget.form?['nama_satuan'] = data['unit']['name'].toString();
      }
      if (data['item_unit'] != null) {
        widget.form?['item_unit_id'] = data['item_unit']['id'].toString();
        widget.form?['nama_satuan'] = data['item_unit']['name'].toString();
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

  Future<void> _handleCancel(BuildContext context) async {
    if (context.mounted) {
      if (widget.form?['wo_id'] != null) {
        showConfirmationDialog(
            context: context,
            isLoading: _isLoading,
            onConfirm: () async {
              await Future.delayed(const Duration(milliseconds: 200));
              Navigator.pop(context);
              Navigator.pop(context);
            },
            title: 'Batal',
            message: 'Anda yakin ingin kembali? Semua perubahan tidak disimpan',
            buttonBackground: CustomTheme().buttonColor('danger'));
      } else {
        Navigator.pop(context);
      }
    }
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

  _selectQtyUnit(int index) async {
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

    // Fetch current selected unit label (if any)
    final currentUnitName =
        widget.form?['grades']?[index]?['unit']?['name']?.toString() ?? '';

    await showDialog(
      context: context,
      builder: (_) => SelectDialog(
        label: 'Satuan',
        options: unitOption,
        selected: currentUnitName,
        handleChangeValue: (selected) {
          setState(() {
            // Ensure grades list exists
            widget.form?['grades'] ??= [];

            // Ensure index exists (avoid out-of-range)
            while (widget.form!['grades'].length <= index) {
              widget.form!['grades'].add({
                'item_grade_id': '',
                'unit_id': '',
                'unit': {},
                'qty': '',
                'notes': '',
              });
            }

            // Update the selected grade row
            widget.form!['grades'][index]['unit_id'] =
                selected['value'].toString();

            // Store the label for display
            widget.form!['grades'][index]
                ['unit'] = {'name': selected['label'].toString()};
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
        selected: widget.form?['item_unit_id'].toString() ?? '',
        handleChangeValue: (e) {
          setState(() {
            widget.form?['item_unit_id'] = e['value'].toString();
            widget.form?['nama_satuan'] = e['label'].toString();
          });
        },
      ),
    );
  }

  _selectQtyDyeingUnit() {
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
        selected: widget.form?['unit_id'].toString() ?? '',
        handleChangeValue: (e) {
          setState(() {
            widget.form?['unit_id'] = e['value'].toString();
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
    return DefaultTabController(
      length: 3,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFf9fafc),
          appBar: CustomAppBar(
            title: widget.title,
            onReturn: () {
              _handleCancel(context);
            },
          ),
          body: Column(
            children: [
              Container(
                color: Colors.white,
                child: TabBar(tabs: [
                  Tab(
                    text: 'Form',
                  ),
                  Tab(
                    text: 'Informasi',
                  ),
                  Tab(
                    text: 'Material',
                  ),
                ]),
              ),
              Expanded(
                child: TabBarView(children: [
                  FinishFormTab(
                    id: widget.id,
                    isLoading: _firstLoading,
                    form: widget.form,
                    formKey: _formKey,
                    handleSelectMachine: null,
                    handleSelectWorkOrder: _selectWorkOrder,
                    handleSelectLengthUnit: _selectLengthUnit,
                    handleChangeInput: widget.handleChangeInput,
                    handleSelectUnit: _selectUnit,
                    handleSelectWidthUnit: _selectWidthUnit,
                    qty: _qtyItemController,
                    length: _lengthController,
                    width: _widthController,
                    note: _noteController,
                    qtyItem: _qtyControllers,
                    weight: _weightController,
                    handleSelectWo: _selectWorkOrder,
                    handleSelectQtyUnitItem: _selectQtyItemUnit,
                    handleSelectQtyUnitDyeing: _selectQtyDyeingUnit,
                    processId: processId,
                    processData: data,
                    withItemGrade: widget.withItemGrade,
                    itemGradeOption: itemGradeOption,
                    handleSelectQtyUnit: _selectQtyUnit,
                    withQtyAndWeight: widget.withQtyAndWeight,
                    label: widget.label,
                    forDyeing: widget.forDyeing,
                  ),
                  WorkOrderInfoTab(
                    data: data['work_orders'],
                    label: widget.label,
                  ),
                  WorkOrderItemTab(
                    data: woData,
                  ),
                ]),
              )
            ],
          ),
          bottomNavigationBar: ProcessButton(
            data: data,
            form: widget.form,
            isSubmitting: _isSubmitting,
            labelProcess: 'Selesai',
            processId: processId,
            formKey: _formKey,
            handleSubmit: widget.handleSubmit,
            handleCancel: _handleCancel,
          ),
        ),
      ),
    );
  }
}
