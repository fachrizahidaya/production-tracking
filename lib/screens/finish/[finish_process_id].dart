// ignore_for_file: use_build_context_synchronously, unused_field, prefer_final_fields, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/button/process_button.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/process/finish/work_order_info_tab.dart';
import 'package:textile_tracking/components/process/finish/finish_form_tab.dart';
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
  final forPacking;

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
      this.forDyeing,
      this.forPacking});

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
  final TextEditingController _weightDozenController = TextEditingController();
  final TextEditingController _gsmController = TextEditingController();
  final TextEditingController _totalWeightController = TextEditingController();
  final TextEditingController _qtyItemController = TextEditingController();
  final List<TextEditingController> _qtyControllers = [];
  final List<TextEditingController> _notesControllers = [];
  List<Map<String, dynamic>> _selectedUnits = [];

  late List<dynamic> workOrderOption = [];
  late List<dynamic> itemGradeOption = [];
  late List<dynamic> unitOption = [];

  Map<String, dynamic> woData = {};
  Map<String, dynamic> data = {};

  String? _weightWarningValidationMessage;
  String? _itemWarningValidationMessage;

  var processId = '';

  @override
  void initState() {
    super.initState();

    _qtyController.text = widget.form?['qty']?.toString() ?? '';
    _qtyItemController.text = widget.form?['item_qty']?.toString() ?? '';
    _weightController.text = widget.form?['weight']?.toString() ?? '';
    _lengthController.text = widget.form?['length']?.toString() ?? '';
    _widthController.text = widget.form?['width']?.toString() ?? '';
    _noteController.text = widget.form?['notes']?.toString() ?? '';
    _weightDozenController.text =
        widget.form?['weight_per_dozen']?.toString() ?? '';
    _gsmController.text = widget.form?['gsm']?.toString() ?? '';
    _totalWeightController.text =
        widget.form?['total_weight']?.toString() ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postInit();
    });
  }

  Future<void> _postInit() async {
    setState(() {
      _firstLoading = true;
    });

    if (widget.processId != null) {
      await _getProcessView(widget.processId);
    }

    await _handleFetchWorkOrder();
    await _handleFetchItemGrade();
    await _handleFetchUnit();

    setState(() {
      _firstLoading = false;
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
    await widget.processService.getDataView(context, id);

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
      if (data['weight_per_dozen'] != null) {
        _weightDozenController.text = data['weight_per_dozen'].toString();
        widget.form?['weight_per_dozen'] = data['weight_per_dozen'];
      }
      if (data['gsm'] != null) {
        _gsmController.text = data['gsm'].toString();
        widget.form?['gsm'] = data['gsm'];
      }
      if (data['total_weight'] != null) {
        _totalWeightController.text = data['total_weight'].toString();
        widget.form?['total_weight'] = data['total_weight'];
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
    Widget buildBoldMessage(String woNo) {
      return RichText(
        text: TextSpan(
          style: TextStyle(
              fontSize: CustomTheme().fontSize('lg'),
              color: Colors.black,
              height: 1.5),
          children: [
            TextSpan(
              text: 'Anda yakin ingin kembali? ',
              style: TextStyle(fontSize: CustomTheme().fontSize('lg')),
            ),
            TextSpan(
              text: woNo,
              style: TextStyle(
                  fontWeight: CustomTheme().fontWeight('bold'),
                  fontSize: CustomTheme().fontSize('lg')),
            ),
            TextSpan(
              text: ' tidak diselesaikan dan semua perubahan tidak disimpan!',
              style: TextStyle(fontSize: CustomTheme().fontSize('lg')),
            ),
          ],
        ),
      );
    }

    if (context.mounted) {
      if (widget.form?['wo_id'] != null) {
        showConfirmationDialog(
            context: context,
            isLoading: _isLoading,
            onConfirm: () async {
              await Future.delayed(Duration(milliseconds: 200));
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            title: 'Batal',
            buttonBackground: CustomTheme().buttonColor('danger'),
            child: buildBoldMessage(widget.form?['no_wo']));
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }

  Future<void> _handleSubmit(BuildContext context) async {
    Widget buildBoldMessage(String woNo) {
      return RichText(
        text: TextSpan(
          style: TextStyle(
              fontSize: CustomTheme().fontSize('lg'),
              color: Colors.black,
              height: 1.5),
          children: [
            TextSpan(
              text:
                  'Anda yakin ingin menyelesaikan proses ${widget.label} untuk ',
              style: TextStyle(fontSize: CustomTheme().fontSize('lg')),
            ),
            TextSpan(
              text: woNo,
              style: TextStyle(
                  fontWeight: CustomTheme().fontWeight('bold'),
                  fontSize: CustomTheme().fontSize('lg')),
            ),
            TextSpan(
              text: '? Pastikan semua data sudah benar!',
              style: TextStyle(fontSize: CustomTheme().fontSize('lg')),
            ),
          ],
        ),
      );
    }

    if (context.mounted) {
      if (widget.form?['wo_id'] != null) {
        showConfirmationDialog(
            context: context,
            isLoading: _isSubmitting,
            onConfirm: () async {
              await Future.delayed(Duration(milliseconds: 200));
              _isSubmitting.value = true;
              try {
                await widget.handleSubmit(
                  data['id']?.toString() ?? processId,
                );
              } finally {
                _isSubmitting.value = false;
              }
            },
            title: 'Selesai Proses ${widget.label}',
            buttonBackground: CustomTheme().buttonColor('primary'),
            child: buildBoldMessage(widget.form?['no_wo']));
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
        builder: (context) => Center(
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
        builder: (context) => Center(
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
        builder: (context) => Center(
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
        builder: (context) => Center(
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
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );
      return;
    }

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
            widget.form?['grades'] ??= [];

            while (widget.form!['grades'].length <= index) {
              widget.form!['grades'].add({
                'item_grade_id': '',
                'unit_id': 1,
                'unit': {},
                'qty': '0',
                'notes': '',
              });
            }

            widget.form!['grades'][index]['unit_id'] =
                selected['value'].toString();

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
        builder: (context) => Center(
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
        builder: (context) => Center(
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

  double _getTotalItemQty() {
    final workOrders = data['work_orders'];
    if (workOrders == null) return 0;

    final List<dynamic>? items = workOrders['items'];

    if (items == null || items.isEmpty) return 0;

    return items.fold<double>(0, (sum, item) {
      final qty = double.tryParse(item['qty']?.toString() ?? '0') ?? 0;
      return sum + qty;
    });
  }

  void _validateWeight(String weight) {
    final greigeQty = double.tryParse(data['work_orders']['greige_qty']);
    final berat = double.tryParse(weight);

    if (greigeQty == null || berat == null || greigeQty <= 0) {
      setState(() {
        _weightWarningValidationMessage = null;
      });
      return;
    }

    final lowerLimit = greigeQty * 0.9;
    final upperLimit = greigeQty * 1.1;

    if (berat < lowerLimit || berat > upperLimit) {
      final diffPercent = ((berat - greigeQty) / greigeQty) * 100;

      setState(() {
        _weightWarningValidationMessage =
            'Berat ${berat < greigeQty ? 'kurang' : 'lebih'} '
            '${diffPercent.abs().toStringAsFixed(2)}% '
            '(Batas: ${lowerLimit.toStringAsFixed(0)} – ${upperLimit.toStringAsFixed(0)})';
      });
    } else {
      setState(() {
        _weightWarningValidationMessage = null;
      });
    }
  }

  void _validateQty(String woQty) {
    final qty = _getTotalItemQty();
    final berat = double.tryParse(woQty);

    if (qty <= 0 || berat == null) {
      setState(() {
        _itemWarningValidationMessage = null;
      });
      return;
    }

    final lowerLimit = qty * 0.9;
    final upperLimit = qty * 1.1;

    if (berat < lowerLimit || berat > upperLimit) {
      final diffPercent = ((berat - qty) / qty) * 100;

      setState(() {
        _itemWarningValidationMessage =
            'Qty ${berat < qty ? 'kurang' : 'lebih'} '
            '${diffPercent.abs().toStringAsFixed(2)}% '
            '(Batas: ${lowerLimit.toStringAsFixed(0)} – ${upperLimit.toStringAsFixed(0)})';
      });
    } else {
      setState(() {
        _itemWarningValidationMessage = null;
      });
    }
  }

  double getTotalItemQty() {
    final items = data['work_orders']?['items'] as List<dynamic>?;

    if (items == null || items.isEmpty) return 0;

    return items.fold<double>(0, (sum, item) {
      final qty = double.tryParse(item['qty']?.toString() ?? '0') ?? 0;
      return sum + qty;
    });
  }

  double getRemainingQtyForGrade(int index) {
    final totalQty = getTotalItemQty();
    if (totalQty == 0) return 0;

    final grades = widget.form?['grades'] as List<dynamic>?;

    if (grades == null) return totalQty;

    double usedQty = 0;

    for (int i = 0; i < grades.length; i++) {
      if (i == index) continue;

      final qty = double.tryParse(
            grades[i]?['qty']?.toString() ?? '0',
          ) ??
          0;

      usedQty += qty;
    }

    final remaining = totalQty - usedQty;

    return remaining < 0 ? 0 : remaining;
  }

  bool isQtyFullyDistributed() {
    final totalQty = getTotalItemQty();
    if (totalQty <= 0) return false;

    final grades = widget.form?['grades'] as List<dynamic>?;
    if (grades == null || grades.isEmpty) return false;

    return grades.any((g) {
      final qty = double.tryParse(g['qty']?.toString() ?? '0') ?? 0;
      return qty > 0;
    });
  }

  void _onGradeChanged(List<dynamic> grades) {
    setState(() {
      widget.form!['grades'] = grades;
    });
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
      length: 2,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Color(0xFFf9fafc),
          appBar: CustomAppBar(
            title: widget.title,
            onReturn: () {
              _handleCancel(context);
            },
          ),
          body: SafeArea(
            child: Column(
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
                  ]),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _firstLoading
                          ? Center(child: CircularProgressIndicator())
                          : FinishFormTab(
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
                              gsm: _gsmController,
                              weightDozen: _weightDozenController,
                              totalWeight: _totalWeightController,
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
                              data: data['work_orders'],
                              forPacking: widget.forPacking,
                              validateWeight: _validateWeight,
                              weightWarning: _weightWarningValidationMessage,
                              validateQty: _validateQty,
                              qtyWarning: _itemWarningValidationMessage,
                              handleRemainingQtyForGrade:
                                  getRemainingQtyForGrade,
                              handleTotalItemQty: getTotalItemQty,
                              onGradeChanged: _onGradeChanged,
                            ),
                      WorkOrderInfoTab(
                        data: data['work_orders'],
                        label: widget.label,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: ProcessButton(
            data: data,
            form: widget.form,
            isSubmitting: _isSubmitting,
            labelProcess: 'Selesai',
            processId: processId,
            formKey: _formKey,
            handleSubmit: _handleSubmit,
            handleCancel: _handleCancel,
            weightWarning: _weightWarningValidationMessage,
            qtyWarning: _itemWarningValidationMessage,
            qty: _qtyController.text,
            weight: _weightController.text,
            isQtyFullyDistributed: isQtyFullyDistributed,
            withItemGrade: widget.withItemGrade,
            withItemQtyAndWeight: widget.withQtyAndWeight,
          ),
        ),
      ),
    );
  }
}
