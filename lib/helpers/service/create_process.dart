import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/form/create/create_submit_section.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/providers/user_provider.dart';

class CreateProcess extends StatefulWidget {
  final String title;
  final Widget Function(
      BuildContext context,
      dynamic id,
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
    _handleFetchWorkOrder();
    final loggedInUser = Provider.of<UserProvider>(context, listen: false).user;
    _form['start_by_id'] = loggedInUser?.id;
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

  Future<void> _handleScan(String code) async {
    setState(() => _isLoading = true);
    try {
      final scannedId = code.toString();
      final workOrderExists =
          workOrderOption.any((item) => item['value'].toString() == scannedId);

      if (!workOrderExists) {
        _showSnackBar("Work Order not found");
        setState(() => _isLoading = false);
        return;
      }

      await _workOrderService.getDataView(scannedId);
      final data = _workOrderService.dataView;

      _form['wo_id'] = data['id']?.toString();
      _form['no_wo'] = data['wo_no']?.toString() ?? '';

      setState(() => _isLoading = false);

      Navigator.push(
        context,
        _createRoute(
          widget.formPageBuilder(
            context,
            scannedId,
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
      } else {
        _showSnackBar("No submission handler provided");
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
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
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
          widget.formPageBuilder(context, null, {}, form, handleSubmit),
        ),
        isLoading: _isLoading,
      ),
    );
  }
}
