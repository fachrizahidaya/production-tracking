// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/detail/attachment_tab.dart';
import 'package:textile_tracking/components/dyeing/detail/info_tab.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/models/master/work_order.dart';
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

  late List<dynamic> unitOption = [];

  bool _isLoadMore = true;
  bool _hasMore = true;
  String _search = '';
  int page = 0;
  Map<String, String> params = {'search': '', 'page': '0'};

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
      if (data['unit'] != null) {
        _form['unit_id'] = data['unit']['id'].toString();
        _form['nama_satuan'] = data['unit']['name'].toString();
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

  Future<void> _loadMore() async {
    _isLoadMore = true;

    if (params['page'] == '0') {
      setState(() {
        _dataList.clear();
        _firstLoading = true;
        _hasMore = true;
      });
    }

    String newPage = (int.parse(params['page']!) + 1).toString();
    setState(() {
      params['page'] = newPage;
    });

    await Provider.of<WorkOrderService>(context, listen: false)
        .getDataList(params);

    List<dynamic> loadData =
        Provider.of<WorkOrderService>(context, listen: false).dataList;

    if (loadData.isEmpty) {
      setState(() {
        _firstLoading = false;
        _isLoadMore = false;
        _hasMore = false;
      });
    } else {
      setState(() {
        _dataList.addAll(loadData);
        _firstLoading = false;
        _isLoadMore = false;

        if (loadData.length < 20) {
          _hasMore = false;
        }
      });
    }
  }

  Future<void> _handleUpdate(id) async {
    try {
      final dyeing = Dyeing(
          wo_id: data['wo_id'],
          unit_id: data['unit_id'],
          machine_id: data['machine_id'],
          rework_reference_id: data['rework_reference_id'],
          qty: (data['qty']),
          width: (data['width']),
          length: (data['length']),
          notes: data['notes'],
          rework: data['rework'],
          status: data['status'],
          start_time: data['start_time'],
          end_time: data['end_time'],
          start_by_id: data['start_by_id'],
          end_by_id: data['end_by_id'],
          attachments: data['attachments']);
      await Provider.of<DyeingService>(context, listen: false)
          .updateItem(id, dyeing, _isLoading);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data telah diubah")),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dyeings',
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      showAlertDialog(context: context, title: 'Error', message: e.toString());
    }
  }

  Future<void> _handleDelete(id) async {
    showConfirmationDialog(
        context: context,
        onConfirm: () async {
          try {
            await Provider.of<DyeingService>(context, listen: false)
                .deleteItem(id, _processLoading);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Dyeing berhasil dihapus")),
            );

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
        isLoading: _processLoading);
  }

  _selectUnit() {
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

  @override
  void initState() {
    super.initState();
    _qtyController.text = _form['qty']?.toString() ?? '';
    _lengthController.text = _form['length']?.toString() ?? '';
    _widthController.text = _form['width']?.toString() ?? '';
    _noteController.text = _form['notes']?.toString() ?? '';
    _getDataView();
    _handleFetchUnit();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Dyeing Detail',
            onReturn: () {
              Navigator.pop(context);
            },
            canDelete: widget.canDelete,
            canUpdate: widget.canUpdate,
            handleDelete: _handleDelete,
            id: data['id'],
          ),
          body: Column(
            children: [
              TabBar(tabs: [
                Tab(text: 'Informasi'),
                Tab(text: 'Attachments'),
              ]),
              Expanded(
                  child: TabBarView(children: [
                InfoTab(
                  data: data,
                  isLoading: _firstLoading,
                  handleChangeInput: _handleChangeInput,
                  qty: _qtyController,
                  length: _lengthController,
                  form: _form,
                  width: _widthController,
                  note: _noteController,
                  handleSelectUnit: _selectUnit,
                  handleUpdate: _handleUpdate,
                ),
                AttachmentTab(
                  data: data,
                  refetch: _refetch,
                  hasMore: _hasMore,
                )
              ]))
            ],
          ),
        ));
  }
}
