// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/layout/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/layout/detail/detail.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/screens/master/update_process.dart';

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
  final route;
  final fetchMachine;
  final getMachineOptions;
  final withItemGrade;
  final withQtyAndWeight;
  final withMaklon;
  final onlySewing;
  final forDyeing;

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
      this.label,
      this.route,
      this.fetchMachine,
      this.getMachineOptions,
      this.withItemGrade,
      this.withQtyAndWeight,
      this.withMaklon,
      this.onlySewing,
      this.forDyeing});

  @override
  State<ProcessDetail<T>> createState() => _ProcessDetailState<T>();
}

class _ProcessDetailState<T> extends State<ProcessDetail<T>> {
  bool _firstLoading = true;
  bool _isFetchingMachine = false;
  bool _isFetchingUnit = false;
  final ValueNotifier<bool> _processLoading = ValueNotifier(false);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _maklonNameController = TextEditingController();
  final TextEditingController _qtyItemController = TextEditingController();
  List<TextEditingController> _qtyControllers = [];
  List<TextEditingController> _notesControllers = [];
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

  Map<String, dynamic> data = {};
  final Map<String, dynamic> _form = {
    'wo_id': null,
    'machine_id': null,
    'weight_unit_id': null,
    'length_unit_id': null,
    'width_unit_id': null,
    'item_unit_id': null,
    'unit_id': null,
    'item_qty': null,
    'qty': null,
    'weight': null,
    'width': null,
    'length': null,
    'notes': null,
    'attachments': [],
    'grades': [],
    'nama_mesin': '',
    'nama_satuan_panjang': '',
    'nama_satuan_lebar': '',
    'nama_satuan_berat': '',
    'nama_satuan': '',
    'start_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'end_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'maklon': false,
    'maklon_name': '',
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
    final grades = d['grades'] ?? [];
    _qtyControllers = List.generate(grades.length, (i) {
      return TextEditingController(
        text: grades[i]['qty']?.toString() ?? '',
      );
    });
    _notesControllers = List.generate(grades.length, (i) {
      return TextEditingController(
        text: grades[i]['notes']?.toString() ?? '',
      );
    });
    _qtyItemController.text = d['item_qty']?.toString() ?? '';
    _weightController.text = d['weight']?.toString() ?? '';
    _lengthController.text = d['length']?.toString() ?? '';
    _widthController.text = d['width']?.toString() ?? '';
    _noteController.text = d['notes']?.toString() ?? '';
    _maklonNameController.text = d['maklon_name']?.toString() ?? '';
    _form['item_qty'] = d['item_qty'];
    _form['weight'] = d['weight'];
    _form['length'] = d['length'];
    _form['width'] = d['width'];
    _form['maklon_name'] = d['maklon_name'];
    _form['maklon'] = d['maklon'];
    _form['notes'] = d['notes'];
    _form['attachments'] = List.from(d['attachments'] ?? []);
    _form['grades'] = List.from(d['grades'] ?? []);
    if (d['item_unit'] != null) {
      _form['item_unit_id'] = d['item_unit']['id'].toString();
      _form['nama_satuan'] = d['item_unit']['name'].toString();
    }
    if (d['weight_unit'] != null) {
      _form['weight_unit_id'] = d['weight_unit']['id'].toString();
      _form['nama_satuan_berat'] = d['weight_unit']['name'].toString();
    }
    if (d['length_unit'] != null) {
      _form['length_unit_id'] = d['length_unit']['id'].toString();
      _form['nama_satuan_panjang'] = d['length_unit']['name'].toString();
    }
    if (d['width_unit'] != null) {
      _form['width_unit_id'] = d['width_unit']['id'].toString();
      _form['nama_satuan_lebar'] = d['width_unit']['name'].toString();
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

      showAlertDialog(
          context: context, title: 'Dyeing Updated', message: message);
      Navigator.pushNamedAndRemoveUntil(context, widget.route, (_) => false);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _handleNavigateToUpdate() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProcess(
          id: widget.id,
          label: widget.label,
          form: _form,
          data: data,
          handleUpdate: _handleUpdate,
          handleSelectMachine: _selectMachine,
          withMaklon: widget.withMaklon,
          maklon: _maklonNameController,
          qtyItem: _qtyItemController,
          handleChangeInput: _handleChangeInput,
          withQtyAndWeight: widget.withQtyAndWeight,
          handleSelectQtyItemUnit: _selectQtyItemUnit,
          length: _lengthController,
          width: _widthController,
          weight: _weightController,
          handleSelectUnit: _selectUnit,
          handleSelectWidthUnit: _selectWidthUnit,
          handleSelectLengthUnit: _selectLengthUnit,
          isSubmitting: _isSubmitting,
        ),
      ),
    );
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

          showAlertDialog(
              context: context, title: 'Dyeing Deleted', message: message);
          Navigator.pushNamedAndRemoveUntil(
              context, widget.route, (_) => false);
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      },
    );
  }

  Future<void> _handleFetchUnit() async {
    setState(() {
      _isFetchingUnit = true;
    });

    try {
      await Provider.of<OptionUnitService>(context, listen: false)
          .getDataListOption();
      setState(() {
        unitOption = Provider.of<OptionUnitService>(context, listen: false)
            .dataListOption;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    } finally {
      setState(() {
        _isFetchingUnit = false;
      });
    }
  }

  Future<void> _handleFetchMachine() async {
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

  _selectUnit() {
    if (_isFetchingUnit) {
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

  _selectLengthUnit() {
    if (_isFetchingUnit) {
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
          label: 'Satuan Panjang',
          options: unitOption,
          selected: _form['length_unit_id'].toString(),
          handleChangeValue: (e) {
            setState(() {
              _form['length_unit_id'] = e['value'].toString();
              _form['nama_satuan_panjang'] = e['label'].toString();
            });
          },
        );
      },
    );
  }

  _selectWidthUnit() {
    if (_isFetchingUnit) {
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
          label: 'Satuan Lebar',
          options: unitOption,
          selected: _form['width_unit_id'].toString(),
          handleChangeValue: (e) {
            setState(() {
              _form['width_unit_id'] = e['value'].toString();
              _form['nama_satuan_lebar'] = e['label'].toString();
            });
          },
        );
      },
    );
  }

  _selectQtyUnit(int index) {
    if (_isFetchingUnit) {
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
      builder: (_) => SelectDialog(
        label: 'Satuan',
        options: unitOption,
        // 👇 Preselect current unit for this grade
        selected: _form['grades'][index]['unit_id'].toString(),
        handleChangeValue: (e) {
          setState(() {
            _form['grades'][index]['unit_id'] = e['value'].toString();
            _form['grades'][index]['unit']['name'] = e['label'].toString();
          });
        },
      ),
    );
  }

  _selectQtyItemUnit() {
    if (_isFetchingUnit) {
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
      builder: (_) => SelectDialog(
        label: 'Satuan',
        options: unitOption,
        // 👇 Preselect current unit for this grade
        selected: _form['item_unit_id'].toString(),
        handleChangeValue: (e) {
          setState(() {
            _form['item_unit_id'] = e['value'].toString();
            _form['nama_satuan'] = e['label'].toString();
          });
        },
      ),
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
      builder: (_) => SelectDialog(
        label: 'Mesin',
        options: machineOption,
        selected: _form['machine_id'].toString(),
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFf9fafc),
        appBar: CustomAppBar(
          title: '${widget.label} Detail',
          onReturn: () => Navigator.pop(context),
          canDelete: widget.canDelete,
          canUpdate: widget.canUpdate,
          handleDelete: _handleDelete,
          handleUpdate: _handleNavigateToUpdate,
          id: data['id'],
          status: data['can_delete'],
        ),
        body: Detail(
          data: data,
          isLoading: _firstLoading,
          handleChangeInput: _handleChangeInput,
          weight: _weightController,
          length: _lengthController,
          width: _widthController,
          note: _noteController,
          form: _form,
          handleSelectLengthUnit: _selectLengthUnit,
          handleSelectWidthUnit: _selectWidthUnit,
          handleSelectQtyItemUnit: _selectQtyItemUnit,
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
          withItemGrade: widget.withItemGrade,
          qty: _qtyControllers,
          handleSelectQtyUnit: _selectQtyUnit,
          notes: _notesControllers,
          withQtyAndWeight: widget.withQtyAndWeight,
          qtyItem: _qtyItemController,
          withMaklon: widget.withMaklon,
          maklon: _maklonNameController,
          onlySewing: widget.onlySewing,
          label: widget.label,
          forDyeing: widget.forDyeing,
        ),
      ),
    );
  }
}
