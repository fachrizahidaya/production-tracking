// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/layout/custom_app_bar.dart';
import 'package:production_tracking/components/work-order/attachment_tab.dart';
import 'package:production_tracking/components/work-order/info_tab.dart';
import 'package:production_tracking/components/work-order/item_tab.dart';
import 'package:production_tracking/models/master/spk.dart';
import 'package:production_tracking/models/master/work_order.dart';
import 'package:production_tracking/models/option/option_spk.dart';
import 'package:provider/provider.dart';

class WorkOrderDetail extends StatefulWidget {
  final String id;

  const WorkOrderDetail({
    super.key,
    required this.id,
  });

  @override
  State<WorkOrderDetail> createState() => _WorkOrderDetailState();
}

class _WorkOrderDetailState extends State<WorkOrderDetail> {
  String _searchQuery = '';
  final WorkOrderService _workOrderService = WorkOrderService();
  final SpkService _spkService = SpkService();
  final OptionSpkService _optionSpkService = OptionSpkService();
  bool _isFiltered = false;
  bool avaiableCreate = false;
  bool _firstLoading = true;
  final List<dynamic> _dataList = [];

  bool _isLoadMore = true;
  bool _hasMore = true;
  String _search = '';
  int page = 0;
  Map<String, String> params = {'search': '', 'page': '0'};

  Map<String, dynamic> data = {};

  String _getSpkLabel(int spkId) {
    final match = _optionSpkService.options.firstWhere(
      (opt) => opt.value == spkId,
      orElse: () => OptionSpk(value: -1, label: ''),
    );
    return match.label ?? '';
  }

  Future<void> _getDataView() async {
    await _workOrderService.getDataView(widget.id);

    setState(() {
      data = _workOrderService.dataView;
    });
  }

  void _handleChangeSearch(String value) {
    setState(() {
      _searchQuery = value;
    });
    _workOrderService.fetchItems(
        isInitialLoad: true, searchQuery: _searchQuery);
  }

  Future<void> _handleFilter(key, value) async {
    setState(() {
      params['page'] = '0';
      if (value.toString() != '') {
        params[key.toString()] = value.toString();
      } else {
        params.remove(key.toString());
      }
    });

    if (params['dari_tanggal'] == null &&
        params['sampai_tanggal'] == null &&
        params['pemasok_id'] == null &&
        params['status'] == null) {
      setState(() {
        _isFiltered = false;
      });
    } else {
      setState(() {
        _isFiltered = true;
      });
    }

    _loadMore();
  }

  Future<void> _submitFilter() async {
    Navigator.pop(context);
    _loadMore();
  }

  _refetch() {
    Future.delayed(Duration.zero, () {
      setState(() {
        params = {'search': _search, 'page': '0'};
      });
      _loadMore();
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
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getDataView();
    _optionSpkService.fetchOptions(isInitialLoad: true);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: CustomAppBar(
              title: 'Work Order Detail',
              onReturn: () {
                Navigator.pop(context);
              },
            ),
            body: Column(
              children: [
                TabBar(tabs: [
                  Tab(text: 'Informasi'),
                  Tab(text: 'Daftar Item'),
                  Tab(text: 'Attachments'),
                ]),
                Expanded(
                    child: TabBarView(children: [
                  InfoTab(
                    data: data,
                  ),
                  ItemTab(
                    data: data,
                    handleSpk: _getSpkLabel,
                  ),
                  AttachmentTab(
                    data: data,
                  )
                ]))
              ],
            )));
  }
}
