import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class InfoTab extends StatefulWidget {
  final data;

  const InfoTab({super.key, this.data});

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
            child: CustomCard(
              child: Container(
                  padding: PaddingColumn.screen,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ViewText(
                          viewLabel: 'Nomor',
                          viewValue: widget.data['wo_no']?.toString() ?? '-'),
                      ViewText(
                          viewLabel: 'User',
                          viewValue: '${widget.data['user']?['name'] ?? ''}'),
                      ViewText(
                          viewLabel: 'Tanggal',
                          viewValue: widget.data['wo_date'] != null
                              ? DateFormat("dd MMM yyyy").format(
                                  DateTime.parse(widget.data['wo_date']))
                              : '-'),
                      ViewText(
                          viewLabel: 'Catatan',
                          viewValue: widget.data?['notes']),
                      ViewText(
                          viewLabel: 'Jumlah Greige',
                          viewValue: widget.data['greige_qty'] != null &&
                                  widget.data['greige_qty']
                                      .toString()
                                      .isNotEmpty
                              ? '${NumberFormat("#,###.#").format(double.tryParse(widget.data['greige_qty'].toString()) ?? 0)} ${widget.data['greige_unit']?['code'] ?? ''}'
                              : '-'),
                      ViewText(
                          viewLabel: 'Status',
                          viewValue: widget.data?['status']),
                    ].separatedBy(SizedBox(
                      height: 16,
                    )),
                  )),
            ),
          )
        : Container(
            color: const Color(0xFFEBEBEB),
            alignment: Alignment.center,
            child: NoData(),
          );
  }
}
