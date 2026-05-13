// ignore_for_file: use_build_context_synchronously, unused_field, prefer_final_fields, file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/button/process_button.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/process/finish/work_order_info_tab.dart';
import 'package:textile_tracking/components/process/finish/finish_form_tab.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/safe_to_api.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/result/show_select_dialog.dart';
import 'package:textile_tracking/helpers/result/to_double.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_item.dart';
import 'package:textile_tracking/models/option/option_item_grade.dart';
import 'package:textile_tracking/models/option/option_item_type.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/components/process/finish/functions/fetch_function.dart';

class FinishProcessManual extends StatefulWidget {
  final title;
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final void Function(String fieldName, dynamic value)? handleChangeInput;
  final handleSubmit;
  final fetchWorkOrder;
  final fetchFinishItem;
  final getWorkOrderOptions;
  final getFinishedItemOptions;
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
  final woId;
  final forPacking;
  final forHemming;
  final forSewing;
  final finishedItemOptions;
  final finishedItemOptionGrb;

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
      this.forPacking,
      this.forHemming,
      this.forSewing,
      this.fetchFinishItem,
      this.getFinishedItemOptions,
      this.woId,
      this.finishedItemOptions,
      this.finishedItemOptionGrb});

  @override
  State<FinishProcessManual> createState() => _FinishProcessManualState();
}

class _FinishProcessManualState extends State<FinishProcessManual> {
  final WorkOrderService _workOrderService = WorkOrderService();
  bool _firstLoading = false;
  bool _isFetchingWorkOrder = false;
  bool _isFetchingFinishedMaterial = false;
  bool _isFetchingUnit = false;
  bool _isFetchingGrade = false;
  bool _isFetchingItemType = false;
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _listFormKey = GlobalKey();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _packingQtyController = TextEditingController();
  final TextEditingController _weightDozenController = TextEditingController();
  final TextEditingController _weightGradeAController = TextEditingController();
  final TextEditingController _gsmController = TextEditingController();
  final TextEditingController _totalWeightController = TextEditingController();
  final TextEditingController _qtyItemController = TextEditingController();
  final TextEditingController _dyeingLotNoController = TextEditingController();
  final TextEditingController _weightGoodController = TextEditingController();
  final TextEditingController _weightDefectController = TextEditingController();
  final TextEditingController _combingController = TextEditingController();
  final TextEditingController _sprayingController = TextEditingController();
  final TextEditingController _reworkLongHemmingController =
      TextEditingController();
  final List<TextEditingController> _qtyControllers = [];
  final List<TextEditingController> _notesControllers = [];
  final List<TextEditingController> _defectQtyControllers = [];

  List<Map<String, dynamic>> _selectedUnits = [];

  late List<dynamic> workOrderOption = [];
  late List<dynamic> finishedItemOption = [];
  late List<dynamic> itemGradeOption = [];
  late List<dynamic> itemTypeOption = [];
  late List<dynamic> unitOption = [];
  late List<dynamic> finishedItemGrb = [];
  late List<dynamic> finishedItemGood = [];

  Map<String, dynamic> woData = {};
  Map<String, dynamic> data = {};

  String? _weightWarningValidationMessage;
  String? _itemWarningValidationMessage;

  late List<Map<String, dynamic>> _defects;

  final FetchFunction _fetcher = FetchFunction();

  var processId = '';

  @override
  void initState() {
    super.initState();

    _packingQtyController.text = widget.form?['qty']?.toString() ?? '';
    _qtyController.text = widget.form?['qty']?.toString() ?? '';
    _qtyItemController.text = widget.form?['item_qty']?.toString() ?? '';
    _weightController.text = widget.form?['weight']?.toString() ?? '';
    _noteController.text = widget.form?['notes']?.toString() ?? '';
    _dyeingLotNoController.text =
        widget.form?['lot_celup_no']?.toString() ?? '';
    _weightDozenController.text =
        widget.form?['weight_per_dozen']?.toString() ?? '';
    _weightGradeAController.text =
        widget.form?['weight_grade_a']?.toString() ?? '';
    _gsmController.text = widget.form?['gsm']?.toString() ?? '';
    _totalWeightController.text =
        widget.form?['total_weight']?.toString() ?? '';
    _weightDefectController.text = widget.form?['bs_weight']?.toString() ?? '';
    _weightGoodController.text = widget.form?['good_weight']?.toString() ?? '';
    _combingController.text = widget.form?['combing']?.toString() ?? '';
    _sprayingController.text = widget.form?['spraying']?.toString() ?? '';
    _reworkLongHemmingController.text =
        widget.form?['rework_long_hemming']?.toString() ?? '';

    _defects = (widget.form?['defects'] ?? [])
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();
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

    if (widget.woId != null) {
      await _getDataView(widget.woId);
    }

    await _handleFetchWorkOrder();
    await _handleFetchItemGrade();
    await _handleFetchUnit();
    await _handleFetchItemType();

    if ((widget.finishedItemOptions ?? []).isEmpty) {
      await _handleFetchFinishedMaterial();
    } else {
      finishedItemOption = widget.finishedItemOptions!;
    }

    if ((widget.finishedItemOptionGrb ?? []).isEmpty) {
      await _handleFetchFinishedMaterialGrb();
    } else {
      finishedItemGrb = widget.finishedItemOptionGrb!;
    }

    setState(() {
      _firstLoading = false;
    });
  }

  void updateDefect(int index, String key, dynamic value) {
    setState(() {
      _defects[index][key] = value;
    });

    _handleChangeInput('defects', _defects);
  }

  Future<void> _handleFetchWorkOrder() async {
    setState(() => _isFetchingWorkOrder = true);

    try {
      final result = await _fetcher.fetchWorkOrder(
        context,
        customFetch: widget.fetchWorkOrder,
        customGetter: widget.getWorkOrderOptions,
      );

      setState(() {
        workOrderOption = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    } finally {
      setState(() => _isFetchingWorkOrder = false);
    }
  }

  String formatProcessLabel(String label) {
    final trimmed = label.trim().toLowerCase();

    if (trimmed.contains(' ')) {
      return trimmed.replaceAll(RegExp(r'\s+'), '_');
    }

    return trimmed;
  }

  Future<void> _handleFetchFinishedMaterial() async {
    setState(() {
      _isFetchingFinishedMaterial = true;
    });

    final service = Provider.of<OptionItemService>(context, listen: false);

    try {
      String baseCode = '';
      String colorCode = '';

      final itemCode = woData['items']?[0]?['item_code'] ?? '';

      if (itemCode.isNotEmpty) {
        final parts = itemCode.split('-');
        baseCode = parts.first;
        colorCode = parts.last;
      }

      await service.fetchOptions(
        process: formatProcessLabel(widget.label),
        baseCode: baseCode,
        colorCode: colorCode,
      );

      final data = widget.getFinishedItemOptions != null
          ? widget.getFinishedItemOptions!(service)
          : service.dataListOption;

      setState(() {
        finishedItemOption = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    } finally {
      setState(() {
        _isFetchingFinishedMaterial = false;
      });
    }
  }

  Future<void> _handleFetchFinishedMaterialGrb() async {
    final service = Provider.of<OptionItemService>(context, listen: false);

    try {
      String baseCode = '';
      String colorCode = '';

      final itemCode = woData['items']?[0]?['item_code'] ?? '';

      if (itemCode.isNotEmpty) {
        final parts = itemCode.split('-');
        baseCode = parts.first;
        colorCode = parts.last;
      }

      await service.fetchOptions(
        process: formatProcessLabel(widget.label),
        baseCode: baseCode,
        colorCode: widget.label == 'Sorting' ? 'grb' : colorCode,
      );

      final grbData = service.dataListOption;

      setState(() {
        finishedItemGrb = grbData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    }
  }

  Map<String, dynamic>? get firstWoItem {
    final items = woData['items'];

    if (items == null || items is! List || items.isEmpty) {
      return null;
    }

    return items.first;
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

  Future<void> _handleFetchItemType({String search = ''}) async {
    final service = context.read<OptionItemTypeService>();

    setState(() {
      _isFetchingItemType = true;
    });

    try {
      await service.fetchOptions(
        isInitialLoad: true,
        searchQuery: search,
      );

      setState(() {
        itemTypeOption = service.dataListOption;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    } finally {
      setState(() {
        _isFetchingItemType = false;
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
    setState(() => _firstLoading = true);

    await _workOrderService.getDataView(id);

    setState(() {
      woData = _workOrderService.dataView;

      final greigeQty = woData['greige_qty'];

      if (greigeQty != null && widget.label == 'Dyeing') {
        _qtyItemController.text = greigeQty.toString();
        _qtyController.text = greigeQty.toString();
        widget.form?['qty'] = greigeQty.toString();
      }

      if (greigeQty != null) {
        _weightController.text = greigeQty.toString();
        widget.form?['weight'] = greigeQty.toString();
      }

      _firstLoading = false;
    });

    await _handleFetchFinishedMaterial();
    await _handleFetchFinishedMaterialGrb();
  }

  Future<void> _getProcessView(id) async {
    await widget.processService.getDataView(context, id);

    setState(() {
      data = widget.processService.dataView;

      if (data['weight'] != null &&
          (widget.label != 'Sewing' &&
              widget.label != 'Long Hemming' &&
              widget.label != 'Cross Cutting')) {
        _weightController.text = woData['greige_qty'].toString();
        widget.form?['weight'] = woData['greige_qty'].toString();
      }
      if (data['good_weight'] != null) {
        _weightGoodController.text = data['good_weight'].toString();
        widget.form?['good_weight'] = data['good_weight'];
      }
      if (data['bs_weight'] != null) {
        _weightDefectController.text = data['bs_weight'].toString();
        widget.form?['bs_weight'] = data['bs_weight'];
      }

      if (data['combing'] != null) {
        _combingController.text = data['combing'].toString();
        widget.form?['combing'] = data['combing'];
      }
      if (data['spraying'] != null) {
        _sprayingController.text = data['spraying'].toString();
        widget.form?['spraying'] = data['spraying'];
      }
      if (data['rework_long_hemming'] != null) {
        _reworkLongHemmingController.text =
            data['rework_long_hemming'].toString();
        widget.form?['rework_long_hemming'] = data['rework_long_hemming'];
      }

      if (data['weight_per_dozen'] != null) {
        _weightDozenController.text = data['weight_per_dozen'].toString();
        widget.form?['weight_per_dozen'] = data['weight_per_dozen'];
      }
      if (data['weight_grade_a'] != null) {
        _weightGradeAController.text = data['weight_grade_a'].toString();
        widget.form?['weight_grade_a'] = data['weight_grade_a'];
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
        widget.form?['item_qty'] = data['item_qty'].toString();
      }
      if (data['qty'] != null) {
        _packingQtyController.text = data['qty'].toString();
        widget.form?['qty'] = data['qty'];
      }
      if (data['qty'] != null) {
        _qtyController.text = woData['greige_qty'].toString();
        widget.form?['qty'] = woData['greige_qty'];
      }
      if (data['notes'] != null) {
        _noteController.text = data['notes'].toString();
        widget.form?['notes'] = data['notes'];
      }
      if (data['lot_celup_no'] != null) {
        _dyeingLotNoController.text = data['lot_celup_no'].toString();
        widget.form?['lot_celup_no'] = data['lot_celup_no'];
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
      if (data['good_weight_unit'] != null) {
        widget.form?['good_weight_unit_id'] =
            data['good_weight_unit']['id'].toString();
        widget.form?['nama_satuan_berat_good'] =
            data['good_weight_unit']['name'].toString();
      }
      if (data['bs_weight_unit'] != null) {
        widget.form?['bs_weight_unit_id'] =
            data['bs_weight_unit']['id'].toString();
        widget.form?['nama_satuan_berat_bs'] =
            data['bs_weight_unit']['name'].toString();
      }

      if (data['greige_item'] != null) {
        widget.form?['greige_item_id'] = data['greige_item']['id'].toString();
        widget.form?['nama_greige_item'] =
            data['greige_item']['name'].toString();
        widget.form?['sku_greige_item'] =
            data['greige_item']['code'].toString();
      }

      if (data['machine_ids'] != null) {
        widget.form?['machine_ids'] = List.from(data['machine_ids']);
      }

      if (data['grades'] != null) {
        widget.form?['grades'] = List.from(data['grades']);
      }

      final rawDefects = List.from(data['defects'] ?? []);
      widget.form?['defects'] = rawDefects.map<Map<String, dynamic>>((defect) {
        return {
          'defect_type_id':
              defect['type']?['id'] ?? defect['defect_type_id'] ?? defect['id'],
          'qty': defect['qty'] ?? '0',
        };
      }).toList();

      _defects = (widget.form?['defects'] ?? [])
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
          .toList();

      if (data['maklon'] != null) {
        widget.form?['maklon'] = data['maklon'];
        widget.form?['maklon'] = data['maklon'];
      }

      if (data['maklon_name'] != null) {
        widget.form?['maklon_name'] = data['maklon_name'].toString();
        widget.form?['maklon_name'] = data['maklon_name'].toString();
      }

      for (var controller in _defectQtyControllers) {
        controller.dispose();
      }
      _defectQtyControllers.clear();
      for (var defect in _defects) {
        _defectQtyControllers.add(
          TextEditingController(text: defect['qty']?.toString() ?? '0'),
        );
      }
    });
  }

  Future<void> _handleCancel(BuildContext context) async {
    Widget buildBoldMessage(String woNo) {
      return RichText(
        text: TextSpan(
          style: TextStyle(
              fontSize: CustomTheme().fontSize('xl'),
              color: Colors.black,
              height: 1.5),
          children: [
            TextSpan(
              text: 'Anda yakin ingin kembali? ',
            ),
            TextSpan(
              text: woNo,
              style: TextStyle(
                fontWeight: CustomTheme().fontWeight('bold'),
              ),
            ),
            TextSpan(
              text: ' tidak diselesaikan dan semua perubahan tidak disimpan!',
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
            title: 'Batal Selesai ${widget.label}',
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
              fontSize: CustomTheme().fontSize('xl'),
              color: Colors.black,
              height: 1.5),
          children: [
            TextSpan(
              text:
                  'Anda yakin ingin menyelesaikan proses ${widget.label} untuk ',
            ),
            TextSpan(
              text: woNo,
              style: TextStyle(
                fontWeight: CustomTheme().fontWeight('bold'),
              ),
            ),
            TextSpan(
              text: '? Pastikan semua data sudah benar!',
            ),
          ],
        ),
      );
    }

    if (context.mounted) {
      widget.form?['good_weight'] = safeToApi(_weightGoodController.text);
      widget.form?['bs_weight'] = safeToApi(_weightDefectController.text);
      widget.form?['combing'] = safeToApi(_combingController.text);
      widget.form?['spraying'] = safeToApi(_sprayingController.text);
      widget.form?['rework_long_hemming'] =
          safeToApi(_reworkLongHemmingController.text);
      widget.form?['weight'] = safeToApi(_weightController.text);
      widget.form?['item_qty'] = safeToApi(_qtyItemController.text);
      widget.form?['qty'] = safeToApi(
        widget.label == 'Packing'
            ? _packingQtyController.text
            : _qtyController.text,
      );
      widget.form?['weight_per_dozen'] = safeToApi(_weightDozenController.text);
      widget.form?['weight_grade_a'] = _weightGradeAController.text;
      widget.form?['gsm'] = _gsmController.text;
      widget.form?['total_weight'] = safeToApi(_totalWeightController.text);

      if (widget.label == 'Sorting') {
        widget.form?['spraying'] = toDouble(widget.form?['spraying']);
        widget.form?['rework_long_hemming'] =
            toDouble(widget.form?['rework_long_hemming']);
        widget.form?['combing'] = toDouble(widget.form?['combing']);
      }

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
    showSelectDialog(
        context: context,
        title: 'Work Order',
        isLoading: null,
        isFetching: _isFetchingWorkOrder,
        handleChangeValue: (e) {
          setState(() {
            widget.form?['wo_id'] = e['value'].toString();
            widget.form?['no_wo'] = e['label'].toString();
            processId = e[widget.idProcess].toString();
          });

          _getDataView(e['value'].toString());
          _getProcessView(e[widget.idProcess].toString());
        },
        option: workOrderOption,
        selected: widget.form?['wo_id'].toString() ?? '');
  }

  _selectUnit() {
    showSelectDialog(
      context: context,
      title: 'Satuan',
      isFetching: _isFetchingUnit,
      option: unitOption,
      selected: widget.form?['weight_unit_id'].toString() ?? '',
      handleChangeValue: (e) {
        setState(() {
          widget.form?['weight_unit_id'] = e['value'].toString();
          widget.form?['nama_satuan_berat'] = e['label'].toString();
        });
      },
    );
  }

  _selectLengthUnit() {
    showSelectDialog(
        context: context,
        title: 'Satuan Panjang',
        isFetching: _isFetchingUnit,
        option: unitOption,
        selected: widget.form?['length_unit_id'].toString() ?? '',
        handleChangeValue: (e) {
          setState(() {
            widget.form?['length_unit_id'] = e['value'].toString();
            widget.form?['nama_satuan_panjang'] = e['label'].toString();
          });
        });
  }

  _selectWidthUnit() {
    showSelectDialog(
      context: context,
      title: 'Satuan Lebar',
      isFetching: _isFetchingUnit,
      option: unitOption,
      selected: widget.form?['width_unit_id'].toString() ?? '',
      handleChangeValue: (e) {
        setState(() {
          widget.form?['width_unit_id'] = e['value'].toString();
          widget.form?['nama_satuan_lebar'] = e['label'].toString();
        });
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
                'greige_item_id': null,
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
    showSelectDialog(
      context: context,
      title: 'Satuan Qty',
      isFetching: _isFetchingUnit,
      option: unitOption,
      selected: widget.form?['item_unit_id'].toString() ?? '',
      handleChangeValue: (e) {
        setState(() {
          widget.form?['item_unit_id'] = e['value'].toString();
          widget.form?['nama_satuan'] = e['label'].toString();
        });
      },
    );
  }

  _selectQtyDyeingUnit() {
    showSelectDialog(
      context: context,
      title: 'Satuan Qty',
      isFetching: _isFetchingUnit,
      option: unitOption,
      selected: widget.form?['unit_id'].toString() ?? '',
      handleChangeValue: (e) {
        setState(() {
          widget.form?['unit_id'] = e['value'].toString();
          widget.form?['nama_satuan'] = e['label'].toString();
        });
      },
    );
  }

  _selectFinishedMaterial() {
    final provider = Provider.of<OptionItemService>(context, listen: false);

    showDialog(
      context: context,
      builder: (_) => SelectDialog(
        label: 'Material Greige',
        options: (widget.finishedItemOptions != null &&
                widget.finishedItemOptions!.isNotEmpty)
            ? widget.finishedItemOptions!
            : finishedItemOption,
        selected: widget.form?['greige_item_id']?.toString(),
        isManyOption: true,
        isAnyAdditionalData: true,
        isLoading: provider.isLoading,
        hasMoreData: provider.hasMoreData,
        onSearch: (value) {
          provider.fetchOptions(
            isInitialLoad: true,
            searchQuery: value,
          );
        },
        onLoadMore: () {
          provider.fetchOptions();
        },
        handleChangeValue: (e) {
          setState(() {
            widget.form?['greige_item_id'] = e?['value']?.toString();
            widget.form?['nama_greige_item'] = e?['label']?.toString();
            widget.form?['sku_greige_item'] = e?['code']?.toString();
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
    final greigeQty = (data['work_orders']['greige_qty']);
    final berat = toDouble(weight);

    if (greigeQty == null || greigeQty <= 0) {
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
    final qty = widget.label == 'Packing' ? data['qty'] : _getTotalItemQty();
    final berat = toDouble(woQty);

    if (qty <= 0) {
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

  void _handleChangeInput(String fieldName, dynamic value) {
    setState(() {
      widget.form![fieldName] = value;

      if (fieldName == 'good_weight' && value != null) {
        _weightGoodController.text = value.toString();
      }
      if (fieldName == 'bs_weight' && value != null) {
        _weightDefectController.text = value.toString();
      }
      if (fieldName == 'combing' && value != null) {
        _combingController.text = value.toString();
      }
      if (fieldName == 'spraying' && value != null) {
        _sprayingController.text = value.toString();
      }
      if (fieldName == 'rework_long_hemming' && value != null) {
        _reworkLongHemmingController.text = value.toString();
      }
      if (fieldName == 'item_qty' && value != null) {
        _qtyItemController.text = value.toString();
      }
      if (fieldName == 'weight' && value != null) {
        _weightController.text = value.toString();
      }
      if (fieldName == 'qty' && value != null) {
        _qtyController.text = value.toString();
      }
      if (fieldName == 'qty' && value != null) {
        _packingQtyController.text = value.toString();
      }
      if (fieldName == 'weight_grade_a' && value != null) {
        _weightGradeAController.text = value.toString();
      }
    });
  }

  bool isAllMachineDone(List machines) {
    if (machines.isEmpty) return false;

    return machines.every((m) => m?['status'] == 'Selesai');
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
                      text: 'Info WO',
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
                              handleSelectLengthUnit: _selectLengthUnit,
                              handleChangeInput: _handleChangeInput,
                              handleSelectUnit: _selectUnit,
                              handleSelectWidthUnit: _selectWidthUnit,
                              qty: _qtyItemController,
                              dyeingQty: _qtyController,
                              packingQty: _packingQtyController,
                              length: _lengthController,
                              width: _widthController,
                              note: _noteController,
                              qtyItem: _qtyControllers,
                              weight: _weightController,
                              gsm: _gsmController,
                              weightDozen: _weightDozenController,
                              weightGradeA: _weightGradeAController,
                              totalWeight: _totalWeightController,
                              handleSelectWo: _selectWorkOrder,
                              handleSelectFinishedMaterial:
                                  _selectFinishedMaterial,
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
                              forHemming: widget.forHemming,
                              forSewing: widget.forSewing,
                              validateWeight: _validateWeight,
                              weightWarning: _weightWarningValidationMessage,
                              validateQty: _validateQty,
                              qtyWarning: _itemWarningValidationMessage,
                              handleRemainingQtyForGrade:
                                  getRemainingQtyForGrade,
                              handleTotalItemQty: getTotalItemQty,
                              onGradeChanged: _onGradeChanged,
                              dyeingLotNo: _dyeingLotNoController,
                              weightDefect: _weightDefectController,
                              combing: _combingController,
                              spraying: _sprayingController,
                              reworkLongHemming: _reworkLongHemmingController,
                              weightGood: _weightGoodController,
                              woData: woData,
                              itemTypeOption: itemTypeOption,
                              defects: _defects,
                              defectQty: _defectQtyControllers,
                              handleUpdateDefect: updateDefect,
                              finishedItem: finishedItemOption,
                              finishedItemGood: finishedItemGood,
                              finishedItemGrb: finishedItemGrb,
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
            isAllMachineDone: isAllMachineDone,
            label: widget.label,
          ),
        ),
      ),
    );
  }
}
