// ignore_for_file: use_build_context_synchronously, file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/detail/detail.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/result/show_select_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/models/master/machine.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_item.dart';
import 'package:textile_tracking/models/option/option_item_type.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_master_item_grade.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/screens/update/%5Bupdate_process_id%5D.dart';

class ProcessDetail<T> extends StatefulWidget {
  final String id;
  final String no;
  final bool canDelete;
  final bool canUpdate;
  final dynamic service;
  final Future<String> Function(
    BuildContext context,
    String id,
    T item,
    ValueNotifier<bool> isLoading,
  ) handleUpdateService;
  final Future<String> Function(
    BuildContext context,
    String id,
    ValueNotifier<bool> isLoading,
  ) handleDeleteService;
  final T Function(Map<String, dynamic> form, Map<String, dynamic> data)
      modelBuilder;
  final Future<void> Function(
      BuildContext context,
      dynamic id,
      Map<String, dynamic> form,
      ValueNotifier<bool> isLoading)? handleSubmitToService;
  final label;
  final route;
  final fetchMachine;
  final getMachineOptions;
  final withItemGrade;
  final withQtyAndWeight;
  final withMaklon;
  final onlySewing;
  final forDyeing;
  final idProcess;
  final processService;
  final forPacking;
  final fetchFinish;
  final fetchItemGrade;
  final getItemGradeOptions;
  final getWorkOrderOptions;
  final forSewing;
  final forHemming;
  final isMultiMachine;
  final prefix;

  const ProcessDetail(
      {super.key,
      required this.id,
      required this.no,
      required this.service,
      required this.handleUpdateService,
      required this.handleDeleteService,
      required this.modelBuilder,
      this.canDelete = false,
      this.canUpdate = false,
      this.label,
      this.route,
      this.fetchMachine,
      this.getMachineOptions,
      this.withItemGrade,
      this.withQtyAndWeight,
      this.withMaklon,
      this.onlySewing,
      this.forDyeing,
      this.idProcess,
      this.processService,
      this.forPacking,
      this.fetchFinish,
      this.handleSubmitToService,
      this.fetchItemGrade,
      this.getItemGradeOptions,
      this.getWorkOrderOptions,
      this.forHemming,
      this.forSewing,
      this.isMultiMachine = false,
      this.prefix});

  @override
  State<ProcessDetail<T>> createState() => _ProcessDetailState<T>();
}

class _ProcessDetailState<T> extends State<ProcessDetail<T>> {
  bool _firstLoading = true;
  bool _isFetchingMachine = false;
  bool _isFetchingUnit = false;
  bool _isFetchingItemType = false;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final WorkOrderService _workOrderService = WorkOrderService();
  final ValueNotifier<bool> _processLoading = ValueNotifier(false);
  final ValueNotifier<bool> _firstSubmitting = ValueNotifier(false);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _maklonNameController = TextEditingController();
  final TextEditingController _qtyItemController = TextEditingController();
  final TextEditingController _packingQtyController = TextEditingController();
  final TextEditingController _goodWeightController = TextEditingController();
  final TextEditingController _defectWeightController = TextEditingController();
  final TextEditingController _reworkLongHemmingController =
      TextEditingController();
  final TextEditingController _combingController = TextEditingController();
  final TextEditingController _sprayingController = TextEditingController();
  final TextEditingController _weightDozenController = TextEditingController();
  final TextEditingController _gsmController = TextEditingController();
  final TextEditingController _totalWeightController = TextEditingController();
  final TextEditingController _weightGradeAController = TextEditingController();
  final TextEditingController _totalSortingController = TextEditingController();
  final List<TextEditingController> _qtyControllers = [];
  final List<TextEditingController> _notesControllers = [];
  final List<TextEditingController> _defectQtyControllers = [];

  late List<dynamic> itemGradeOption = [];
  late List<dynamic> unitOption = [];
  late List<dynamic> machineOption = [];
  late List<dynamic> itemTypeOption = [];
  late List<dynamic> finishedItemMaterial = [];
  late List<dynamic> finishedItemGrb = [];
  late List<dynamic> finishedItemGood = [];

  late List<dynamic> _grades;
  late List<Map<String, dynamic>> _defects;

  Map<String, dynamic> woData = {};
  Map<String, dynamic> data = {};

  final Map<String, dynamic> _form = {
    'wo_id': null,
    'machine_id': null,
    'weight_unit_id': 2,
    'item_unit_id': 1,
    'unit_id': 1,
    'item_qty': '0',
    'greige_item_id': null,
    'qty': '0',
    'weight': '0',
    'good_weight': '0',
    'bs_weight': '0',
    'notes': '',
    'attachments': [],
    'grades': [],
    'defects': [],
    'nama_mesin': '',
    'nama_satuan_panjang': '',
    'nama_satuan_lebar': '',
    'nama_satuan_berat': '',
    'nama_satuan': '',
    'start_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'end_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'maklon': false,
    'maklon_name': '',
    'machine_ids': [],
    'machines': [],
    'rework_long_hemming': '0',
    'combing': '0',
    'spraying': '0',
    'weight_per_dozen': '0',
    'gsm': '0',
    'total_weight': '0',
    'weight_grade_a': '0',
    'total_sorting': '0'
  };

  final fieldConfigs = [
    {'name': 'weight', 'label': 'Berat'},
    {'name': 'notes', 'label': 'Catatan'},
  ];

  @override
  void initState() {
    super.initState();
    _grades = (_form['grades'] ?? [])
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();
    _defects = (_form['defects'] ?? [])
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postInit();
    });
  }

  void _syncGradesWithOptions() {
    final List<Map<String, dynamic>> updated = [];

    for (var grade in itemGradeOption) {
      final existing = _grades.firstWhere(
        (g) => g['item_grade_id'].toString() == grade['id'].toString(),
        orElse: () => <String, dynamic>{},
      );

      updated.add({
        'item_grade_id': grade['id'],
        'unit_id': existing['unit_id'] ?? 1,
        'qty': existing['qty'] ?? '0',
        'notes': existing['notes'] ?? '',
        'greige_item_id': existing['greige_item_id'],
      });
    }

    _grades = updated;
    _handleChangeInput('grades', _grades);
  }

  void _syncDefectsWithOptions() {
    final List<Map<String, dynamic>> updated = [];

    for (var defect in _defects) {
      // Extract defect type ID from nested structure or from flat structure
      final defectTypeId =
          defect['type']?['id'] ?? defect['defect_type_id'] ?? defect['id'];

      // Check if this defect type exists in master data
      final exists = (itemTypeOption).firstWhere(
        (type) => type['id'].toString() == defectTypeId.toString(),
        orElse: () => <String, dynamic>{},
      );

      // Only keep if exists in master data
      if (exists.isNotEmpty) {
        updated.add({
          'defect_type_id': defectTypeId,
          'qty': defect['qty'] ?? '0',
        });
      }
    }

    _defects = updated;
    _handleChangeInput('defects', _defects);
  }

  void updateGrade(int index, String key, dynamic value) {
    setState(() {
      _grades[index][key] = value;
    });

    _handleChangeInput('grades', _grades);
    _onGradeChanged(_grades);
  }

  void updateDefect(int index, String key, dynamic value) {
    setState(() {
      _defects[index][key] = value;
    });

    _handleChangeInput('defects', _defects);
  }

  Future<void> _postInit() async {
    await _getDataView();
    await _handleFetchUnit();
    await _handleFetchMachine();
    await _handleFetchItemType();
    await _handleFetchItemGrade();
    await _handleFetchFinishedMaterial();
    await _handleFetchFinishedGrbMaterial();
    await _handleFetchFinishedGoodMaterial();
    _syncGradesWithOptions();
    _syncDefectsWithOptions();
  }

  void _handleChangeInput(String fieldName, dynamic value) {
    setState(() {
      _form[fieldName] = value;
    });
  }

  String _getSubmitAlertMessage(Object error) {
    final message = error.toString();

    if (message.toLowerCase().contains('formatexception')) {
      return 'Gagal submit data';
    }

    return message;
  }

  Future<void> _handleSubmit(String id) async {
    try {
      if (widget.handleSubmitToService != null) {
        await widget.handleSubmitToService!(
            context, id, _form, _firstSubmitting);
      }
    } catch (e) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: _getSubmitAlertMessage(e),
      );
    }
  }

  Future<void> _getDataView() async {
    setState(() => _firstLoading = true);

    await widget.service.getDataView(context, widget.id);
    final fetched = widget.service.dataView;

    setState(() {
      data = fetched;
      _applyDataToControllers(fetched);
    });

    final woId = fetched?['wo_id'];
    if (woId != null) {
      await _getWoView(woId);
    }

    if (widget.label == 'Sorting') {
      await _getWoGradeTotalView(woId);
    }

    if (data['weight'] != null) {
      _weightController.text = data['weight'].toString();
      _form['weight'] = data['weight'];
    }

    if (data['good_weight'] != null) {
      _goodWeightController.text = data['good_weight'].toString();
      _form['good_weight'] = data['good_weight'];
    }

    if (data['bs_weight'] != null) {
      _defectWeightController.text = data['bs_weight'].toString();
      _form['bs_weight'] = data['bs_weight'];
    }

    if (data['qty'] != null) {
      _packingQtyController.text = data['qty'].toString();
      _form['qty'] = data['qty']?.toString() ?? '0';
    }
    if (data['weight_per_dozen'] != null) {
      _weightDozenController.text = data['weight_per_dozen'].toString();
      _form['weight_per_dozen'] = data['weight_per_dozen']?.toString() ?? '0';
    }
    if (data['total_weight'] != null) {
      _totalWeightController.text = data['total_weight'].toString();
      _form['total_weight'] = data['total_weight']?.toString() ?? '0';
    }
    if (data['weight_grade_a'] != null) {
      _weightGradeAController.text = data['weight_grade_a'].toString();
      _form['weight_grade_a'] = data['weight_grade_a']?.toString() ?? '0';
    }

    if (data['gsm'] != null) {
      _gsmController.text = data['gsm'].toString();
      _form['gsm'] = data['gsm']?.toString() ?? '0';
    }
    setState(() => _firstLoading = false);
  }

  Future<void> _getWoView(dynamic id) async {
    await _workOrderService.getDataView(id);

    setState(() {
      woData = _workOrderService.dataView;
    });
  }

  void _applyDataToControllers(Map<String, dynamic> d) {
    _qtyItemController.text = d['item_qty']?.toString() ?? '';
    _weightController.text = d['weight']?.toString() ?? '';
    _goodWeightController.text = d['good_weight']?.toString() ?? '';
    _defectWeightController.text = d['bs_weight']?.toString() ?? '';
    _lengthController.text = d['length']?.toString() ?? '';
    _widthController.text = d['width']?.toString() ?? '';
    _packingQtyController.text = d['qty']?.toString() ?? '';
    _weightDozenController.text = d['weight_per_dozen']?.toString() ?? '';
    _noteController.text = d['notes']?.toString() ?? '';
    _maklonNameController.text = d['maklon_name']?.toString() ?? '';
    _reworkLongHemmingController.text =
        d['rework_long_hemming']?.toString() ?? '';
    _combingController.text = d['combing']?.toString() ?? '';
    _sprayingController.text = d['spraying']?.toString() ?? '';

    _form['item_qty'] = d['item_qty']?.toString() ?? '';
    _form['weight'] = d['weight']?.toString() ?? '';

    _form['qty'] = d['qty']?.toString() ?? '';
    _form['weight_per_dozen'] = d['weight_per_dozen']?.toString() ?? '';
    _form['maklon_name'] = d['maklon_name'];
    _form['maklon'] = d['maklon'];
    _form['notes'] = d['notes'];
    _form['rework_long_hemming'] = d['rework_long_hemming'];
    _form['combing'] = d['combing'];
    _form['spraying'] = d['spraying'];
    _form['attachments'] = List.from(d['attachments'] ?? []);
    _form['machines'] = List.from(d['machines'] ?? []);
    _form['machine_ids'] = List.from(d['machine_ids'] ?? []);
    _form['grades'] = List.from(d['grades'] ?? []);

    final rawDefects = List.from(d['defects'] ?? []);
    _form['defects'] = rawDefects.map<Map<String, dynamic>>((defect) {
      return {
        'defect_type_id':
            defect['type']?['id'] ?? defect['defect_type_id'] ?? defect['id'],
        'qty': defect['qty'] ?? '0',
      };
    }).toList();

    if (d['item_unit'] != null) {
      _form['item_unit_id'] = d['item_unit']['id'].toString();
      _form['nama_satuan'] = d['item_unit']['name'].toString();
    }
    if (d['unit'] != null) {
      _form['unit_id'] = d['unit']['id'].toString();
      _form['nama_satuan'] = d['unit']['name'].toString();
    }
    if (d['weight_unit'] != null) {
      _form['weight_unit_id'] = d['weight_unit']['id'].toString();
      _form['nama_satuan_berat'] = d['weight_unit']['name'].toString();
    }
    if (d['machine'] != null) {
      _form['machine_id'] = d['machine']['id'].toString();
      _form['nama_mesin'] = d['machine']['name'].toString();
    }
    if (d['greige_item'] != null) {
      _form['greige_item_id'] = d['greige_item']['id'].toString();
      _form['nama_greige'] = d['greige_item']['name'].toString();
    }

    _grades = (_form['grades'] ?? [])
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();

    _defects = (_form['defects'] ?? [])
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();

    for (var controller in _qtyControllers) {
      controller.dispose();
    }
    _qtyControllers.clear();
    for (var grade in _grades) {
      _qtyControllers.add(
        TextEditingController(text: grade['qty']?.toString() ?? '0'),
      );
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
  }

  Future<void> _handleUpdate(String id) async {
    try {
      final item = widget.modelBuilder(_form, data);
      final message =
          await widget.handleUpdateService(context, id, item, _isLoading);

      Navigator.pop(context, true);
      Navigator.pop(context, true);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showAlertDialog(
            context: context,
            title: '${widget.label} Diubah',
            child: buildBoldMessage(message: message, prefix: widget.prefix));
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _handleNavigateToUpdate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProcess(
          id: widget.id,
          label: widget.label,
          form: _form,
          data: data,
          handleUpdate: _handleUpdate,
          handleSelectMachine: _selectMachine,
          handleSelectItemType: _selectItemType,
          withMaklon: widget.withMaklon,
          maklon: _maklonNameController,
          handleChangeInput: _handleChangeInput,
          withQtyAndWeight: widget.withQtyAndWeight,
          handleSelectQtyItemUnit: _selectQtyItemUnit,
          length: _lengthController,
          width: _widthController,
          weight: _weightController,
          handleSelectUnit: _selectUnit,
          handleSelectWidthUnit: _selectWidthUnit,
          handleSelectLengthUnit: _selectLengthUnit,
          isSubmitting: _isSubmitting,
          formKey: _formKey,
          grades: _grades,
          getMachineStatus: getMachineStatus,
          handleFetchMachine: _handleFetchMachine,
          qty: _qtyControllers,
          note: _noteController,
          defectQty: _defectQtyControllers,
          onGradeChanged: _onGradeChanged,
          itemGradeOption: itemGradeOption,
          itemTypeOption: itemTypeOption,
          defects: _defects,
          handleUpdateGrade: updateGrade,
          handleUpdateDefect: updateDefect,
          reworkLongHemming: _reworkLongHemmingController,
          combing: _combingController,
          spraying: _sprayingController,
          woData: woData,
          cuttingSewingQty: _qtyItemController,
          defectWeight: _defectWeightController,
          goodWeight: _goodWeightController,
          packingQty: _packingQtyController,
          weightPerDozen: _weightDozenController,
          gsm: _gsmController,
          totalWeight: _totalWeightController,
          weightGradeA: _weightGradeAController,
          finishedItemGrb: finishedItemGrb,
          finishedItemGood: finishedItemGood,
          finishedItemMaterial: finishedItemMaterial,
        ),
      ),
    );

    await _getDataView();
  }

  Future<void> _handleDelete(String id) async {
    showConfirmationDialog(
      context: context,
      title: 'Hapus Data',
      message: 'Apakah Anda yakin ingin menghapus proses?',
      isLoading: _processLoading,
      buttonBackground: CustomTheme().buttonColor('danger'),
      onConfirm: () async {
        try {
          final message =
              await widget.handleDeleteService(context, id, _processLoading);

          showAlertDialog(
              context: context, title: 'Dyeing Deleted', message: message);
          Navigator.pushNamedAndRemoveUntil(
              context, widget.route, (_) => false);
        } catch (e) {
          await showAlertDialog(
            context: context,
            title: 'Error',
            message: e.toString(),
          );
        }
      },
    );
  }

  Future<void> _handleFetchUnit() async {
    setState(() {
      _isFetchingUnit = true;
    });

    try {
      await Provider.of<OptionUnitService>(context, listen: false)
          .getDataListOption();
      setState(() {
        unitOption = Provider.of<OptionUnitService>(context, listen: false)
            .dataListOption;
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

  void _syncMachineStatusWithOptions() {
    final selectedMachines = List<Map<String, dynamic>>.from(
      data['machines'] ?? [],
    );

    final updated = selectedMachines.map((m) {
      final latest = machineOption.firstWhere(
        (opt) => opt['id'] == m['id'],
        orElse: () => m,
      );

      return {
        ...m,
        'status': latest['status'],
      };
    }).toList();

    setState(() {
      data['machines'] = updated;
      _form['machines'] = updated;
    });
  }

  Future<void> _handleFetchMachine() async {
    setState(() {
      _isFetchingMachine = true;
    });

    final service = Provider.of<OptionMachineService>(context, listen: false);

    try {
      final currentMachineIds =
          (data['machines'] as List<dynamic>?)?.map((m) => m['id']).toList() ??
              [];

      if (widget.fetchMachine != null) {
        if (widget.isMultiMachine == true) {
          await widget.fetchMachine!(service, currentMachineIds);
        } else {
          await widget.fetchMachine!(service, null);
        }
      } else {
        await service.fetchOptions();
      }

      final machineData = widget.getMachineOptions != null
          ? widget.getMachineOptions!(service)
          : service.dataListOption;

      setState(() {
        machineOption = machineData;
      });

      _syncMachineStatusWithOptions();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    } finally {
      setState(() {
        _isFetchingMachine = false;
      });
    }
  }

  String getMachineStatus(dynamic machineId) {
    final foundInOption = machineOption.firstWhere(
      (opt) => opt['value'] == machineId,
      orElse: () => null,
    );

    if (foundInOption != null && foundInOption['status'] != null) {
      return foundInOption['status'];
    }

    try {
      final machineService =
          Provider.of<MachineMasterService>(context, listen: false);
      final foundInMaster = machineService.items.firstWhere(
        (machine) => machine.id == machineId,
      );

      if (foundInMaster.status != null) {
        return foundInMaster.status!;
      }
    } catch (e) {}

    return 'Tersedia';
  }

  void _onGradeChanged(List<dynamic> grades) {
    setState(() {
      _form['grades'] = grades;
    });
  }

  Future<void> _handleFetchItemGrade({String search = ''}) async {
    final service = context.read<OptionMasterItemGradeService>();

    try {
      await service.fetchOptions(
        isInitialLoad: true,
        searchQuery: search,
      );
      setState(() {
        itemGradeOption = service.dataListOption;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
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

  String formatProcessLabel(String label) {
    final trimmed = label.trim().toLowerCase();

    // kalau lebih dari 1 kata → pakai underscore
    if (trimmed.contains(' ')) {
      return trimmed.replaceAll(RegExp(r'\s+'), '_');
    }

    return trimmed;
  }

  Future<void> _handleFetchFinishedMaterial() async {
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

      final data = service.dataListOption;

      setState(() {
        finishedItemMaterial = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    }
  }

  Future<void> _handleFetchFinishedGrbMaterial() async {
    final service = Provider.of<OptionItemService>(context, listen: false);

    try {
      String baseCode = '';

      final itemCode = woData['items']?[0]?['item_code'] ?? '';

      if (itemCode.isNotEmpty) {
        final parts = itemCode.split('-');
        baseCode = parts.first;
      }

      await service.fetchOptions(
        process: 'sorting',
        baseCode: baseCode,
        colorCode: 'grb',
      );

      final data = service.dataListOption;

      setState(() {
        finishedItemGrb = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    }
  }

  Future<void> _handleFetchFinishedGoodMaterial() async {
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
        process: 'packing',
        baseCode: baseCode,
        colorCode: colorCode,
      );

      final data = service.dataListOption;

      setState(() {
        finishedItemGood = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    }
  }

  @override
  void dispose() {
    _form.clear();
    _weightController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _noteController.dispose();
    _maklonNameController.dispose();
    _qtyItemController.dispose();
    _reworkLongHemmingController.dispose();
    _combingController.dispose();
    _sprayingController.dispose();
    _packingQtyController.dispose();
    _goodWeightController.dispose();
    _defectWeightController.dispose();
    _weightDozenController.dispose();
    for (var controller in _qtyControllers) {
      controller.dispose();
    }

    for (var controller in _defectQtyControllers) {
      controller.dispose();
    }
    super.dispose();
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
      builder: (_) => SelectDialog(
        label: 'Satuan',
        options: unitOption,
        selected: _form['weight_unit_id']?.toString(),
        handleChangeValue: (e) {
          setState(() {
            _form['weight_unit_id'] = e['value'].toString();
            _form['nama_satuan_berat'] = e['label'].toString();
          });
        },
      ),
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
          selected: _form['length_unit_id'].toString(),
          handleChangeValue: (e) {
            setState(() {
              _form['length_unit_id'] = e['value'].toString();
              _form['nama_satuan_panjang'] = e['label'].toString();
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
          selected: _form['width_unit_id'].toString(),
          handleChangeValue: (e) {
            setState(() {
              _form['width_unit_id'] = e['value'].toString();
              _form['nama_satuan_lebar'] = e['label'].toString();
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
        selected: _form['grades'][index]['unit_id'].toString(),
        handleChangeValue: (e) {
          setState(() {
            _form['grades'][index]['unit_id'] = e['value'].toString();
            _form['grades'][index]['unit']['name'] = e['label'].toString();
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
        selected: _form['item_unit_id'].toString(),
        handleChangeValue: (e) {
          setState(() {
            _form['item_unit_id'] = e['value'].toString();
            _form['nama_satuan'] = e['label'].toString();
          });
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> _selectMachine() async {
    if (widget.label == 'Long Hemming' ||
        widget.label == 'Cross Cutting' ||
        widget.label == 'Sewing') {
      Map<String, dynamic>? result;

      await showSelectDialog(
        context: context,
        title: 'Mesin',
        isFetching: _isFetchingMachine,
        option: machineOption,
        handleChangeValue: (selected) {
          result = {
            'id': selected['value'],
            'name': selected['label'],
            'code': selected['code'],
            'status': selected['status'] ?? 'Tersedia',
          };
        },
        selected: '',
      );

      return result;
    }

    /// SINGLE SELECT
    showSelectDialog(
      context: context,
      title: 'Mesin',
      isFetching: _isFetchingMachine,
      option: machineOption,
      handleChangeValue: (selected) {
        setState(() {
          _form['machine_id'] = selected['value'].toString();
          _form['nama_mesin'] = selected['label'].toString();
        });
      },
      selected: _form['machine_id']?.toString() ?? '',
    );

    return null;
  }

  Future<Map<String, dynamic>?> _selectItemType() async {
    Map<String, dynamic>? result;

    await showSelectDialog(
      context: context,
      title: 'Tipe BS',
      isFetching: _isFetchingItemType,
      option: itemTypeOption,
      handleChangeValue: (selected) {
        result = {
          'id': selected['id'],
          'name': selected['name'],
          'qty': 0,
        };
      },
      selected: '',
    );

    return result;
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

    final grades = _form['grades'] as List<dynamic>?;

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

  double _calculateTotalSortingFromWo() {
    final processData = woData['processes']?[10]?['data']?[0];

    if (processData == null) return 0;

    final rework = double.tryParse(
          processData['rework_long_hemming']?.toString() ?? '0',
        ) ??
        0;

    final combing = double.tryParse(
          processData['combing']?.toString() ?? '0',
        ) ??
        0;

    final spraying = double.tryParse(
          processData['spraying']?.toString() ?? '0',
        ) ??
        0;

    final gradesList = processData['grades'] ?? [];

    double totalGrades = 0;
    for (var grade in gradesList) {
      final qty = double.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
      totalGrades += qty;
    }

    return rework + combing + spraying + totalGrades;
  }

  Future<void> _getWoGradeTotalView(dynamic id) async {
    await _workOrderService.getDataView(id);

    setState(() {
      woData = _workOrderService.dataView;
    });

    final totalSorting = _calculateTotalSortingFromWo();

    setState(() {
      _totalSortingController.text = totalSorting.toStringAsFixed(0);
      _form['total_sorting'] = totalSorting.toString();
    });
  }

  bool isQtyFullyDistributed() {
    final totalQty = getTotalItemQty();
    if (totalQty <= 0) return false;

    final grades = _form['grades'] as List<dynamic>?;
    if (grades == null || grades.isEmpty) return false;

    return grades.any((g) {
      final qty = double.tryParse(g['qty']?.toString() ?? '0') ?? 0;
      return qty > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Detail(
      data: data,
      isLoading: _firstLoading,
      handleChangeInput: _handleChangeInput,
      weight: _weightController,
      length: _lengthController,
      width: _widthController,
      note: _noteController,
      form: _form,
      handleSelectLengthUnit: _selectLengthUnit,
      handleSelectWidthUnit: _selectWidthUnit,
      handleSelectQtyItemUnit: _selectQtyItemUnit,
      handleSelectMachine: _selectMachine,
      refetch: _getDataView,
      fieldConfigs: fieldConfigs,
      fieldControllers: {
        'weight': _weightController,
        'notes': _noteController,
      },
      no: widget.no,
      withItemGrade: widget.withItemGrade,
      qty: _qtyControllers,
      handleSelectQtyUnit: _selectQtyUnit,
      notes: _notesControllers,
      withQtyAndWeight: widget.withQtyAndWeight,
      qtyItem: _qtyItemController,
      withMaklon: widget.withMaklon,
      maklon: _maklonNameController,
      onlySewing: widget.onlySewing,
      label: widget.label,
      forDyeing: widget.forDyeing,
      canDelete: widget.canDelete,
      canUpdate: widget.canUpdate,
      handleDelete: _handleDelete,
      handleNavigateToUpdate: _handleNavigateToUpdate,
      handleRefetch: _getDataView,
      idProcess: widget.idProcess,
      processService: widget.processService,
      forPacking: widget.forPacking,
      fetchFinish: widget.fetchFinish,
      handleSubmit: _handleSubmit,
      itemGradeOption: itemGradeOption,
      fetchItemGrade: widget.fetchItemGrade,
      getItemGradeOptions: widget.getItemGradeOptions,
      forHemming: widget.forHemming,
      forSewing: widget.forSewing,
    );
  }
}
