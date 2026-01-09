// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/dyeing/rework/info_tab.dart';
import 'package:textile_tracking/components/dyeing/rework/item_tab.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/models/process/dyeing.dart';

class ReworkDyeingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final handleChangeInput;

  const ReworkDyeingManual(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.handleChangeInput});

  @override
  State<ReworkDyeingManual> createState() => _ReworkDyeingManualState();
}

class _ReworkDyeingManualState extends State<ReworkDyeingManual> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final WorkOrderService _workOrderService = WorkOrderService();
  final DyeingService _dyeingService = DyeingService();
  bool _firstLoading = false;
  bool _isFetchingMachine = false;
  bool _isFetchingWorkOrder = false;
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();

  late List<dynamic> workOrderOption = [];
  late List<dynamic> machineOption = [];
  late List<dynamic> unitOption = [];

  Map<String, dynamic> woData = {};
  Map<String, dynamic> dyeingData = {};

  var dyeingId = '';

  @override
  void initState() {
    _handleFetchWorkOrder();
    _handleFetchUnit();
    _handleFetchMachine();

    _qtyController.text = widget.form?['qty']?.toString() ?? '';
    _lengthController.text = widget.form?['length']?.toString() ?? '';
    _widthController.text = widget.form?['width']?.toString() ?? '';
    _noteController.text = widget.form?['notes']?.toString() ?? '';

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
          .fetchReworkOptions();
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
        _isFetchingMachine = false;
      });
    }
  }

  Future<void> _handleFetchUnit() async {
    await Provider.of<OptionUnitService>(context, listen: false)
        .getDataListOption();
    final result =
        Provider.of<OptionUnitService>(context, listen: false).dataListOption;

    setState(() {
      unitOption = result;
    });
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
        _isFetchingWorkOrder = false;
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

  Future<void> _getDyeingView(id) async {
    await _dyeingService.getDataView(id);

    setState(() {
      dyeingData = _dyeingService.dataView;

      if (dyeingData['length'] != null) {
        _lengthController.text = dyeingData['length'].toString();
        widget.form?['length'] = dyeingData['length'];
      }
      if (dyeingData['width'] != null) {
        _widthController.text = dyeingData['width'].toString();
        widget.form?['width'] = dyeingData['width'];
      }
      if (dyeingData['qty'] != null) {
        _qtyController.text = dyeingData['qty'].toString();
        widget.form?['qty'] = dyeingData['qty'];
      }
      if (dyeingData['notes'] != null) {
        _noteController.text = dyeingData['notes'].toString();
        widget.form?['notes'] = dyeingData['notes'];
      }
      if (dyeingData['machine'] != null) {
        widget.form?['machine_id'] = dyeingData['machine']['id'].toString();
        widget.form?['nama_mesin'] = dyeingData['machine']['name'].toString();
      }
      if (dyeingData['unit'] != null) {
        widget.form?['unit_id'] = dyeingData['unit']['id'].toString();
        widget.form?['nama_satuan'] = dyeingData['unit']['name'].toString();
      }
      if (dyeingData['attachments'] != null) {
        widget.form?['attachments'] = List.from(dyeingData['attachments']);
      }
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
              dyeingId = e['dyeing_id'].toString();
            });

            _getDataView(e['value'].toString());
            _getDyeingView(e['dyeing_id'].toString());
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
            title: 'Rework Dyeing',
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
                    text: 'Material',
                  ),
                ]),
              ),
              Expanded(
                child: TabBarView(children: [
                  InfoTab(
                    data: woData,
                    id: widget.id,
                    label: 'Dyeing',
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
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: CustomTheme().padding('card'),
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
                        label: 'Simpan',
                        isLoading: isSubmitting,
                        onPressed: () async {
                          _isSubmitting.value = true;
                          try {
                            await widget
                                .handleSubmit(dyeingData['id'].toString());
                          } finally {
                            _isSubmitting.value = false;
                          }
                        },
                      ))
                    ].separatedBy(CustomTheme().hGap('xl')),
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
