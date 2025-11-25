// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/dyeing/create/info_tab.dart';
import 'package:textile_tracking/components/dyeing/create/item_tab.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';

class CreateDyeingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;

  const CreateDyeingManual(
      {super.key, this.id, this.data, this.form, this.handleSubmit});

  @override
  State<CreateDyeingManual> createState() => _CreateDyeingManualState();
}

class _CreateDyeingManualState extends State<CreateDyeingManual> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final WorkOrderService _workOrderService = WorkOrderService();
  bool _firstLoading = false;
  bool _isFetchingMachine = false;
  bool _isFetchingWorkOrder = false;
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

  late List<dynamic> workOrderOption = [];
  late List<dynamic> machineOption = [];

  Map<String, dynamic> woData = {};

  @override
  void initState() {
    _handleFetchWorkOrder();
    _handleFetchMachine();

    if (widget.data != null) {
      woData = widget.data!;
    }
    super.initState();
  }

  Future<void> _handleFetchWorkOrder() async {
    setState(() {
      _isFetchingWorkOrder = true;
    });

    try {
      await Provider.of<OptionWorkOrderService>(context, listen: false)
          .fetchOptions();
      final result = Provider.of<OptionWorkOrderService>(context, listen: false)
          .dataListOption;

      setState(() {
        workOrderOption = result;
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

  Future<void> _handleFetchMachine() async {
    setState(() {
      _isFetchingMachine = true;
    });

    try {
      await Provider.of<OptionMachineService>(context, listen: false)
          .fetchOptionsDyeing();
      final result = Provider.of<OptionMachineService>(context, listen: false)
          .dataListOption;

      setState(() {
        machineOption = result;
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

  _selectWorkOrder() {
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
          selected: widget.form?['wo_id'].toString() ?? '',
          handleChangeValue: (e) {
            setState(() {
              widget.form?['wo_id'] = e['value'].toString();
              widget.form?['no_wo'] = e['label'].toString();
            });

            _getDataView(e['value'].toString());
          },
        );
      },
    );
  }

  _selectMachine() {
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
          options: machineOption.toList(),
          selected: widget.form?['machine_id'].toString() ?? '',
          handleChangeValue: (e) {
            setState(() {
              widget.form?['machine_id'] = e['value'].toString();
              widget.form?['nama_mesin'] = e['label'].toString();
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    if (widget.form != null) {
      widget.form!.clear();
    }
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
              title: 'Mulai Dyeing',
              onReturn: () {
                Navigator.pop(context);
              },
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
                    InfoTab(
                      data: woData,
                      id: widget.id,
                      isLoading: _firstLoading,
                      form: widget.form,
                      formKey: _formKey,
                      handleSubmit: widget.handleSubmit,
                      handleSelectMachine: _selectMachine,
                      handleSelectWorkOrder: _selectWorkOrder,
                    ),
                    ItemTab(
                      data: woData,
                    ),
                  ]),
                )
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                color: Colors.white,
                padding: PaddingColumn.screen,
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
                          isDisabled: widget.form?['wo_id'] == null ||
                                  widget.form?['machine_id'] == null
                              ? true
                              : false,
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
            )),
      ),
    );
  }
}
