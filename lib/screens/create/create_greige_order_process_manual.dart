// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/process/create/greige_tab_section.dart';
import 'package:textile_tracking/helpers/result/show_select_dialog.dart';
import 'package:textile_tracking/models/option/option_greige_order.dart';
import 'package:textile_tracking/models/option/option_machine.dart';

class CreateGreigeOrderProcessManual extends StatefulWidget {
  final String title;
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchGreigeOrder;
  final getGreigeOrderOptions;
  final fetchMachine;
  final getMachineOptions;
  final maklonName;
  final isMaklon;
  final label;
  final withMaklonOrMachine;
  final withOnlyMaklon;
  final withNoMaklonOrMachine;
  final processService;
  final processId;
  final idProcess;

  const CreateGreigeOrderProcessManual({
    super.key,
    required this.title,
    this.id,
    this.data,
    this.form,
    this.handleSubmit,
    this.fetchGreigeOrder,
    this.getGreigeOrderOptions,
    this.fetchMachine,
    this.getMachineOptions,
    this.maklonName,
    this.label,
    this.withMaklonOrMachine,
    this.withOnlyMaklon,
    this.withNoMaklonOrMachine,
    this.processService,
    this.processId,
    this.idProcess,
    this.isMaklon,
  });

  @override
  State<CreateGreigeOrderProcessManual> createState() =>
      _CreateGreigeOrderProcessManualState();
}

class _CreateGreigeOrderProcessManualState
    extends State<CreateGreigeOrderProcessManual> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _yarnQtyController = TextEditingController();
  final TextEditingController _beamQtyController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();

  bool _firstLoading = false;
  bool _isFetchingGreigeOrder = false;
  bool _isFetchingMachine = false;
  List<dynamic> greigeOrderOption = [];
  List<dynamic> machineOption = [];
  List<Map<String, dynamic>> spkDocuments = [];

  Map<String, dynamic> data = {};
  Map<String, dynamic> greigeOrderData = {};

  var processId = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.data != null && widget.data!.isNotEmpty) {
        setState(() {
          greigeOrderData = _normalizeGreigeOrderData(widget.data!);
          _applyWarpingInitialData(greigeOrderData);
        });
      }

      _fetchGreigeOrder();
      _fetchMachine();

      if (widget.processId != null) {
        _getProcessView(widget.processId);
      }
    });
  }

  Future<void> _fetchGreigeOrder() async {
    setState(() {
      _isFetchingGreigeOrder = true;
    });

    final service =
        Provider.of<OptionGreigeOrderService>(context, listen: false);

    try {
      if (widget.fetchGreigeOrder != null) {
        await widget.fetchGreigeOrder!(service);
      }

      final data = widget.getGreigeOrderOptions != null
          ? widget.getGreigeOrderOptions!(service)
          : service.dataListOption;

      setState(() {
        greigeOrderOption = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    } finally {
      setState(() {
        _isFetchingGreigeOrder = false;
      });
    }
  }

  Future<void> _fetchMachine() async {
    setState(() {
      _isFetchingMachine = true;
    });

    final service = Provider.of<OptionMachineService>(context, listen: false);

    try {
      if (widget.fetchMachine != null) {
        await widget.fetchMachine!(service);
      } else {
        await service.fetchOptions();
      }

      final data = widget.getMachineOptions != null
          ? widget.getMachineOptions!(service)
          : service.dataListOption;

      setState(() {
        machineOption = data;
      });
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

  Future<void> _getProcessView(id) async {
    await widget.processService.getDataView(context, id);

    setState(() {
      data = widget.processService.dataView;
    });
  }

  void _handleChangeInput(String key, dynamic value) {
    setState(() {
      widget.form?[key] = value;
    });
  }

  void _applyWarpingInitialData(Map<String, dynamic> source) {
    if (widget.label != 'Warping') return;

    final isSingle = source['warping_type'] == 'single_warping';

    final yarnQty = source['yarn_qty'];

    widget.form?['yarn_qty'] = yarnQty;
    _yarnQtyController.text = yarnQty?.toString() ?? '';

    if (isSingle) {
      final beamQty = source['beam_qty'] ?? source['beam'];

      widget.form?['beam_qty'] = beamQty;
      widget.form?.remove('section');

      _beamQtyController.text = beamQty?.toString() ?? '';
      _sectionController.clear();
    } else {
      final section = source['section_qty'] ?? source['section'];

      widget.form?['section'] = section;
      widget.form?.remove('beam_qty');

      _sectionController.text = section?.toString() ?? '';
      _beamQtyController.clear();
    }
  }

  Map<String, dynamic> _normalizeGreigeOrderData(
      Map<String, dynamic> selected) {
    final label = selected['label']?.toString() ?? '';
    final items = selected['items'] ??
        selected['details'] ??
        (selected['item_code'] != null
            ? [selected]
            : selected['article'] != null
                ? [
                    {
                      'item_code': selected['article'],
                    }
                  ]
                : []);

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

  Future<void> _getGreigeOrderView(
    dynamic id,
    Map<String, dynamic> selectedData,
  ) async {
    setState(() {
      _firstLoading = true;
    });

    final service =
        Provider.of<OptionGreigeOrderService>(context, listen: false);

    try {
      await service.getDataView(id);

      final detailData = _normalizeGreigeOrderData({
        ...selectedData,
        ...service.dataView,
        'items': service.dataView['items'] ?? selectedData['items'] ?? [],
      });

      setState(() {
        greigeOrderData = detailData;
        widget.form?['no_greige_order'] = detailData['wo_no']?.toString();
        widget.form?['warping_type'] = detailData['warping_type'];
        _applyWarpingInitialData(detailData);
      });
    } catch (_) {
      setState(() {
        greigeOrderData = selectedData;
      });
    } finally {
      setState(() {
        _firstLoading = false;
      });
    }
  }

  Future<void> _selectGreigeOrder() async {
    if (_isFetchingGreigeOrder) {
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
          label: 'Order Greige',
          options: greigeOrderOption,
          selected: widget.form?['order_greige_id']?.toString() ?? '',
          handleChangeValue: (selected) async {
            final greigeOrderId = selected['value']?.toString();
            final processValue = selected[widget.idProcess];
            final selectedData = _normalizeGreigeOrderData(
              Map<String, dynamic>.from(selected),
            );

            setState(() {
              widget.form?['order_greige_id'] = greigeOrderId;
              widget.form?['no_greige_order'] =
                  selectedData['wo_no']?.toString();
              widget.form?['warping_type'] = selectedData['warping_type'];
              greigeOrderData = selectedData;
              _applyWarpingInitialData(selectedData);
            });

            if (greigeOrderId != null && greigeOrderId.isNotEmpty) {
              await _getGreigeOrderView(greigeOrderId, selectedData);
            }

            if (processValue != null && processValue.toString().isNotEmpty) {
              processId = processValue.toString();
              _getProcessView(processId);
            }
          },
        );
      },
    );
  }

  Future<void> _selectMachine() async {
    showSelectDialog(
      context: context,
      title: 'Mesin',
      isFetching: _isFetchingMachine,
      option: machineOption,
      handleChangeValue: (selected) {
        setState(() {
          widget.form?['machine_id'] = selected['value'].toString();
          widget.form?['nama_mesin'] = selected['label'].toString();
        });
      },
      selected: widget.form?['machine_id']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    widget.form?.clear();
    _noteController.dispose();
    _yarnQtyController.dispose();
    _beamQtyController.dispose();
    _sectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GreigeTabSection(
      id: widget.id,
      title: widget.title,
      form: widget.form,
      label: widget.label,
      formKey: _formKey,
      greigeOrderData: widget.data != null && widget.data!.isNotEmpty
          ? widget.data!
          : greigeOrderData,
      processData: data,
      handleSubmit: widget.handleSubmit,
      firstLoading: _firstLoading,
      isSubmitting: _isSubmitting,
      selectMachine: _selectMachine,
      selectGreigeOrder: _selectGreigeOrder,
      spkDocuments: spkDocuments,
      handleChangeInput: _handleChangeInput,
      note: _noteController,
      yarnQty: _yarnQtyController,
      beamQty: _beamQtyController,
      section: _sectionController,
    );
  }
}
