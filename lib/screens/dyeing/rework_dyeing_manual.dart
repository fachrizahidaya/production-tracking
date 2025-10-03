import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/helpers/util/margin_search.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';

class ReworkDyeingManual extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;

  const ReworkDyeingManual(
      {super.key, this.id, this.data, this.form, this.handleSubmit});

  @override
  State<ReworkDyeingManual> createState() => _ReworkDyeingManualState();
}

class _ReworkDyeingManualState extends State<ReworkDyeingManual> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final WorkOrderService _workOrderService = WorkOrderService();

  late List<dynamic> workOrderOption = [];
  late List<dynamic> machineOption = [];

  Map<String, dynamic> data = {};

  @override
  void initState() {
    _handleFetchWorkOrder();
    _handleFetchMachine();

    if (widget.data != null) {
      data = widget.data!;
    }
    super.initState();
  }

  Future<void> _handleFetchWorkOrder() async {
    await Provider.of<OptionWorkOrderService>(context, listen: false)
        .fetchOptions();
    final result = Provider.of<OptionWorkOrderService>(context, listen: false)
        .dataListOption;

    setState(() {
      workOrderOption = result;
    });
  }

  Future<void> _handleFetchMachine() async {
    await Provider.of<OptionMachineService>(context, listen: false)
        .fetchOptions();
    final result = Provider.of<OptionMachineService>(context, listen: false)
        .dataListOption;

    setState(() {
      machineOption = result;
    });
  }

  Future<void> _getDataView(id) async {
    await _workOrderService.getDataView(id);

    setState(() {
      data = _workOrderService.dataView;
    });
  }

  _selectWorkOrder() {
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
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SelectDialog(
          label: 'Mesin',
          options: machineOption,
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
    return Scaffold(
        backgroundColor: const Color(0xFFEBEBEB),
        appBar: CustomAppBar(
          title: 'Create Dyeing',
          onReturn: () {
            Navigator.pop(context);
          },
        ),
        body: Container(
          padding: MarginSearch.screen,
          child: CustomCard(
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: PaddingColumn.screen,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // if (widget.id != null)
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     ViewText(
                        //         viewLabel: 'Nomor',
                        //         viewValue: widget.data?['wo_no'] ?? ''),
                        //     ViewText(
                        //         viewLabel: 'User',
                        //         viewValue:
                        //             widget.data?['user']?['name'] ?? ''),
                        //     ViewText(
                        //         viewLabel: 'Tanggal',
                        //         viewValue: widget.data?['wo_date'] != null
                        //             ? DateFormat("dd MMM yyyy").format(
                        //                 DateTime.parse(
                        //                     widget.data?['wo_date']))
                        //             : '-'),
                        //     ViewText(
                        //         viewLabel: 'Catatan',
                        //         viewValue: widget.data?['notes'] ?? ''),
                        //     ViewText(
                        //         viewLabel: 'Jumlah Greige',
                        //         viewValue: widget.data?['greige_qty'] !=
                        //                     null &&
                        //                 widget.data!['greige_qty']
                        //                     .toString()
                        //                     .isNotEmpty
                        //             ? '${NumberFormat("#,###.#").format(double.tryParse(widget.data!['greige_qty'].toString()) ?? 0)} ${widget.data!['greige_unit']?['code'] ?? ''}'
                        //             : '-'),
                        //     ViewText(
                        //         viewLabel: 'Status',
                        //         viewValue: widget.data?['status'] ?? '')
                        //   ].separatedBy(SizedBox(
                        //     height: 16,
                        //   )),
                        // ),
                        if (widget.id == null)
                          SelectForm(
                              label: 'Work Order',
                              onTap: () => _selectWorkOrder(),
                              selectedLabel: widget.form?['no_wo'] ?? '',
                              selectedValue:
                                  widget.form?['wo_id']?.toString() ?? '',
                              required: false),
                        if (widget.form?['wo_id'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ViewText(
                                  viewLabel: 'Nomor',
                                  viewValue: data['wo_no']?.toString() ?? ''),
                              ViewText(
                                  viewLabel: 'User',
                                  viewValue:
                                      data['user']?['name']?.toString() ?? ''),
                              ViewText(
                                  viewLabel: 'Tanggal',
                                  viewValue: data['wo_date'] != null
                                      ? DateFormat("dd MMM yyyy").format(
                                          DateTime.parse(data['wo_date']))
                                      : '-'),
                              ViewText(
                                  viewLabel: 'Catatan',
                                  viewValue: data['notes']?.toString() ?? ''),
                              ViewText(
                                  viewLabel: 'Jumlah Greige',
                                  viewValue: data['greige_qty'] != null &&
                                          data['greige_qty']
                                              .toString()
                                              .isNotEmpty
                                      ? '${NumberFormat("#,###.#").format(double.tryParse(data['greige_qty'].toString()) ?? 0)} ${data['greige_unit']?['code'] ?? ''}'
                                      : '-'),
                              ViewText(
                                  viewLabel: 'Status',
                                  viewValue: data['status']?.toString() ?? '')
                            ].separatedBy(SizedBox(height: 16)),
                          ),
                        SelectForm(
                            label: 'Mesin',
                            onTap: () => _selectMachine(),
                            selectedLabel: widget.form?['nama_mesin'] ?? '',
                            selectedValue:
                                widget.form?['machine_id']?.toString() ?? '',
                            required: false),
                        Align(
                          alignment: Alignment.center,
                          child: FormButton(
                            label: 'Simpan',
                            onPressed: () {
                              widget.handleSubmit();
                              // Navigator.pop(context);
                            },
                          ),
                        )
                      ].separatedBy(SizedBox(
                        height: 16,
                      )),
                    ),
                  ))),
        ));
  }
}
