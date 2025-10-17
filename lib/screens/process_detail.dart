import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/components/master/layout/info_tab.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_unit.dart';

class ProcessDetail<T> extends StatefulWidget {
  final String id;
  final String no;
  final bool canDelete;
  final bool canUpdate;
  final dynamic service;
  final Future<String> Function(
    BuildContext context,
    String id,
    T item,
    ValueNotifier<bool> isLoading,
  ) handleUpdateService;
  final Future<String> Function(
    BuildContext context,
    String id,
    ValueNotifier<bool> isLoading,
  ) handleDeleteService;
  final T Function(Map<String, dynamic> form, Map<String, dynamic> data)
      modelBuilder;
  final label;

  const ProcessDetail(
      {super.key,
      required this.id,
      required this.no,
      required this.service,
      required this.handleUpdateService,
      required this.handleDeleteService,
      required this.modelBuilder,
      this.canDelete = false,
      this.canUpdate = false,
      this.label});

  @override
  State<ProcessDetail<T>> createState() => _ProcessDetailState<T>();
}

class _ProcessDetailState<T> extends State<ProcessDetail<T>> {
  bool _firstLoading = true;
  final ValueNotifier<bool> _processLoading = ValueNotifier(false);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  Map<String, dynamic> data = {};
  Map<String, dynamic> _form = {
    'wo_id': null,
    'machine_id': null,
    'weight_unit_id': null,
    'weight': null,
    'width': null,
    'length': null,
    'notes': null,
    'attachments': [],
    'nama_mesin': '',
    'nama_satuan_berat': '',
    'start_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'end_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
  };

  late List<dynamic> unitOption = [];
  late List<dynamic> machineOption = [];

  void _handleChangeInput(String fieldName, dynamic value) {
    setState(() {
      _form[fieldName] = value;
    });
  }

  Future<void> _getDataView() async {
    setState(() => _firstLoading = true);
    await widget.service.getDataView(widget.id);

    final fetched = widget.service.dataView;
    setState(() {
      data = fetched;
      _applyDataToControllers(fetched);
      _firstLoading = false;
    });
  }

  void _applyDataToControllers(Map<String, dynamic> d) {
    _weightController.text = d['weight']?.toString() ?? '';
    _lengthController.text = d['length']?.toString() ?? '';
    _widthController.text = d['width']?.toString() ?? '';
    _noteController.text = d['notes']?.toString() ?? '';
    _form['weight'] = d['weight'];
    _form['length'] = d['length'];
    _form['width'] = d['width'];
    _form['notes'] = d['notes'];
    _form['attachments'] = List.from(d['attachments'] ?? []);
    if (d['weight_unit'] != null) {
      _form['weight_unit_id'] = d['weight_unit']['id'].toString();
      _form['nama_satuan_berat'] = d['weight_unit']['name'].toString();
    }
    if (d['machine'] != null) {
      _form['machine_id'] = d['machine']['id'].toString();
      _form['nama_mesin'] = d['machine']['name'].toString();
    }
  }

  Future<void> _handleUpdate(String id) async {
    try {
      final item = widget.modelBuilder(_form, data);
      final message =
          await widget.handleUpdateService(context, id, item, _isLoading);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      Navigator.pushNamedAndRemoveUntil(
          context, '/press-tumblers', (_) => false);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _handleDelete(String id) async {
    showConfirmationDialog(
      context: context,
      title: 'Hapus Data',
      message: 'Yakin ingin menghapus data ini?',
      isLoading: _processLoading,
      buttonBackground: CustomTheme().buttonColor('danger'),
      onConfirm: () async {
        try {
          final message =
              await widget.handleDeleteService(context, id, _processLoading);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
          Navigator.pushNamedAndRemoveUntil(
              context, '/press-tumblers', (_) => false);
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      },
    );
  }

  Future<void> _handleFetchUnit() async {
    await Provider.of<OptionUnitService>(context, listen: false)
        .getDataListOption();
    setState(() {
      unitOption =
          Provider.of<OptionUnitService>(context, listen: false).dataListOption;
    });
  }

  Future<void> _handleFetchMachine() async {
    await Provider.of<OptionMachineService>(context, listen: false)
        .fetchOptions();
    setState(() {
      machineOption = Provider.of<OptionMachineService>(context, listen: false)
          .dataListOption;
    });
  }

  _selectUnit() {
    showDialog(
      context: context,
      builder: (_) => SelectDialog(
        label: 'Satuan',
        options: unitOption,
        selected: _form['weight_unit_id']?.toString(),
        handleChangeValue: (e) {
          setState(() {
            _form['weight_unit_id'] = e['value'].toString();
            _form['nama_satuan_berat'] = e['label'].toString();
          });
        },
      ),
    );
  }

  _selectMachine() {
    showDialog(
      context: context,
      builder: (_) => SelectDialog(
        label: 'Mesin',
        options: machineOption,
        selected: _form['machine_id']?.toString(),
        handleChangeValue: (e) {
          setState(() {
            _form['machine_id'] = e['value'].toString();
            _form['nama_mesin'] = e['label'].toString();
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getDataView();
    _handleFetchUnit();
    _handleFetchMachine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: '${widget.label} Detail',
          onReturn: () => Navigator.pop(context),
          canDelete: widget.canDelete,
          canUpdate: widget.canUpdate,
          handleDelete: _handleDelete,
          id: data['id'],
        ),
        body: Column(
          children: [
            Expanded(
              child: InfoTab(
                data: data,
                isLoading: _firstLoading,
                handleChangeInput: _handleChangeInput,
                weight: _weightController,
                length: _lengthController,
                width: _widthController,
                note: _noteController,
                form: _form,
                handleSelectUnit: _selectUnit,
                handleSelectMachine: _selectMachine,
                handleUpdate: _handleUpdate,
                refetch: _getDataView,
                fieldConfigs: [
                  {'name': 'weight', 'label': 'Berat'},
                  {'name': 'length', 'label': 'Panjang'},
                  {'name': 'width', 'label': 'Lebar'},
                  {'name': 'notes', 'label': 'Catatan'},
                ],
                fieldControllers: {
                  'weight': _weightController,
                  'length': _lengthController,
                  'width': _widthController,
                  'notes': _noteController,
                },
                no: widget.no,
              ),
            )
          ],
        ));
  }
}
