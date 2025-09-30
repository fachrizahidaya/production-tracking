// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/attachment_tab.dart';
import 'package:textile_tracking/components/dyeing/info_tab.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/process/dyeing.dart';
import 'package:provider/provider.dart';

class DyeingDetail extends StatefulWidget {
  final String id;
  final String no;
  const DyeingDetail({super.key, required this.id, required this.no});

  @override
  State<DyeingDetail> createState() => _DyeingDetailState();
}

class _DyeingDetailState extends State<DyeingDetail> {
  final DyeingService _dyeingService = DyeingService();
  bool _firstLoading = true;
  final List<dynamic> _dataList = [];

  bool _isLoadMore = true;
  bool _hasMore = true;
  String _search = '';
  int page = 0;
  Map<String, String> params = {'search': '', 'page': '0'};

  Map<String, dynamic> data = {};

  Future<void> _getDataView() async {
    setState(() {
      _firstLoading = true;
    });

    await _dyeingService.getDataView(widget.id);

    setState(() {
      data = _dyeingService.dataView;
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

  @override
  void initState() {
    super.initState();
    _getDataView();
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
