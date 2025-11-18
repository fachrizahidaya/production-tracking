// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/form/finish/finish_submit_section.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_item_grade.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/providers/user_provider.dart';

class FinishProcess extends StatefulWidget {
  final String title;

  /// This builds the manual form page when the QR code is scanned or manually entered
  final Widget Function(
    BuildContext context,
    dynamic id,
    dynamic processId,
    Map<String, dynamic> data,
    Map<String, dynamic> form,
    Future<void> Function(String id) handleSubmit,
    void Function(String fieldName, dynamic value) handleChangeInput,
  ) formPageBuilder;

  /// Function for submission to service (context, id, form, loading)
  final Future<void> Function(
      BuildContext context,
      dynamic id,
      Map<String, dynamic> form,
      ValueNotifier<bool> isLoading)? handleSubmitToService;

  /// Function to fetch the work order options (custom per process)
  final Future<void> Function(OptionWorkOrderService service)? fetchWorkOrder;

  /// Function to get the work order option list (custom per process)
  final List<dynamic> Function(OptionWorkOrderService service)?
      getWorkOrderOptions;

  final fetchItemGrade;
  final getItemGradeOptions;

  const FinishProcess(
      {super.key,
      required this.title,
      required this.formPageBuilder,
      this.handleSubmitToService,
      this.fetchWorkOrder,
      this.getWorkOrderOptions,
      this.getItemGradeOptions,
      this.fetchItemGrade});

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
  List<dynamic> itemGradeOption = [];
  String id = '';

  final Map<String, dynamic> _form = {
    'wo_id': null,
    'machine_id': null,
    'item_unit_id': null,
    'length_unit_id': null,
    'width_unit_id': null,
    'weight_unit_id': null,
    'start_by_id': null,
    'end_by_id': null,
    'item_qty': null,
    'width': null,
    'weight': null,
    'length': null,
    'notes': '',
    'status': null,
    'start_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'end_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'attachments': [],
    'no_wo': '',
    'nama_mesin': '',
    'nama_satuan': '',
    'nama_satuan_panjang': '',
    'nama_satuan_lebar': '',
    'nama_satuan_berat': '',
    'maklon': false,
    'maklon_name': '',
    'grades': []
  };

  @override
  void initState() {
    super.initState();
    _initialize();
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
        _showSnackBar("Work Order not found");
        setState(() => _isLoading = false);
        return;
      }

      final woForm = {'wo_no': woNo};
      final ValueNotifier<bool> isSubmitting = ValueNotifier(false);

      final processResponse =
          await _workOrderService.getProcessData(woForm, isSubmitting);

      if (processResponse == null) {
        _showSnackBar("No process data found for this Work Order");
        setState(() => _isLoading = false);
        return;
      }

      final String woId = processResponse['wo_id'].toString();
      final String processId = processResponse['process_id'].toString();

      final bool workOrderExists =
          workOrderOption.any((item) => item['value'].toString() == woId);

      if (!workOrderExists) {
        _showSnackBar("Work Order not found in the list");
        setState(() => _isLoading = false);
        return;
      }

      await _workOrderService.getDataView(woId);
      final data = _workOrderService.dataView;

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
      _showSnackBar("Error: ${e.toString()}");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSubmit(String id) async {
    try {
      if (widget.handleSubmitToService != null) {
        await widget.handleSubmitToService!(context, id, _form, _firstLoading);
      } else {
        _showSnackBar("No submission handler provided");
      }
    } catch (e) {
      _showSnackBar(e.toString());
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

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFf9fafc),
        appBar: CustomAppBar(
          title: widget.title,
          onReturn: () => Navigator.pop(context),
        ),
        body: FinishSubmitSection(
          isScannerStopped: _isScannerStopped,
          form: _form,
          controller: _controller,
          handleScan: _handleScan,
          handleSubmit: _handleSubmit,
          handleRoute: (form, handleSubmit, handleChangeInput) => _createRoute(
              widget.formPageBuilder(context, null, null, {}, form,
                  handleSubmit, handleChangeInput)),
          isLoading: _isLoading,
          handleChangeInput: _handleChangeInput,
        ),
      ),
    );
  }
}
