// ignore_for_file: file_names, use_build_context_synchronously, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/work-order/tab/wo_info_tab.dart';
import 'package:textile_tracking/components/work-order/tab/note_tab.dart';
import 'package:textile_tracking/components/work-order/tab/process_tab.dart';
import 'package:textile_tracking/models/master/work_order.dart';

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
  final WorkOrderService _workOrderService = WorkOrderService();
  bool _firstLoading = true;

  int page = 0;
  Map<String, String> params = {'search': '', 'page': '0'};

  Map<String, dynamic> data = {};

  Future<void> _getDataView() async {
    setState(() {
      _firstLoading = true;
    });

    await _workOrderService.getDataView(widget.id);

    setState(() {
      data = _workOrderService.dataView;
      _firstLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getDataView();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Color(0xFFf9fafc),
          appBar: CustomAppBar(
            title: 'Work Order Detail',
            onReturn: () {
              Navigator.pop(context);
            },
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TabBar(isScrollable: true, tabs: [
                    Tab(
                      text: 'Informasi',
                    ),
                    Tab(
                      text: 'Proses Produksi',
                    ),
                    Tab(
                      text: 'Catatan',
                    ),
                  ]),
                ),
                Expanded(
                  child: TabBarView(children: [
                    WoInfoTab(
                      data: data,
                      isLoading: _firstLoading,
                    ),
                    ProcessTab(
                      data: data,
                    ),
                    NoteTab(
                      data: data,
                    ),
                  ]),
                ),
              ],
            ),
          )),
    );
  }
}
