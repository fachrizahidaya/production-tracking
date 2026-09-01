// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/process/create/create_submit_section.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/models/option/option_greige_order.dart';
import 'package:textile_tracking/providers/user_provider.dart';

class CreateGreigeOrderProcess extends StatefulWidget {
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
  final fetchGreigeOrder;
  final getGreigeOrderOptions;

  const CreateGreigeOrderProcess({
    super.key,
    required this.title,
    required this.formPageBuilder,
    this.handleSubmitToService,
    this.fetchGreigeOrder,
    this.getGreigeOrderOptions,
  });

  @override
  State<CreateGreigeOrderProcess> createState() =>
      _CreateGreigeOrderProcessState();
}

class _CreateGreigeOrderProcessState extends State<CreateGreigeOrderProcess> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isLoading = false;
  bool _isScannerStopped = false;

  late List<dynamic> greigeOrderOption = [];
  final ValueNotifier<bool> _firstLoading = ValueNotifier(false);

  final Map<String, dynamic> _form = {
    'order_greige_id': null,
    'machine_id': null,
    'warping_type': '',
    'yarn_qty': null,
    'notes': '',
    'skip_shearing': false
  };

  @override
  void initState() {
    super.initState();

    final loggedInUser = Provider.of<UserProvider>(context, listen: false).user;
    _form['start_by_id'] = loggedInUser?.id;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleFetchGreigeOrder();
    });
  }

  Future<void> _handleFetchGreigeOrder() async {
    final service =
        Provider.of<OptionGreigeOrderService>(context, listen: false);

    if (widget.fetchGreigeOrder != null) {
      await widget.fetchGreigeOrder!(service);
    }

    final data = widget.getGreigeOrderOptions != null
        ? widget.getGreigeOrderOptions!(service)
        : service.dataListOption;

    setState(() {
      greigeOrderOption = data;
    });
  }

  Map<String, dynamic> _normalizeGreigeOrderData(
      Map<String, dynamic> selected) {
    final label = selected['label']?.toString() ?? '';
    final items = selected['items'] ??
        selected['details'] ??
        (selected['item_code'] != null ? [selected] : []);

    return {
      ...selected,
      'id': selected['id'] ?? selected['value'],
      'wo_no': selected['wo_no'] ??
          selected['greige_order_no'] ??
          selected['og_no'] ??
          label,
      'items': items,
      'attachments': selected['attachments'] ?? [],
    };
  }

  Future<void> _handleScan(code) async {
    setState(() => _isLoading = true);

    try {
      final greigeOrderNo = code.toString();

      if (greigeOrderNo.isEmpty) {
        showAlertDialog(
          context: context,
          title: 'Error',
          message: "Invalid QR Code",
        );
        setState(() => _isLoading = false);
        return;
      }

      final selected = greigeOrderOption.cast<dynamic>().firstWhere(
            (item) =>
                item['label']?.toString() == greigeOrderNo ||
                item['greige_order_no']?.toString() == greigeOrderNo ||
                item['wo_no']?.toString() == greigeOrderNo ||
                item['value']?.toString() == greigeOrderNo,
            orElse: () => null,
          );

      if (selected == null) {
        showAlertDialog(
          context: context,
          title: 'Error',
          message: "Greige Order not found",
        );
        setState(() => _isLoading = false);
        return;
      }

      final data = _normalizeGreigeOrderData(
        Map<String, dynamic>.from(selected),
      );
      final greigeOrderId = data['id']?.toString();

      _form['order_greige_id'] = greigeOrderId;
      _form['no_greige_order'] = data['wo_no']?.toString() ?? greigeOrderNo;
      _form['warping_type'] = data['warping_type'];

      setState(() => _isLoading = false);

      Navigator.push(
        context,
        _createRoute(
          widget.formPageBuilder(
            context,
            greigeOrderId,
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

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

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
        backgroundColor: Color(0xFFf9fafc),
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
