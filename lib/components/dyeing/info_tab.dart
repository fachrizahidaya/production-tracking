import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/layout/custom_card.dart';
import 'package:production_tracking/components/master/text/no_data.dart';
import 'package:production_tracking/components/master/text/view_text.dart';
import 'package:production_tracking/helpers/util/padding_column.dart';
import 'package:production_tracking/helpers/util/separated_column.dart';
import 'package:production_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class InfoTab extends StatefulWidget {
  final data;
  final isLoading;

  const InfoTab({super.key, this.data, this.isLoading});

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  @override
  Widget build(BuildContext context) {
    return widget.data.isNotEmpty
        ? Container(
            color: const Color(0xFFEBEBEB),
            padding: PaddingColumn.screen,
            child: widget.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomCard(
                    child: Container(
                        padding: PaddingColumn.screen,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ViewText(
                                      viewLabel: 'Nomor',
                                      viewValue: widget.data['dyeing_no']
                                              ?.toString() ??
                                          '-',
                                    ),
                                    ViewText<Map<String, dynamic>>(
                                      viewLabel: 'Work Order',
                                      viewValue: widget.data['work_orders']
                                                  ?['wo_no']
                                              ?.toString() ??
                                          '-',
                                      item: widget.data['work_orders'],
                                      onItemTap: (context, workOrder) {
                                        if (workOrder?['id'] != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WorkOrderDetail(
                                                id: workOrder['id'].toString(),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    ViewText(
                                      viewLabel: 'Tanggal',
                                      viewValue: widget.data['start_time'] !=
                                              null
                                          ? DateFormat("dd MMM yyyy").format(
                                              DateTime.parse(
                                                  widget.data['start_time']))
                                          : '-',
                                    ),
                                    ViewText(
                                      viewLabel: 'Rework',
                                      viewValue: widget.data['rework'] == true
                                          ? 'Yes'
                                          : 'No',
                                    ),
                                    ViewText(
                                      viewLabel: 'Mesin',
                                      viewValue:
                                          '${widget.data['machine']?['code'] ?? ''} - ${widget.data['machine']?['name'] ?? ''}',
                                    ),
                                    ViewText(
                                      viewLabel: 'Mulai',
                                      viewValue: widget.data['start_time'] !=
                                              null
                                          ? '${DateFormat("HH:mm").format(DateTime.parse(widget.data['start_time']))} by ${widget.data['start_by']?['name'] ?? '-'}'
                                          : '-',
                                    ),
                                    ViewText(
                                      viewLabel: 'Selesai',
                                      viewValue: widget.data['end_time'] != null
                                          ? '${DateFormat("HH:mm").format(DateTime.parse(widget.data['end_time']))} by ${widget.data['end_by']?['name'] ?? '-'}'
                                          : '-',
                                    ),
                                  ].separatedBy(SizedBox(
                                    height: 16,
                                  )),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ViewText(
                                      viewLabel: 'Jumlah',
                                      viewValue: widget.data['qty'] != null
                                          ? NumberFormat("#,###").format(
                                              int.tryParse(widget.data['qty']
                                                      .toString()) ??
                                                  0)
                                          : '-',
                                    ),
                                    ViewText(
                                        viewLabel: 'Panjang',
                                        viewValue:
                                            '${NumberFormat("#,###").format(int.parse(widget.data['length'].toString()))} ${widget.data['unit']['code']}'),
                                    ViewText(
                                        viewLabel: 'Lebar',
                                        viewValue:
                                            '${NumberFormat("#,###").format(int.parse(widget.data['width']))} ${widget.data['unit']['code']}'),
                                    ViewText(
                                        viewLabel: 'Catatan',
                                        viewValue: widget.data['notes']),
                                    ViewText(
                                        viewLabel: 'Status',
                                        viewValue: widget.data['status']),
                                  ].separatedBy(SizedBox(
                                    height: 16,
                                  )),
                                ),
                              ].separatedBy(SizedBox(
                                width: 80,
                              )),
                            ),
                          ],
                        ))),
          )
        : Container(
            color: const Color(0xFFEBEBEB),
            alignment: Alignment.center,
            child: NoData());
  }
}
