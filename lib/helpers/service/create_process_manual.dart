// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/components/master/layout/finish_info_tab.dart';
import 'package:textile_tracking/components/master/layout/finish_item_tab.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';

class CreateProcessManual extends StatefulWidget {
  final String title;
  final String? machineFilterValue;
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final fetchWorkOrder;
  final getWorkOrderOptions;
  final fetchMachine;
  final getMachineOptions;
  final maklon;
  final isMaklon;
  final withMaklonOrMachine;
  final withOnlyMaklon;
  final withNoMaklonOrMachine;

  const CreateProcessManual(
      {super.key,
      required this.title,
      this.machineFilterValue,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.fetchWorkOrder,
      this.getWorkOrderOptions,
      this.fetchMachine,
      this.getMachineOptions,
      this.maklon,
      this.isMaklon,
      this.withMaklonOrMachine,
      this.withOnlyMaklon,
      this.withNoMaklonOrMachine});

  @override
  State<CreateProcessManual> createState() => _CreateProcessManualState();
}

class _CreateProcessManualState extends State<CreateProcessManual> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final WorkOrderService _workOrderService = WorkOrderService();
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

  bool _firstLoading = false;
  bool _isFetchingWorkOrder = false;
  bool _isFetchingMachine = false;
  List<dynamic> workOrderOption = [];
  List<dynamic> machineOption = [];
  Map<String, dynamic> woData = {};

  @override
  void initState() {
    super.initState();
    _fetchWorkOrder();
    _fetchMachine();

    if (widget.data != null) {
      woData = widget.data!;
    }
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

      // await service.fetchOptionsPressTumbler();
      // var result = service.dataListOption;

      // if (widget.machineFilterValue != null &&
      //     widget.machineFilterValue!.isNotEmpty) {
      //   result = result.toList();
      // }

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

  Future<void> _getDataView(String id) async {
    setState(() {
      _firstLoading = true;
    });

    await _workOrderService.getDataView(id);

    setState(() {
      woData = _workOrderService.dataView;
      _firstLoading = false;
    });
  }

  void _selectWorkOrder() {
    if (_isFetchingWorkOrder) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
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
          handleChangeValue: (selected) {
            setState(() {
              widget.form?['wo_id'] = selected['value'].toString();
              widget.form?['no_wo'] = selected['label'].toString();
            });
            _getDataView(selected['value'].toString());
          },
        );
      },
    );
  }

  void _selectMachine() {
    if (_isFetchingMachine) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
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
          label: 'Mesin',
          options: machineOption,
          selected: widget.form?['machine_id']?.toString() ?? '',
          handleChangeValue: (selected) {
            setState(() {
              widget.form?['machine_id'] = selected['value'].toString();
              widget.form?['nama_mesin'] = selected['label'].toString();
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    widget.form?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
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
          body: Column(
            children: [
              Container(
                color: Colors.white,
                child: TabBar(tabs: [
                  Tab(
                    text: 'Form',
                  ),
                  Tab(
                    text: 'Barang',
                  ),
                ]),
              ),
              Expanded(
                child: TabBarView(children: [
                  FinishInfoTab(
                    data: woData,
                    id: widget.id,
                    isLoading: _firstLoading,
                    form: widget.form,
                    formKey: _formKey,
                    handleSubmit: widget.handleSubmit,
                    handleSelectMachine: _selectMachine,
                    handleSelectWorkOrder: _selectWorkOrder,
                    maklon: widget.maklon,
                    withMaklonOrMachine: widget.withMaklonOrMachine,
                    withOnlyMaklon: widget.withOnlyMaklon,
                    withNoMaklonOrMachine: widget.withNoMaklonOrMachine,
                  ),
                  FinishItemTab(data: woData),
                ]),
              )
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: PaddingColumn.screen,
              color: Colors.white,
              child: ValueListenableBuilder<bool>(
                valueListenable: _isSubmitting,
                builder: (context, isSubmitting, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: CancelButton(
                          label: 'Batal',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Expanded(
                          child: FormButton(
                        label: 'Mulai',
                        isLoading: isSubmitting,
                        isDisabled:
                            widget.form?['wo_id'] == null ? true : false,
                        onPressed: () async {
                          _isSubmitting.value = true;
                          try {
                            await widget.handleSubmit();
                          } finally {
                            _isSubmitting.value = false;
                          }
                        },
                      ))
                    ].separatedBy(SizedBox(
                      width: 16,
                    )),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
