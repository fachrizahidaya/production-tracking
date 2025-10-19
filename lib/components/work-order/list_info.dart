import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/work-order/attachment_tab.dart';
import 'package:textile_tracking/components/work-order/item_tab.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ListInfo extends StatefulWidget {
  final data;
  final existingAttachment;

  const ListInfo({super.key, this.data, this.existingAttachment});

  @override
  State<ListInfo> createState() => _ListInfoState();
}

class _ListInfoState extends State<ListInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFFEBEBEB),
        padding: PaddingColumn.screen,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCard(
                child: Padding(
                    padding: PaddingColumn.screen,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ViewText(
                                viewLabel: 'Nomor',
                                viewValue:
                                    widget.data['wo_no']?.toString() ?? '-'),
                            Text(
                                'Dibuat pada ${widget.data['wo_date'] != null ? DateFormat("dd MMMM yyyy").format(DateTime.parse(widget.data['wo_date'])) : '-'} oleh ${widget.data['user']?['name'] ?? ''}')
                          ].separatedBy(SizedBox(
                            height: 8,
                          )),
                        ),
                        CustomBadge(title: widget.data['status'] ?? '-'),
                      ].separatedBy(SizedBox(
                        width: 16,
                      )),
                    )),
              ),
              CustomCard(
                child: Padding(
                    padding: PaddingColumn.screen,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ViewText(
                                viewLabel: 'Jumlah Greige',
                                viewValue: widget.data['greige_qty'] != null &&
                                        widget.data['greige_qty']
                                            .toString()
                                            .isNotEmpty
                                    ? '${NumberFormat("#,###.#").format(double.tryParse(widget.data['greige_qty'].toString()) ?? 0)} ${widget.data['greige_unit']?['code'] ?? ''}'
                                    : '-'),
                            ViewText(
                                viewLabel: 'Catatan',
                                viewValue: widget.data?['notes'] ?? '-')
                          ].separatedBy(SizedBox(
                            height: 8,
                          )),
                        )
                      ],
                    )),
              ),
              CustomCard(
                child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(tabs: [
                          Tab(
                            text: 'Barang',
                          ),
                          Tab(
                            text: 'Lampiran',
                          )
                        ]),
                        SizedBox(
                          height: 400,
                          child: TabBarView(children: [
                            ItemTab(
                              data: widget.data,
                            ),
                            AttachmentTab(
                              existingAttachment: widget.existingAttachment,
                            )
                          ]),
                        )
                      ],
                    )),
              )
            ].separatedBy(SizedBox(
              height: 16,
            )),
          ),
        ));
  }
}
