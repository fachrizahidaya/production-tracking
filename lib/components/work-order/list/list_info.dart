import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/info_tab.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:html/parser.dart' as html_parser;

class ListInfo extends StatefulWidget {
  final data;

  const ListInfo({
    super.key,
    this.data,
  });

  @override
  State<ListInfo> createState() => _ListInfoState();
}

class _ListInfoState extends State<ListInfo> {
  String htmlToPlainText(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return SingleChildScrollView(
          child: InfoTab(
            data: widget.data,
            isTablet: isTablet,
            label: null,
          ),
        );
      },
    );

    // CustomCard(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 widget.data['wo_no']?.toString() ?? '-',
    //                 style: TextStyle(
    //                     fontSize: CustomTheme().fontSize('lg'),
    //                     fontWeight: CustomTheme().fontWeight('bold')),
    //               ),
    //               if (isPortrait)
    //                 CustomBadge(
    //                   title: widget.data['status'] ?? '-',
    //                   status: widget.data['status'],
    //                   withStatus: true,
    //                 ),
    //               Text(
    //                   'Dibuat pada ${widget.data['wo_date'] != null ? DateFormat("dd MMMM yyyy").format(DateTime.parse(widget.data['wo_date'])) : '-'} oleh ${widget.data['user']?['name'] ?? ''}')
    //             ].separatedBy(CustomTheme().vGap('sm')),
    //           ),
    //           if (!isPortrait)
    //             CustomBadge(
    //               title: widget.data['status'] ?? '-',
    //               status: widget.data['status'],
    //               withStatus: true,
    //             ),
    //         ],
    //       ),
    //       ViewText(
    //           viewLabel: 'Qty Greige',
    //           viewValue: widget.data['greige_qty'] != null &&
    //                   widget.data['greige_qty'].toString().isNotEmpty
    //               ? '${NumberFormat("#,###.#").format(double.tryParse(widget.data['greige_qty'].toString()) ?? 0)} ${widget.data['greige_unit']?['code'] ?? ''}'
    //               : '-')
    //     ].separatedBy(CustomTheme().vGap('xl')),
    //   ),
    // );
  }
}
