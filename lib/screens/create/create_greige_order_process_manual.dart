// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/process/create/greige_tab_section.dart';
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d0509dba (fix: mulai warping - shearing)
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_select_dialog.dart';
import 'package:textile_tracking/models/option/option_greige_order.dart';
=======
import 'package:textile_tracking/helpers/result/show_select_dialog.dart';
import 'package:textile_tracking/models/option/option_greige_order.dart';
<<<<<<< HEAD
import 'package:textile_tracking/models/option/option_item_semi_finished.dart';
>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> 1e3750ac (fix: create process)
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
<<<<<<< HEAD
<<<<<<< HEAD
  final String? optionBadgeKey;
=======
>>>>>>> a1ea7df (feat: warping)
=======
  final String? optionBadgeKey;
>>>>>>> c940e94a (fix:)

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
<<<<<<< HEAD
<<<<<<< HEAD
    this.optionBadgeKey,
=======
>>>>>>> a1ea7df (feat: warping)
=======
    this.optionBadgeKey,
>>>>>>> c940e94a (fix:)
  });

  @override
  State<CreateGreigeOrderProcessManual> createState() =>
      _CreateGreigeOrderProcessManualState();
}

class _CreateGreigeOrderProcessManualState
    extends State<CreateGreigeOrderProcessManual> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
<<<<<<< HEAD
<<<<<<< HEAD
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _yarnQtyController = TextEditingController();
  final TextEditingController _beamQtyController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();

  bool _firstLoading = false;
=======
  final SpkService _spkService = SpkService();
=======
>>>>>>> 1e3750ac (fix: create process)
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _yarnQtyController = TextEditingController();
  final TextEditingController _beamQtyController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();

<<<<<<< HEAD
  final bool _firstLoading = false;
>>>>>>> a1ea7df (feat: warping)
=======
  bool _firstLoading = false;
>>>>>>> 1e3750ac (fix: create process)
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

<<<<<<< HEAD
<<<<<<< HEAD
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.data != null && widget.data!.isNotEmpty) {
        setState(() {
          greigeOrderData = _normalizeGreigeOrderData(widget.data!);
          _applyWarpingInitialData(greigeOrderData);
        });
      }

<<<<<<< HEAD
=======
    spkDocuments = List<Map<String, dynamic>>.from(
      widget.form?['spk_documents'] ?? [],
    );

=======
>>>>>>> 1e3750ac (fix: create process)
    WidgetsBinding.instance.addPostFrameCallback((_) {
>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> 6aaef7aa (fix: create warping)
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
<<<<<<< HEAD
<<<<<<< HEAD
=======
      } else {
        await service.fetchWarpingOptions();
>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> 1e3750ac (fix: create process)
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

<<<<<<< HEAD
<<<<<<< HEAD
=======
  Future<void> _fetchSpkDocuments() async {
    final items = List<Map<String, dynamic>>.from(
      greigeOrderData['items'] ?? [],
    );

    final Map<String, Map<String, dynamic>> docs = {};

    for (final item in items) {
      final spkId = item['spk_id']?.toString();

      if (spkId == null || docs.containsKey(spkId)) {
        continue;
      }

      try {
        final result = await _spkService.getDocuments(spkId);

        docs[spkId] = {
          'spk_id': item['spk_id'],
          'spk_no': result['spk_no'] ?? item['spk_no'],
          'notes': result['notes'] ?? '',
          'attachments': List<Map<String, dynamic>>.from(
            result['attachments'] ?? [],
          ),
        };
      } catch (_) {}
    }

    setState(() {
      spkDocuments = docs.values.toList();
    });
  }

>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> 1e3750ac (fix: create process)
  void _handleChangeInput(String key, dynamic value) {
    setState(() {
      widget.form?[key] = value;
    });
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> c940e94a (fix:)
  dynamic _readWarpingType(dynamic source, [int depth = 0]) {
    if (source == null) return null;

    if (source is! Map) {
      final text = source.toString().trim();
      return text.isEmpty ? null : source;
    }

    final direct = source['warping_type'];
    if (direct != null &&
        direct is! Map &&
        direct.toString().trim().isNotEmpty) {
      return direct;
    }

    if (depth >= 3) return null;

    for (final value in source.values) {
      if (value is Map) {
        final found = _readWarpingType(value, depth + 1);
        if (found != null) return found;
      }
    }

    return null;
  }

<<<<<<< HEAD
=======
>>>>>>> 6aaef7aa (fix: create warping)
=======
>>>>>>> c940e94a (fix:)
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

<<<<<<< HEAD
=======
>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> 6aaef7aa (fix: create warping)
  Map<String, dynamic> _normalizeGreigeOrderData(
      Map<String, dynamic> selected) {
    final label = selected['label']?.toString() ?? '';
    final items = selected['items'] ??
        selected['details'] ??
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 1e3750ac (fix: create process)
        (selected['item_code'] != null
            ? [selected]
            : selected['article'] != null
                ? [
                    {
                      'item_code': selected['article'],
                    }
                  ]
                : []);
<<<<<<< HEAD
=======
        (selected['item_code'] != null ? [selected] : []);
>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> 1e3750ac (fix: create process)

    return {
      ...selected,
      'id': selected['id'] ?? selected['value'],
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 1e3750ac (fix: create process)
      'wo_no': selected['wo_no'] ??
          selected['greige_order_no'] ??
          selected['og_no'] ??
          label,
<<<<<<< HEAD
=======
      'wo_no': selected['wo_no'] ?? selected['greige_order_no'] ?? label,
>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> 1e3750ac (fix: create process)
      'items': items,
      'attachments': selected['attachments'] ?? [],
    };
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 1e3750ac (fix: create process)
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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> c940e94a (fix:)
        widget.form?['warping_type'] =
            _readWarpingType(detailData) ?? _readWarpingType(selectedData);
        _applyWarpingInitialData(detailData);
=======
        widget.form?['warping_type'] = detailData['warping_type'];
<<<<<<< HEAD
>>>>>>> 1e3750ac (fix: create process)
=======
        _applyWarpingInitialData(detailData);
>>>>>>> 6aaef7aa (fix: create warping)
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

<<<<<<< HEAD
=======
>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> 1e3750ac (fix: create process)
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
<<<<<<< HEAD
<<<<<<< HEAD
          label: 'Order Greige',
          options: greigeOrderOption,
          badgeKey: widget.optionBadgeKey,
<<<<<<< HEAD
          selected: widget.form?['order_greige_id']?.toString() ?? '',
          handleChangeValue: (selected) async {
=======
          label: 'Greige Order',
=======
          label: 'Order Greige',
>>>>>>> 3d28a283 (fix: mulai warping)
          options: greigeOrderOption,
=======
>>>>>>> c940e94a (fix:)
          selected: widget.form?['order_greige_id']?.toString() ?? '',
          handleChangeValue: (selected) async {
<<<<<<< HEAD
            final semiFinishedService =
                Provider.of<OptionItemSemiFinishedService>(
              context,
              listen: false,
            );

>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> 1e3750ac (fix: create process)
            final greigeOrderId = selected['value']?.toString();
            final processValue = selected[widget.idProcess];
            final selectedData = _normalizeGreigeOrderData(
              Map<String, dynamic>.from(selected),
            );

            setState(() {
<<<<<<< HEAD
<<<<<<< HEAD
              widget.form?['order_greige_id'] = greigeOrderId;
              widget.form?['no_greige_order'] =
                  selectedData['wo_no']?.toString();
              widget.form?['warping_type'] = _readWarpingType(selectedData);
              greigeOrderData = selectedData;
              _applyWarpingInitialData(selectedData);
            });

            if (greigeOrderId != null && greigeOrderId.isNotEmpty) {
              await _getGreigeOrderView(greigeOrderId, selectedData);
            }

=======
              widget.form?['wo_id'] = greigeOrderId;
              widget.form?['no_wo'] = selectedData['wo_no']?.toString();
=======
              widget.form?['order_greige_id'] = greigeOrderId;
              widget.form?['no_greige_order'] =
                  selectedData['wo_no']?.toString();
              widget.form?['warping_type'] = selectedData['warping_type'];
>>>>>>> 1e3750ac (fix: create process)
              greigeOrderData = selectedData;
              _applyWarpingInitialData(selectedData);
            });

            if (greigeOrderId != null && greigeOrderId.isNotEmpty) {
              await _getGreigeOrderView(greigeOrderId, selectedData);
            }

<<<<<<< HEAD
            widget.form?['items'] = items;

>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> 1e3750ac (fix: create process)
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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d0509dba (fix: mulai warping - shearing)
    if (_isFetchingMachine) {
      return;
    }

    if (machineOption.isEmpty) {
      showAlertDialog(
        context: context,
        title: 'Mesin Tidak Tersedia',
        message:
            'Saat ini tidak ada mesin yang tersedia atau seluruh mesin sedang dipakai.',
      );
      return;
    }

<<<<<<< HEAD
=======
>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> d0509dba (fix: mulai warping - shearing)
    showSelectDialog(
      context: context,
      title: 'Mesin',
      isFetching: _isFetchingMachine,
      option: machineOption,
      handleChangeValue: (selected) {
        setState(() {
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d0509dba (fix: mulai warping - shearing)
          final machines = widget.form?['machines'] as List? ?? [];
          final isExist =
              machines.any((machine) => machine['value'] == selected['value']);

          if (!isExist) {
            machines.add({
              'value': selected['value'],
              'label': selected['label'],
            });
          }

          widget.form?['machines'] = machines;
<<<<<<< HEAD
        });
      },
      selected: '',
=======
          widget.form?['machine_id'] = selected['value'].toString();
          widget.form?['nama_mesin'] = selected['label'].toString();
        });
      },
      selected: widget.form?['machine_id']?.toString() ?? '',
>>>>>>> a1ea7df (feat: warping)
=======
        });
      },
      selected: '',
>>>>>>> d0509dba (fix: mulai warping - shearing)
    );
  }

  @override
  void dispose() {
    widget.form?.clear();
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 6aaef7aa (fix: create warping)
    _noteController.dispose();
    _yarnQtyController.dispose();
    _beamQtyController.dispose();
    _sectionController.dispose();
<<<<<<< HEAD
=======
    _maklonNameController.dispose();
<<<<<<< HEAD
>>>>>>> a1ea7df (feat: warping)
=======
    _noteController.dispose();
    _yarnQtyController.dispose();
>>>>>>> 1e3750ac (fix: create process)
=======
>>>>>>> 6aaef7aa (fix: create warping)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GreigeTabSection(
      id: widget.id,
      title: widget.title,
<<<<<<< HEAD
<<<<<<< HEAD
=======
      maklonName: _maklonNameController,
      isMaklon: widget.isMaklon,
>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> 6aaef7aa (fix: create warping)
      form: widget.form,
      label: widget.label,
      formKey: _formKey,
      greigeOrderData: widget.data != null && widget.data!.isNotEmpty
          ? widget.data!
          : greigeOrderData,
      processData: data,
<<<<<<< HEAD
<<<<<<< HEAD
=======
      withMaklonOrMachine: widget.withMaklonOrMachine,
      withNoMaklonOrMachine: widget.withNoMaklonOrMachine,
      withOnlyMaklon: widget.withOnlyMaklon,
>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> 6aaef7aa (fix: create warping)
      handleSubmit: widget.handleSubmit,
      firstLoading: _firstLoading,
      isSubmitting: _isSubmitting,
      selectMachine: _selectMachine,
      selectGreigeOrder: _selectGreigeOrder,
      spkDocuments: spkDocuments,
      handleChangeInput: _handleChangeInput,
      note: _noteController,
<<<<<<< HEAD
<<<<<<< HEAD
      yarnQty: _yarnQtyController,
      beamQty: _beamQtyController,
      section: _sectionController,
<<<<<<< HEAD
=======
>>>>>>> a1ea7df (feat: warping)
=======
      yarnQty: _yarnQtyController,
>>>>>>> 1e3750ac (fix: create process)
=======
>>>>>>> 6aaef7aa (fix: create warping)
    );
  }
}
