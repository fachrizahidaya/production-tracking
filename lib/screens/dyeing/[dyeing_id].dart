// ignore_for_file: file_names, use_build_context_synchronously, unused_field, prefer_final_fields

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/detail/info_tab.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/process/dyeing.dart';
import 'package:provider/provider.dart';

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

  bool _isLoadMore = true;
  bool _hasMore = true;
  String _search = '';
  int page = 0;
  Map<String, String> params = {'search': '', 'page': '0'};

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

  void _handleChangeInput(fieldName, value) {
    setState(() {
      _form[fieldName] = value;
    });
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

  Future<void> _refetch() async {
    // Future.delayed(Duration.zero, () {
    //   setState(() {
    //     params = {'search': _search, 'page': '0'};
    //   });
    //   _loadMore();
    // });
    setState(() {
      _firstLoading = true;
    });

    await _dyeingService.getDataView(widget.id);

    setState(() {
      data = _dyeingService.dataView;
      _firstLoading = false;
    });
  }

  Future<void> _handleUpdate(id) async {
    try {
      final dyeing = Dyeing(
        wo_id: _form['wo_id'] != null
            ? int.tryParse(_form['wo_id'].toString())
            : data['wo_id'],
        unit_id: _form['unit_id'] != null
            ? int.tryParse(_form['unit_id'].toString())
            : 1,
        length_unit_id: _form['length_unit_id'] != null
            ? int.tryParse(_form['length_unit_id'].toString())
            : data['length_unit_id'],
        width_unit_id: _form['width_unit_id'] != null
            ? int.tryParse(_form['width_unit_id'].toString())
            : data['width_unit_id'],
        machine_id: _form['machine_id'] != null
            ? int.tryParse(_form['machine_id'].toString())
            : data['machine_id'],
        rework_reference_id: _form['rework_reference_id'] != null
            ? int.tryParse(_form['rework_reference_id'].toString())
            : data['rework_reference_id'],
        qty: _form['qty'] ?? '0',
        width: _form['width'] ?? '0',
        length: _form['length'] ?? data['length'],
        notes: _form['notes'] ?? data['notes'],
        rework: _form['rework'] ?? data['rework'],
        status: _form['status'] ?? data['status'],
        start_time: _form['start_time'] ?? data['start_time'],
        end_time: _form['end_time'] ?? data['end_time'],
        start_by_id: _form['start_by_id'] ?? data['start_by_id'],
        end_by_id: _form['end_by_id'] != null
            ? int.tryParse(_form['end_by_id'].toString())
            : data['end_by_id'],
        attachments: [
          ...List<Map<String, dynamic>>.from(data['attachments'] ?? []),
          ...List<Map<String, dynamic>>.from(_form['attachments'] ?? []),
        ],
      );

      final message = await Provider.of<DyeingService>(context, listen: false)
          .updateItem(id, dyeing, _isLoading);

      showAlertDialog(
          context: context, title: 'Dyeing Updated', message: message);

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dyeings',
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _handleDelete(id) async {
    try {
      showConfirmationDialog(
          context: context,
          onConfirm: () async {
            try {
              final message =
                  await Provider.of<DyeingService>(context, listen: false)
                      .deleteItem(id, _processLoading);
              showAlertDialog(
                  context: context, title: 'Dyeing Deleted', message: message);

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/dyeings',
                (Route<dynamic> route) => false,
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${e.toString()}")),
              );
            }
          },
          title: 'Hapus Dyeing',
          message: 'Anda yakin ingin menghapus Dyeing ${data['dyeing_no']}',
          isLoading: _processLoading,
          buttonBackground: CustomTheme().buttonColor('danger'));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
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
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SelectDialog(
          label: 'Satuan',
          options: unitOption,
          selected: _form['unit_id'].toString(),
          handleChangeValue: (e) {
            setState(() {
              _form['unit_id'] = e['value'].toString();
              _form['nama_satuan'] = e['label'].toString();
            });
          },
        );
      },
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFf9fafc),
        appBar: CustomAppBar(
          title: 'Detail Proses Dyeing',
          onReturn: () {
            Navigator.pop(context);
          },
          canDelete: widget.canDelete,
          canUpdate: widget.canUpdate,
          handleDelete: _handleDelete,
          id: data['id'],
          status: data['can_delete'],
        ),
        body: Column(
          children: [
            Expanded(
              child: InfoTab(
                  data: data,
                  isLoading: _firstLoading,
                  handleChangeInput: _handleChangeInput,
                  qty: _qtyController,
                  length: _lengthController,
                  form: _form,
                  width: _widthController,
                  note: _noteController,
                  handleSelectUnit: _selectUnit,
                  handleSelectMachine: _selectMachine,
                  handleUpdate: _handleUpdate,
                  hasMore: _hasMore,
                  refetch: _refetch,
                  handleSelectLengthUnit: _selectLengthUnit,
                  handleSelectWidthUnit: _selectWidthUnit,
                  label: 'Dyeing'),
            )
          ],
        ),
        bottomNavigationBar: data['can_update'] != true
            ? null
            : SafeArea(
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
                            label: 'Simpan',
                            isLoading: isSubmitting,
                            onPressed: () async {
                              _isSubmitting.value = true;
                              try {
                                await _handleUpdate(data['id'].toString());
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
    );
  }
}
