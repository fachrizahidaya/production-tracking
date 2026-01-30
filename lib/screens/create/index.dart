// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/process/create/create_submit_section.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/providers/user_provider.dart';

class CreateProcess extends StatefulWidget {
  final String title;
  final Widget Function(
      BuildContext context,
      dynamic id,
      dynamic processId,
      Map<String, dynamic> data,
      Map<String, dynamic> form,
      Future<void> Function() handleSubmit) formPageBuilder;
  final handleSubmitToService;
  final fetchWorkOrder;
  final getWorkOrderOptions;

  const CreateProcess(
      {super.key,
      required this.title,
      required this.formPageBuilder,
      this.handleSubmitToService,
      this.fetchWorkOrder,
      this.getWorkOrderOptions});

  @override
  State<CreateProcess> createState() => _CreateProcessState();
}

class _CreateProcessState extends State<CreateProcess> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isLoading = false;
  bool _isScannerStopped = false;
  final WorkOrderService _workOrderService = WorkOrderService();
  late List<dynamic> workOrderOption = [];
  final ValueNotifier<bool> _firstLoading = ValueNotifier(false);

  final Map<String, dynamic> _form = {
    'wo_id': null,
    'machine_id': null,
    'unit_id': null,
    'start_by_id': null,
    'end_by_id': null,
    'qty': null,
    'width': null,
    'length': null,
    'notes': '',
    'status': null,
    'start_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'end_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'attachments': [],
    'no_wo': '',
    'no_process': '',
    'nama_mesin': '',
    'nama_satuan': '',
    'maklon': false,
    'maklon_name': ''
  };

  @override
  void initState() {
    super.initState();

    final loggedInUser = Provider.of<UserProvider>(context, listen: false).user;
    _form['start_by_id'] = loggedInUser?.id;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleFetchWorkOrder();
    });
  }

  Future<void> _handleFetchWorkOrder() async {
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

      _form['wo_id'] = data['id']?.toString() ?? woId;
      _form['no_wo'] = data['wo_no']?.toString() ?? woNo;
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
          ),
        ),
      );
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSubmit() async {
    try {
      if (widget.handleSubmitToService != null) {
        await widget.handleSubmitToService!(context, _form, _firstLoading);
      }
    } catch (e) {
      _showSnackBar(e.toString());
    }
  }

  Route _createRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
        body: CreateSubmitSection(
          isScannerStopped: _isScannerStopped,
          form: _form,
          controller: _controller,
          handleScan: _handleScan,
          handleSubmit: _handleSubmit,
          handleRoute: (form, handleSubmit) => _createRoute(
            widget.formPageBuilder(context, null, null, {}, form, handleSubmit),
          ),
          isLoading: _isLoading,
        ),
      ),
    );
  }
}
