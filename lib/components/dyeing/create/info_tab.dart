import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
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
    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ViewText(
                viewLabel: 'Nomor',
                viewValue: widget.data['wo_no']?.toString() ?? '-'),
            ViewText(
                viewLabel: 'User',
                viewValue: widget.data['user']?['name']?.toString() ?? '-'),
            ViewText(
                viewLabel: 'Tanggal',
                viewValue: widget.data['wo_date'] != null
                    ? DateFormat("dd MMM yyyy")
                        .format(DateTime.parse(widget.data['wo_date']))
                    : '-'),
            ViewText(
                viewLabel: 'Catatan',
                viewValue: widget.data['notes']?.toString() ?? '-'),
            ViewText(
                viewLabel: 'Jumlah Greige',
                viewValue: widget.data['greige_qty'] != null &&
                        widget.data['greige_qty'].toString().isNotEmpty
                    ? '${NumberFormat("#,###.#").format(double.tryParse(widget.data['greige_qty'].toString()) ?? 0)} ${widget.data['greige_unit']?['code'] ?? ''}'
                    : '-'),
            ViewText(
                viewLabel: 'Status',
                viewValue: widget.data['status']?.toString() ?? '-'),
          ].separatedBy(const SizedBox(height: 16)),
        ));
  }
}
