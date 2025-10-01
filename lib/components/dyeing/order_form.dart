import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/helpers/util/margin_search.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';

class OrderForm extends StatefulWidget {
  final id;
  final Map<String, dynamic>? data;

  const OrderForm({super.key, this.id, this.data});

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  late List<dynamic> workOrderOption = [];
  late List<dynamic> machineOption = [];

  Map<String, dynamic> data = {};

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

  _selectWorkOrder() {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SelectDialog(
          label: 'Work Order',
          options: workOrderOption,
          selected: _form['wo_id'].toString(),
          handleChangeValue: (e) {
            setState(() {
              _form['wo_id'] = e['value'].toString();
              _form['no_wo'] = e['label'].toString();
            });
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
          selected: _form['machine_id'].toString(),
          handleChangeValue: (e) {
            setState(() {
              _form['machine_id'] = e['value'].toString();
              _form['nama_mesin'] = e['label'].toString();
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.id != null && widget.data == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                      children: [
                        if (widget.id !=
                            null) // only show if QR scan / prefilled
                          Text("Work Order ID: ${widget.data?['id']}"),
                        SelectForm(
                            label: 'Work Order',
                            onTap: () => _selectWorkOrder(),
                            selectedLabel: _form['no_wo'] ?? '',
                            selectedValue: _form['wo_id']?.toString() ?? '',
                            required: false),
                        SelectForm(
                            label: 'Mesin',
                            onTap: () => _selectMachine(),
                            selectedLabel: _form['nama_mesin'] ?? '',
                            selectedValue:
                                _form['machine_id']?.toString() ?? '',
                            required: false),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Simpan"),
                        )
                      ].separatedBy(SizedBox(
                        height: 16,
                      )),
                    ),
                  ))),
        ));
  }
}
