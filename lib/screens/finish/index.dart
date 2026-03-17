// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/process/finish/finish_submit_section.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_item.dart';
import 'package:textile_tracking/models/option/option_item_grade.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/providers/user_provider.dart';

class FinishProcess extends StatefulWidget {
  final String title;
  final Widget Function(
    BuildContext context,
    dynamic id,
    dynamic processId,
    Map<String, dynamic> data,
    Map<String, dynamic> form,
    Future<void> Function(String id) handleSubmit,
    void Function(String fieldName, dynamic value) handleChangeInput,
  ) formPageBuilder;
  final Map<String, dynamic>? initialData;
  final label;

  final Future<void> Function(
      BuildContext context,
      dynamic id,
      Map<String, dynamic> form,
      ValueNotifier<bool> isLoading)? handleSubmitToService;

  final Future<void> Function(OptionWorkOrderService service)? fetchWorkOrder;

  final List<dynamic> Function(OptionWorkOrderService service)?
      getWorkOrderOptions;

  final fetchItemGrade;
  final getItemGradeOptions;
  final String? manualWoId;
  final String? manualProcessId;
  final fetchFinishedItem;
  final getFinishedItemOptions;

  const FinishProcess(
      {super.key,
      required this.title,
      required this.formPageBuilder,
      this.handleSubmitToService,
      this.fetchWorkOrder,
      this.getWorkOrderOptions,
      this.getItemGradeOptions,
      this.fetchItemGrade,
      this.manualProcessId,
      this.manualWoId,
      this.initialData,
      this.fetchFinishedItem,
      this.getFinishedItemOptions,
      this.label});

  @override
  State<FinishProcess> createState() => _FinishProcessState();
}

class _FinishProcessState extends State<FinishProcess> {
  final MobileScannerController _controller = MobileScannerController();
  final WorkOrderService _workOrderService = WorkOrderService();

  final ValueNotifier<bool> _firstLoading = ValueNotifier(false);
  bool _isLoading = false;
  bool _isScannerStopped = false;

  List<dynamic> workOrderOption = [];
  List<dynamic> finishedItemOption = [];
  List<dynamic> itemGradeOption = [];
  String id = '';

  final Map<String, dynamic> _form = {
    'wo_id': null,
    'machine_id': null,
    'unit_id': 2,
    'item_unit_id': 1,
    'length_unit_id': 3,
    'width_unit_id': 3,
    'weight_unit_id': 2,
    'start_by_id': null,
    'end_by_id': null,
    'qty': '0',
    'item_qty': '0',
    'width': '0',
    'weight': '0',
    'length': '0',
    'total_weight': '0',
    'gsm': '0',
    'weight_per_dozen': '0',
    'notes': '',
    'status': null,
    'start_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'end_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'attachments': [],
    'no_wo': '',
    'nama_mesin': '',
    'nama_satuan': 'KG',
    'nama_satuan_panjang': 'CM',
    'nama_satuan_lebar': 'CM',
    'nama_satuan_berat': 'KG',
    'maklon': false,
    'maklon_name': '',
    'grades': [],
    'lot_celup_no': '',
    'finished_item_id': '',
    'nama_item': '',
  };

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initialize();

      if (widget.manualWoId != null && widget.manualProcessId != null) {
        await _handleManualProcess(
          widget.manualWoId!,
          widget.manualProcessId!,
        );
      }
    });

    if (widget.initialData != null) {
      _form.addAll(widget.initialData!);
    }
  }

  Future<void> _initialize() async {
    final loggedInUser = Provider.of<UserProvider>(context, listen: false).user;
    _form['end_by_id'] = loggedInUser?.id;
    await _handleFetchWorkOrder();
    await _handleFetchItemGrade();
  }

  Future<void> _handleFetchWorkOrder() async {
    final service = Provider.of<OptionWorkOrderService>(context, listen: false);

    if (widget.fetchWorkOrder != null) {
      await widget.fetchWorkOrder!(service);
    } else {
      await service.fetchOptions();
    }

    final options = widget.getWorkOrderOptions != null
        ? widget.getWorkOrderOptions!(service)
        : service.dataListOption;

    setState(() {
      workOrderOption = options;
    });
  }

  Future<void> _handleFetchFinishedMaterial(Map<String, dynamic> woData) async {
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
        process: widget.label.toLowerCase(),
        baseCode: baseCode,
        colorCode: colorCode,
      );

      final options = widget.getFinishedItemOptions != null
          ? widget.getFinishedItemOptions!(service)
          : service.dataListOption;

      setState(() {
        finishedItemOption = options;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    }
  }

  Future<void> _handleFetchItemGrade() async {
    final service = Provider.of<OptionItemGradeService>(context, listen: false);

    if (widget.fetchItemGrade != null) {
      await widget.fetchItemGrade!(service);
    } else {
      await service.fetchOptions();
    }

    final options = widget.getItemGradeOptions != null
        ? widget.getItemGradeOptions!(service)
        : service.dataListOption;

    setState(() {
      itemGradeOption = options;
    });
  }

  void _handleChangeInput(String field, dynamic value) {
    setState(() {
      _form[field] = value;
    });
  }

  Future<void> _handleScan(code) async {
    setState(() => _isLoading = true);
    try {
      final String woNo = code.toString();

      if (woNo.isEmpty) {
        showAlertDialog(
            context: context, title: 'Error', message: "Invalid QR Code");
        setState(() => _isLoading = false);
        return;
      }

      final woForm = {'wo_no': woNo};
      final ValueNotifier<bool> isSubmitting = ValueNotifier(false);

      final processResponse =
          await _workOrderService.getProcessData(woForm, isSubmitting);

      if (processResponse == null) {
        showAlertDialog(
            context: context,
            title: 'Error',
            message: "No process data found for this Work Order");
        setState(() => _isLoading = false);
        return;
      }

      final String woId = processResponse['wo_id'].toString();
      final String processId = processResponse['process_id'].toString();

      final bool workOrderExists =
          workOrderOption.any((item) => item['value'].toString() == woId);

      if (!workOrderExists) {
        showAlertDialog(
            context: context, title: 'Error', message: "Work Order not found");
        setState(() => _isLoading = false);
        return;
      }

      await _workOrderService.getDataView(woId);
      final data = _workOrderService.dataView;
      final greigeQty = data['greige_qty'];

      if (greigeQty != null &&
          greigeQty.toString().isNotEmpty &&
          widget.label == 'Dyeing') {
        _form['item_qty'] = greigeQty.toString();
      }

      if (greigeQty != null && greigeQty.toString().isNotEmpty) {
        _form['weight'] = greigeQty.toString();
      }

      if (widget.label == 'Dyeing' ||
          widget.label == 'Long Hemming' ||
          widget.label == 'Sewing' ||
          widget.label == 'Packing') {
        await _handleFetchFinishedMaterial(data);
      }

      _form['wo_id'] = data['id']?.toString() ?? woId;
      _form['no_wo'] = data['wo_no']?.toString() ?? woNo;
      _form['process_id'] = processId;

      setState(() => _isLoading = false);

      Navigator.push(
          context,
          _createRoute(widget.formPageBuilder(
            context,
            woId,
            processId,
            data,
            _form,
            _handleSubmit,
            _handleChangeInput,
          )));
    } catch (e) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleManualProcess(String woId, String processId) async {
    setState(() => _isLoading = true);

    try {
      await _workOrderService.getDataView(woId);
      final data = _workOrderService.dataView;

      _form['wo_id'] = data['id']?.toString() ?? woId;
      _form['no_wo'] = data['wo_no'] ?? '';
      _form['process_id'] = processId;

      setState(() => _isLoading = false);

      Navigator.push(
        context,
        _createRoute(
          widget.formPageBuilder(
            context,
            woId,
            processId,
            data,
            _form,
            _handleSubmit,
            _handleChangeInput,
          ),
        ),
      );
    } catch (e) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSubmit(String id) async {
    try {
      if (widget.handleSubmitToService != null) {
        await widget.handleSubmitToService!(context, id, _form, _firstLoading);
      }
    } catch (e) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  Route _createRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xFFf9fafc),
        appBar: CustomAppBar(
          title: widget.title,
          onReturn: () => Navigator.pop(context),
        ),
        body: SafeArea(
          child: FinishSubmitSection(
            isScannerStopped: _isScannerStopped,
            form: _form,
            controller: _controller,
            handleScan: _handleScan,
            handleSubmit: _handleSubmit,
            handleRoute: (form, handleSubmit, handleChangeInput) =>
                _createRoute(widget.formPageBuilder(context, null, null, {},
                    form, handleSubmit, handleChangeInput)),
            isLoading: _isLoading,
            handleChangeInput: _handleChangeInput,
          ),
        ),
      ),
    );
  }
}
