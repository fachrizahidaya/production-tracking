// ignore_for_file: file_names, use_build_context_synchronously, unused_field, prefer_final_fields

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/process/dyeing.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/screens/master/process_detail.dart';

class DyeingDetail extends StatefulWidget {
  final String id;
  final String no;
  final canDelete;
  final canUpdate;

  const DyeingDetail(
      {super.key,
      required this.id,
      required this.no,
      this.canDelete,
      this.canUpdate});

  @override
  State<DyeingDetail> createState() => _DyeingDetailState();
}

class _DyeingDetailState extends State<DyeingDetail> {
  final DyeingService _dyeingService = DyeingService();

  bool _firstLoading = true;
  final List<dynamic> _dataList = [];
  final ValueNotifier<bool> _processLoading = ValueNotifier(false);
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  bool _isFetchingMachine = false;
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);
  bool _isFetchingUnit = false;

  late List<dynamic> unitOption = [];
  late List<dynamic> machineOption = [];

  Map<String, dynamic> data = {};

  final Map<String, dynamic> _form = {
    'wo_id': null,
    'machine_id': null,
    'length_unit_id': null,
    'width_unit_id': null,
    'unit_id': null,
    'rework_reference_id': null,
    'start_by_id': null,
    'end_by_id': null,
    'qty': null,
    'width': null,
    'length': null,
    'notes': null,
    'rework': null,
    'status': null,
    'start_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'end_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'attachments': [],
    'no_wo': '',
    'no_dyeing': '',
    'nama_mesin': '',
    'nama_satuan': '',
    'nama_satuan_panjang': '',
    'nama_satuan_lebar': '',
  };

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
        _isFetchingMachine = false;
      });
    }
  }

  Future<void> _getDataView() async {
    setState(() {
      _firstLoading = true;
    });

    await _dyeingService.getDataView(widget.id);

    setState(() {
      data = _dyeingService.dataView;
      if (data['qty'] != null) {
        _qtyController.text = data['qty'].toString();
        _form['qty'] = data['qty'];
      }
      if (data['length'] != null) {
        _lengthController.text = data['length'].toString();
        _form['length'] = data['length'];
      }
      if (data['width'] != null) {
        _widthController.text = data['width'].toString();
        _form['width'] = data['width'];
      }
      if (data['notes'] != null) {
        _noteController.text = data['notes'].toString();
        _form['notes'] = data['notes'];
      }
      if (data['unit'] != null) {
        _form['unit_id'] = data['unit']['id'].toString();
        _form['nama_satuan'] = data['unit']['name'].toString();
      }
      if (data['width_unit'] != null) {
        _form['width_unit_id'] = data['width_unit']['id'].toString();
        _form['nama_satuan_lebar'] = data['width_unit']['name'].toString();
      }
      if (data['length_unit'] != null) {
        _form['length_unit_id'] = data['length_unit']['id'].toString();
        _form['nama_satuan_panjang'] = data['length_unit']['name'].toString();
      }
      if (data['machine'] != null) {
        _form['machine_id'] = data['machine']['id'].toString();
        _form['nama_mesin'] = data['machine']['name'].toString();
      }
      if (data['attachments'] != null) {
        _form['attachments'] = List.from(data['attachments']);
      }

      _firstLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _qtyController.text = _form['qty']?.toString() ?? '';
    _lengthController.text = _form['length']?.toString() ?? '';
    _widthController.text = _form['width']?.toString() ?? '';
    _noteController.text = _form['notes']?.toString() ?? '';
    _getDataView();
    _handleFetchUnit();
    _handleFetchMachine();
  }

  @override
  Widget build(BuildContext context) {
    return ProcessDetail<Dyeing>(
      id: widget.id,
      no: widget.no,
      label: 'Dyeing',
      service: Provider.of<DyeingService>(context, listen: false),
      handleUpdateService: (context, id, item, isLoading) =>
          Provider.of<DyeingService>(context, listen: false)
              .updateItem(id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<DyeingService>(context, listen: false)
              .deleteItem(id, isLoading),
      modelBuilder: (form, data) => Dyeing(
        wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
        unit_id: form['unit_id'] != null
            ? int.tryParse(form['unit_id'].toString())
            : 1,
        length_unit_id: form['length_unit_id'] != null
            ? int.tryParse(form['length_unit_id'].toString())
            : 1,
        width_unit_id: form['width_unit_id'] != null
            ? int.tryParse(form['width_unit_id'].toString())
            : 1,
        machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
        qty: form['qty'] ?? '0',
        width: form['width'] ?? '0',
        length: form['length'] ?? '0',
        notes: form['notes'] ?? data['notes'],
        attachments: [
          ...List<Map<String, dynamic>>.from(data['attachments'] ?? []),
          ...List<Map<String, dynamic>>.from(form['attachments'] ?? []),
        ],
      ),
      canDelete: widget.canDelete,
      canUpdate: widget.canUpdate,
      route: '/dyeings',
      withItemGrade: false,
      withQtyAndWeight: false,
      withMaklon: false,
      forDyeing: true,
    );
  }
}
