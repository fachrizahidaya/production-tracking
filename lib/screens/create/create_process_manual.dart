// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/process/create/tab_section.dart';
import 'package:textile_tracking/helpers/result/show_select_dialog.dart';
import 'package:textile_tracking/helpers/util/extract_semi_finished.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_item_semi_finished.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';

class CreateProcessManual extends StatefulWidget {
  final String title;
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final getWorkOrderOptions;
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

  const CreateProcessManual(
      {super.key,
      required this.title,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.getWorkOrderOptions,
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
      this.isMaklon});

  @override
  State<CreateProcessManual> createState() => _CreateProcessManualState();
}

class _CreateProcessManualState extends State<CreateProcessManual> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final WorkOrderService _workOrderService = WorkOrderService();
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);
  final TextEditingController _maklonNameController = TextEditingController();

  bool _firstLoading = false;
  bool _isFetchingWorkOrder = false;
  bool _isFetchingMachine = false;
  List<dynamic> workOrderOption = [];
  List<dynamic> machineOption = [];

  Map<String, dynamic> data = {};
  Map<String, dynamic> woData = {};

  var processId = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWorkOrder();
      _fetchMachine();

      if (widget.processId != null) {
        _getProcessView(widget.processId);
      }
    });
  }

  Future<void> _fetchWorkOrder() async {
    setState(() {
      _isFetchingWorkOrder = true;
    });

    final service = Provider.of<OptionWorkOrderService>(context, listen: false);

    try {
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    } finally {
      setState(() {
        _isFetchingWorkOrder = false;
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

  Future<void> _getDataView(id) async {
    setState(() {
      _firstLoading = true;
    });

    await _workOrderService.getDataView(id);

    setState(() {
      woData = _workOrderService.dataView;
      _firstLoading = false;
    });
  }

  Future<void> _getProcessView(id) async {
    await widget.processService.getDataView(context, id);

    setState(() {
      data = widget.processService.dataView;
    });
  }

  void _selectWorkOrder() {
    if (_isFetchingWorkOrder) {
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
          label: 'Work Order',
          options: workOrderOption,
          selected: widget.form?['wo_id']?.toString() ?? '',
          handleChangeValue: (selected) async {
            final semiFinishedService =
                Provider.of<OptionItemSemiFinishedService>(
              context,
              listen: false,
            );

            final woId = selected['value']?.toString();
            final processValue = selected[widget.idProcess];

            setState(() {
              widget.form?['wo_id'] = woId;
              widget.form?['no_wo'] = selected['label']?.toString();
            });

            if (woId != null && woId.isNotEmpty) {
              await _getDataView(woId);

              final params = extractSemiFinishedParams(
                woData['items'] ?? [],
              );

              await semiFinishedService.fetchOptions(
                isInitialLoad: true,
                process: widget.label
                    .toString()
                    .trim()
                    .toLowerCase()
                    .replaceAll(' ', '_'),
                baseCodes: params['base_codes'] ?? [],
                colorCodes: params['color_codes'] ?? [],
              );

              final semiFinishedItems = semiFinishedService.dataListOption;

              final woItems = woData['items'] ?? [];

              if (widget.label == 'Dyeing') {
                final baseCodes = params['base_codes'] ?? [];
                final colorCodes = params['color_codes'] ?? [];

                final List<Map<String, dynamic>> items = [];

                for (int i = 0; i < baseCodes.length; i++) {
                  final baseCode = baseCodes[i].toString();
                  final colorCode =
                      i < colorCodes.length ? colorCodes[i].toString() : '';

                  dynamic semiFinishedId;

                  for (final sf in semiFinishedItems) {
                    final sfCode = sf['code']?.toString() ?? '';

                    final sfParts = sfCode.split('-');

                    final sfBaseCode = sfParts.isNotEmpty ? sfParts.first : '';
                    final sfColorCode = sfParts.isNotEmpty ? sfParts.last : '';

                    if (sfBaseCode == baseCode && sfColorCode == colorCode) {
                      semiFinishedId = sf['value'];
                      break;
                    }
                  }

                  items.add({
                    'item_id': semiFinishedId,
                  });
                }

                widget.form?['semifinished_products'] = items;
              } else {
                final baseCodes = params['base_codes'] ?? [];
                final colorCodes = params['color_codes'] ?? [];

                final List<Map<String, dynamic>> items = [];

                for (int i = 0; i < baseCodes.length; i++) {
                  final baseCode = baseCodes[i].toString();
                  final colorCode =
                      i < colorCodes.length ? colorCodes[i].toString() : '';

                  dynamic semiFinishedId;

                  for (final sf in semiFinishedItems) {
                    final sfCode = sf['code']?.toString() ?? '';

                    final sfParts = sfCode.split('-');

                    final sfBaseCode = sfParts.isNotEmpty ? sfParts.first : '';
                    final sfColorCode = sfParts.isNotEmpty ? sfParts.last : '';

                    if (sfBaseCode == baseCode && sfColorCode == colorCode) {
                      semiFinishedId = sf['value'];
                      break;
                    }
                  }

                  items.add({
                    'semifinished_product_id': semiFinishedId,
                  });
                }

                widget.form?['items'] = items;
              }
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
    if (widget.label == 'Long Hemming' ||
        widget.label == 'Cross Cutting' ||
        widget.label == 'Sewing') {
      showSelectDialog(
        context: context,
        title: 'Mesin',
        isFetching: _isFetchingMachine,
        option: machineOption,
        handleChangeValue: (selected) {
          setState(() {
            final machines = widget.form?['machines'] as List? ?? [];

            final isExist =
                machines.any((e) => e['value'] == selected['value']);

            if (!isExist) {
              machines.add({
                'value': selected['value'],
                'label': selected['label'],
              });
            }

            widget.form?['machines'] = machines;
          });
        },
        selected: '',
      );
    } else {
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
  }

  @override
  void dispose() {
    widget.form?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabSection(
      id: widget.id,
      title: widget.title,
      maklonName: _maklonNameController,
      isMaklon: widget.isMaklon,
      form: widget.form,
      label: widget.label,
      formKey: _formKey,
      woData: widget.data != null && widget.data!.isNotEmpty
          ? widget.data!
          : woData,
      processData: data,
      withMaklonOrMachine: widget.withMaklonOrMachine,
      withNoMaklonOrMachine: widget.withNoMaklonOrMachine,
      withOnlyMaklon: widget.withOnlyMaklon,
      handleSubmit: widget.handleSubmit,
      firstLoading: _firstLoading,
      isSubmitting: _isSubmitting,
      selectMachine: _selectMachine,
      selectWorkOrder: _selectWorkOrder,
    );
  }
}
