// ignore_for_file: file_names, use_build_context_synchronously, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/components/work-order/tab/attachment_tab.dart';
import 'package:textile_tracking/components/work-order/tab/info_tab.dart';
import 'package:textile_tracking/components/work-order/tab/item_tab.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_spk.dart';

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
  final OptionSpkService _optionSpkService = OptionSpkService();
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
    _optionSpkService.fetchOptions(isInitialLoad: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFf9fafc),
        appBar: CustomAppBar(
          title: 'Work Order Detail',
          onReturn: () {
            Navigator.pop(context);
          },
        ),
        body: Column(
          children: [
            DefaultTabController(
                length: 3,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isPortrait = MediaQuery.of(context).orientation ==
                        Orientation.portrait;
                    final screenHeight = MediaQuery.of(context).size.height;

                    final boxHeight =
                        isPortrait ? screenHeight * 0.45 : screenHeight * 0.7;

                    return Column(
                      children: [
                        Container(
                          color: Colors.white,
                          child: TabBar(tabs: [
                            Tab(
                              text: 'Informasi',
                            ),
                            Tab(
                              text: 'Barang',
                            ),
                            Tab(
                              text: 'Lampiran',
                            )
                          ]),
                        ),
                        SizedBox(
                          height: boxHeight,
                          child: TabBarView(children: [
                            InfoTab(
                              data: data,
                              isLoading: _firstLoading,
                            ),
                            ItemTab(
                              data: data,
                            ),
                            AttachmentTab(
                              existingAttachment: data['attachments'] ?? [],
                            )
                          ]),
                        )
                      ],
                    );
                  },
                )),
          ],
        ));
  }
}
