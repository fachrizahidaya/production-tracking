import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/dyeing/rework/submit_section.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/models/process/dyeing.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/screens/dyeing/rework/rework_dyeing_manual.dart';

class ReworkDyeing extends StatefulWidget {
  const ReworkDyeing({super.key});

  @override
  State<ReworkDyeing> createState() => _ReworkDyeingState();
}

class _ReworkDyeingState extends State<ReworkDyeing> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isLoading = false;
  bool _isScannerStopped = false;
  int number = 0;
  final ValueNotifier<bool> _firstLoading = ValueNotifier(false);

  final WorkOrderService _workOrderService = WorkOrderService();
  late List<dynamic> workOrderOption = [];

  @override
  void initState() {
    final loggedInUser = Provider.of<UserProvider>(context, listen: false).user;
    _handleFetchWorkOrder();
    super.initState();

    setState(() {
      _form['end_by_id'] = loggedInUser?.id;
    });
  }

  final Map<String, dynamic> _form = {
    'wo_id': null,
    'machine_id': null,
    'unit_id': null,
    'rework_reference_id': null,
    'start_by_id': null,
    'end_by_id': null,
    'qty': null,
    'width': null,
    'length': null,
    'notes': '',
    'rework': null,
    'status': null,
    'start_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'end_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'attachments': [],
    'no_wo': '',
    'no_dyeing': '',
    'nama_mesin': '',
    'nama_satuan': '',
  };

  void _handleChangeInput(fieldName, value) {
    setState(() {
      _form[fieldName] = value;
    });
  }

  Future<void> _handleFetchWorkOrder() async {
    await Provider.of<OptionWorkOrderService>(context, listen: false)
        .fetchReworkOptions();
    // ignore: use_build_context_synchronously
    final result = Provider.of<OptionWorkOrderService>(context, listen: false)
        .dataListOption;

    setState(() {
      workOrderOption = result;
    });
  }

  Future<void> _handleScan(code) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final scannedId = code.toString();

      final workOrderExists =
          workOrderOption.any((item) => item['value'].toString() == scannedId);

      if (!workOrderExists) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Work Order not found")),
        );

        return;
      }

      await _workOrderService.getDataView(scannedId);

      final data = _workOrderService.dataView;

      _form['wo_id'] = data['id']?.toString();
      _form['no_wo'] = data['wo_no']?.toString() ?? '';

      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => ReworkDyeingManual(
            id: scannedId,
            data: data,
            form: _form,
            handleSubmit: _handleSubmit,
            handleChangeInput: _handleChangeInput,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Future<void> _handleSubmit(id) async {
    try {
      final dyeing = Dyeing(
          wo_id: _form['wo_id'] != null
              ? int.tryParse(_form['wo_id'].toString())
              : null,
          unit_id: _form['unit_id'] != null
              ? int.tryParse(_form['unit_id'].toString())
              : null,
          machine_id: _form['machine_id'] != null
              ? int.tryParse(_form['machine_id'].toString())
              : null,
          rework_reference_id: _form['rework_reference_id'] != null
              ? int.tryParse(_form['rework_reference_id'].toString())
              : null,
          qty: _form['qty'],
          width: _form['width'],
          length: _form['length'],
          notes: _form['notes'],
          rework: _form['rework'],
          status: _form['status'],
          start_time: _form['start_time'],
          end_time: _form['end_time'],
          start_by_id: _form['start_by_id'] != null
              ? int.tryParse(_form['start_by_id'].toString())
              : null,
          end_by_id: _form['end_by_id'] != null
              ? int.tryParse(_form['end_by_id'])
              : null,
          attachments: _form['attachments']);
      final message = await Provider.of<DyeingService>(context, listen: false)
          .reworkItem(id, dyeing, _firstLoading);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      Navigator.pushNamedAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        '/dyeings',
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  void dispose() {
    _form.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFf9fafc),
        appBar: CustomAppBar(
          title: 'Rework Dyeing',
          onReturn: () {
            Navigator.pop(context);
          },
        ),
        body: SubmitSection(
          isScannerStopped: _isScannerStopped,
          form: _form,
          controller: _controller,
          handleScan: _handleScan,
          handleSubmit: _handleSubmit,
          handleRoute: _createRoute,
          isLoading: _isLoading,
          handleChangeInput: _handleChangeInput,
        ));
  }
}

Route _createRoute(dynamic form, handleSubmit, handleChangeInput) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ReworkDyeingManual(
      id: null,
      data: null,
      form: form,
      handleSubmit: handleSubmit,
      handleChangeInput: handleChangeInput,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
