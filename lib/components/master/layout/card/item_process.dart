import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dashboard_card.dart';
import 'package:textile_tracking/components/home/dashboard/card/process_card.dart';
import 'package:textile_tracking/components/master/layout/card/custom_badge.dart';
import 'package:textile_tracking/components/master/text/clickable_text.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class ItemProcess extends StatefulWidget {
  final item;

  const ItemProcess({super.key, this.item});

  @override
  State<ItemProcess> createState() => _ItemProcessState();
}

class _ItemProcessState extends State<ItemProcess> {
  @override
  Widget build(BuildContext context) {
    final sortingGrades = widget.item['processes']['sorting']?['grades'] ?? [];
    final packingGrades = widget.item['processes']['packing']?['grades'] ?? [];

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: CustomTheme().padding('card'),
            child: Column(
              children: [
                Row(
                  children: [
                    ClickableText(
                      text: widget.item['wo_no'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkOrderDetail(
                              id: widget.item['id'].toString(),
                            ),
                          ),
                        );
                      },
                    ),
                    CustomBadge(
                      withStatus: true,
                      rework: true,
                      title: widget.item['status'],
                      status: widget.item['status'],
                    ),
                  ].separatedBy(CustomTheme().hGap('lg')),
                ),
                Row(
                  children: [
                    ViewText(
                      viewLabel: 'SPK',
                      viewValue: widget.item['spk_no'],
                    ),
                    ViewText(
                      viewLabel: 'Tanggal',
                      viewValue: DateFormat("dd MMMM yyyy")
                          .format(DateTime.parse(widget.item['wo_date'])),
                    ),
                    ViewText(
                      viewLabel: 'Qty Material',
                      viewValue: (widget.item['wo_qty']).toString(),
                    ),
                    ViewText(
                      viewLabel: 'Qty Greige',
                      viewValue: (widget.item['greige_qty']).toString(),
                    ),
                  ].separatedBy(CustomTheme().hGap('2xl')),
                ),
              ].separatedBy(CustomTheme().vGap('2xl')),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: CustomTheme().padding('card'),
            child: Row(
              children: [
                _buildCard('Dyeing', 'dyeing', Icons.color_lens_outlined, true,
                    false, false, false, null),
                _buildCard('Press', 'press', Icons.dry_outlined, false, true,
                    false, false, null),
                _buildCard('Tumbler', 'tumbler', Icons.dry_cleaning_outlined,
                    false, true, false, false, null),
                _buildCard('Stenter', 'stenter', Icons.air, false, true, false,
                    false, null),
                _buildCard('Long Slitting', 'long-sitting', Icons.cut_outlined,
                    false, true, false, false, null),
                _buildCard('Long Hemming', 'long-hemming', Icons.link_outlined,
                    false, true, false, false, null),
                _buildCard('Cross Cutting', 'cross-cutting', Icons.cut, false,
                    true, true, false, null),
                _buildCard('Sewing', 'sewing', Icons.link_outlined, false, true,
                    true, false, null),
                _buildCard('Embroidery', 'embroidery', Icons.numbers_outlined,
                    false, true, true, false, null),
                _buildCard('Printing', 'printing', Icons.print, false, true,
                    true, false, null),
                _buildCard('Sorting', 'sorting', Icons.sort, false, false,
                    false, true, sortingGrades),
                _buildCard(
                    'Packing',
                    'packing',
                    Icons.stacked_bar_chart_outlined,
                    false,
                    false,
                    false,
                    true,
                    packingGrades),
              ].separatedBy(CustomTheme().hGap('2xl')),
            ),
          )
        ].separatedBy(CustomTheme().vGap('lg')),
      ),
    );
  }

  Widget _buildCard(
      title, item, icon, withQty, withWeight, withItemQty, withGrades, grades) {
    return ProcessCard(
      status: widget.item['processes'][item]['status'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon),
                  Text(title),
                ].separatedBy(CustomTheme().hGap('lg')),
              ),
              CustomBadge(
                withStatus: true,
                rework: true,
                title: widget.item['processes'][item]['status'],
                status: widget.item['processes'][item]['status'],
              ),
            ].separatedBy(CustomTheme().hGap('2xl')),
          ),
          if (withQty)
            Row(
              children: [
                Icon(Icons.shopping_cart_outlined),
                Text(widget.item['processes'][item]['qty'] != null
                    ? '${widget.item['processes'][item]['qty']} ${widget.item['processes'][item]['unit']['code']}'
                    : '-'),
              ].separatedBy(CustomTheme().vGap('lg')),
            ),
          if (withItemQty)
            Row(
              children: [
                Icon(Icons.shopping_cart_outlined),
                Text(widget.item['processes'][item]['item_qty'] != null
                    ? '${widget.item['processes'][item]['item_qty']} ${widget.item['processes'][item]['item_unit']['code']}'
                    : '-'),
              ].separatedBy(CustomTheme().vGap('lg')),
            ),
          if (withWeight)
            Row(
              children: [
                Icon(Icons.line_weight_outlined),
                Text(widget.item['processes'][item]['weight'] != null
                    ? '${widget.item['processes'][item]['weight']} ${widget.item['processes'][item]['weight_unit']['code']}'
                    : '-'),
              ].separatedBy(CustomTheme().vGap('lg')),
            ),
          if (withGrades)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: grades.isNotEmpty
                  ? grades.map<Widget>((grade) {
                      return Text(
                        'Grade ${grade['item_grade']['code']}: ${grade['qty']} ${grade['unit']['code']}',
                      );
                    }).toList()
                  : [const Text('-')],
            )
        ].separatedBy(CustomTheme().vGap('lg')),
      ),
    );
  }
}
