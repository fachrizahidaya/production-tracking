import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/service/finish_process.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/models/process/sewing.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/sewing/finish/finish_sewing_manual.dart';

class FinishSewing extends StatefulWidget {
  const FinishSewing({super.key});

  @override
  State<FinishSewing> createState() => _FinishSewingState();
}

class _FinishSewingState extends State<FinishSewing> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isLoading = false;
  bool _isScannerStopped = false;
  int number = 0;
  final ValueNotifier<bool> _firstLoading = ValueNotifier(false);

  final WorkOrderService _workOrderService = WorkOrderService();
  late List<dynamic> workOrderOption = [];

  final Map<String, dynamic> _form = {
    'wo_id': null,
    'machine_id': null,
    'weight_unit_id': null,
    'width_unit_id': null,
    'length_unit_id': null,
    'rework_reference_id': null,
    'start_by_id': null,
    'end_by_id': null,
    'weight': null,
    'width': null,
    'length': null,
    'notes': '',
    'rework': null,
    'status': null,
    'start_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'end_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'attachments': [],
    'no_wo': '',
    'no_lh': '',
    'nama_mesin': '',
    'nama_satuan_berat': '',
    'nama_satuan_panjang': '',
    'nama_satuan_lebar': '',
    'nama_satuan': '',
  };

  @override
  void initState() {
    final loggedInUser = Provider.of<UserProvider>(context, listen: false).user;
    _handleFetchWorkOrder();
    super.initState();

    setState(() {
      _form['end_by_id'] = loggedInUser?.id;
    });
  }

  void _handleChangeInput(fieldName, value) {
    setState(() {
      _form[fieldName] = value;
    });
  }

  Future<void> _handleFetchWorkOrder() async {
    await Provider.of<OptionWorkOrderService>(context, listen: false)
        .fetchSewingFinishOptions();
    final result = Provider.of<OptionWorkOrderService>(context, listen: false)
        .dataListSewingFinish;

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
        context,
        MaterialPageRoute(
          builder: (context) => FinishSewingManual(
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Future<void> _handleSubmit(id) async {
    try {
      final sewing = Sewing(
          wo_id: _form['wo_id'] != null
              ? int.tryParse(_form['wo_id'].toString())
              : null,
          weight_unit_id: _form['weight_unit_id'] != null
              ? int.tryParse(_form['weight_unit_id'].toString())
              : null,
          width_unit_id: _form['width_unit_id'] != null
              ? int.tryParse(_form['width_unit_id'].toString())
              : null,
          length_unit_id: _form['length_unit_id'] != null
              ? int.tryParse(_form['length_unit_id'].toString())
              : null,
          machine_id: _form['machine_id'] != null
              ? int.tryParse(_form['machine_id'].toString())
              : null,
          weight: (_form['weight']),
          width: (_form['width']),
          length: (_form['length']),
          notes: _form['notes'],
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

      final message = await Provider.of<SewingService>(context, listen: false)
          .finishItem(id, sewing, _firstLoading);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/sewings',
        (Route<dynamic> route) => false,
      );
    } catch (e) {
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
    return FinishProcess(
      title: 'Selesai Sewing',
      fetchWorkOrder: (service) async =>
          await service.fetchHemmingFinishOptions(),
      getWorkOrderOptions: (service) => service.dataListHemmingFinish,
      formPageBuilder:
          (context, id, data, form, handleSubmit, handleChangeInput) =>
              FinishSewingManual(
        id: id,
        data: data,
        form: form,
        handleSubmit: handleSubmit,
        handleChangeInput: handleChangeInput,
      ),
      handleSubmitToService: (context, id, form, isLoading) async {
        final sewing = Sewing(
          wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
          machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
          weight_unit_id:
              int.tryParse(form['weight_unit_id']?.toString() ?? ''),
          width_unit_id: int.tryParse(form['width_unit_id']?.toString() ?? ''),
          length_unit_id:
              int.tryParse(form['length_unit_id']?.toString() ?? ''),
          weight: form['weight'],
          width: form['width'],
          length: form['length'],
          notes: form['notes'],
          start_time: form['start_time'],
          end_time: form['end_time'],
          start_by_id: int.tryParse(form['start_by_id']?.toString() ?? ''),
          end_by_id: int.tryParse(form['end_by_id']?.toString() ?? ''),
          attachments: form['attachments'],
        );

        final message = await Provider.of<SewingService>(context, listen: false)
            .finishItem(id, sewing, isLoading);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        Navigator.pushNamedAndRemoveUntil(context, '/sewings', (_) => false);
      },
    );
  }
}
