// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/process/create/create_submit_section.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';

class CreateDyeingPreparationProcess extends StatefulWidget {
  final String title;
  final Widget Function(
    BuildContext context,
    dynamic id,
    dynamic processId,
    Map<String, dynamic> data,
    Map<String, dynamic> form,
    Future<void> Function() handleSubmit,
  ) formPageBuilder;
  final handleSubmitToService;

  const CreateDyeingPreparationProcess({
    super.key,
    required this.title,
    required this.formPageBuilder,
    this.handleSubmitToService,
  });

  @override
  State<CreateDyeingPreparationProcess> createState() =>
      _CreateDyeingPreparationProcessState();
}

class _CreateDyeingPreparationProcessState
    extends State<CreateDyeingPreparationProcess> {
  final MobileScannerController _controller = MobileScannerController();
  final WorkOrderService _workOrderService = WorkOrderService();
  final ValueNotifier<bool> _firstLoading = ValueNotifier(false);

  bool _isLoading = false;
  bool _isScannerStopped = false;
  late List<dynamic> workOrderOption = [];

  final Map<String, dynamic> _form = {
    'wo_id': null,
    'no_wo': '',
  };

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleFetchWorkOrder();
    });
  }

  Future<void> _handleFetchWorkOrder() async {
    final service = Provider.of<OptionWorkOrderService>(context, listen: false);

    try {
      await service.fetchDyeingPreparationOptions();

      setState(() {
        workOrderOption = service.dataListOption;
      });
    } catch (e) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  dynamic _findSelectedWorkOrder(String value) {
    for (final item in workOrderOption) {
      if (item['label']?.toString() == value ||
          item['wo_no']?.toString() == value ||
          item['value']?.toString() == value) {
        return item;
      }
    }

    return null;
  }

  Future<void> _handleScan(code) async {
    setState(() => _isLoading = true);

    try {
      final woNo = code.toString();

      if (woNo.isEmpty) {
        showAlertDialog(
          context: context,
          title: 'Error',
          message: "Invalid QR Code",
        );
        setState(() => _isLoading = false);
        return;
      }

      final selected = _findSelectedWorkOrder(woNo);

      if (selected == null) {
        showAlertDialog(
          context: context,
          title: 'Error',
          message: "Work Order not found",
        );
        setState(() => _isLoading = false);
        return;
      }

      final woId = selected['value']?.toString();

      if (woId == null || woId.isEmpty) {
        showAlertDialog(
          context: context,
          title: 'Error',
          message: "Work Order tidak valid",
        );
        setState(() => _isLoading = false);
        return;
      }

      await _workOrderService.getDataView(woId);
      final data = _workOrderService.dataView;

      _form['wo_id'] = data['id']?.toString() ?? woId;
      _form['no_wo'] =
          data['wo_no']?.toString() ?? selected['label']?.toString() ?? woNo;

      setState(() => _isLoading = false);

      Navigator.push(
        context,
        _createRoute(
          widget.formPageBuilder(
            context,
            woId,
            null,
            data,
            _form,
            _handleSubmit,
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

  Future<void> _handleSubmit() async {
    try {
      if (widget.handleSubmitToService != null) {
        await widget.handleSubmitToService!(context, _form, _firstLoading);
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
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
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
          child: CreateSubmitSection(
            isScannerStopped: _isScannerStopped,
            form: _form,
            controller: _controller,
            handleScan: _handleScan,
            handleSubmit: _handleSubmit,
            handleRoute: (form, handleSubmit) => _createRoute(
              widget.formPageBuilder(
                context,
                null,
                null,
                {},
                form,
                handleSubmit,
              ),
            ),
            isLoading: _isLoading,
          ),
        ),
      ),
    );
  }
}
