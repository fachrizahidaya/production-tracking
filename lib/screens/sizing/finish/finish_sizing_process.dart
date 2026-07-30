// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/process/finish/finish_submit_section.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/models/option/option_greige_order.dart';
import 'package:textile_tracking/providers/user_provider.dart';

class FinishSizingProcess extends StatefulWidget {
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
  final Future<void> Function(
    BuildContext context,
    dynamic id,
    Map<String, dynamic> form,
    ValueNotifier<bool> isLoading,
  )? handleSubmitToService;

  const FinishSizingProcess({
    super.key,
    required this.title,
    required this.formPageBuilder,
    this.handleSubmitToService,
  });

  @override
  State<FinishSizingProcess> createState() => _FinishSizingProcessState();
}

class _FinishSizingProcessState extends State<FinishSizingProcess> {
  final MobileScannerController _controller = MobileScannerController();
  final OptionGreigeOrderService _greigeOrderService =
      OptionGreigeOrderService();
  final ValueNotifier<bool> _firstLoading = ValueNotifier(false);

  bool _isLoading = false;
  bool _isScannerStopped = false;
  List<dynamic> workOrderOption = [];

  final Map<String, dynamic> _form = {
    'order_greige_id': null,
    'machine_id': null,
    'roll_length': null,
    'notes': '',
  };

  @override
  void initState() {
    super.initState();

    final loggedInUser = Provider.of<UserProvider>(context, listen: false).user;
    _form['end_by_id'] = loggedInUser?.id;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleFetchWorkOrder();
    });
  }

  Future<void> _handleFetchWorkOrder() async {
    final service =
        Provider.of<OptionGreigeOrderService>(context, listen: false);
    await service.fetchSizingFinishOptions();

    setState(() {
      workOrderOption = service.dataListOption;
    });
  }

  void _handleChangeInput(String field, dynamic value) {
    setState(() {
      _form[field] = value;
    });
  }

  Future<void> _openFinishForm({
    required dynamic woId,
    required dynamic processId,
    required Map<String, dynamic> data,
  }) async {
    _form['order_greige_id'] = woId?.toString();
    _form['no_og'] = data['og_no']?.toString() ??
        data['label']?.toString() ??
        _form['no_og'] ??
        '';
    _form['process_id'] = processId?.toString();

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
  }

  Future<void> _handleScan(code) async {
    setState(() => _isLoading = true);

    try {
      final String woNo = code.toString();

      if (woNo.isEmpty) {
        showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Invalid QR Code',
        );
        setState(() => _isLoading = false);
        return;
      }

      final option = workOrderOption.firstWhere(
        (item) =>
            item['label']?.toString() == woNo ||
            item['wo_no']?.toString() == woNo,
        orElse: () => null,
      );

      if (option == null) {
        showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Greige Order Sizing tidak ditemukan',
        );
        setState(() => _isLoading = false);
        return;
      }

      final woId = option['value']?.toString();
      final processId = option['sizing_id']?.toString();

      await _greigeOrderService.getDataView(woId);
      final data = _greigeOrderService.dataView;

      await _openFinishForm(
        woId: woId,
        processId: processId,
        data: data,
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
        backgroundColor: const Color(0xFFf9fafc),
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
            handleChangeInput: _handleChangeInput,
            handleRoute: (form, handleSubmit, handleChangeInput) =>
                _createRoute(
              widget.formPageBuilder(
                context,
                null,
                null,
                {},
                form,
                handleSubmit,
                handleChangeInput,
              ),
            ),
            isLoading: _isLoading,
          ),
        ),
      ),
    );
  }
}
