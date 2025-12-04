import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ItemProcess extends StatefulWidget {
  final item;

  const ItemProcess({super.key, this.item});

  @override
  State<ItemProcess> createState() => _ItemProcessState();
}

class _ItemProcessState extends State<ItemProcess> {
  @override
  Widget build(BuildContext context) {
    final sortingGrades = widget.item.processes['sorting']?['grades'] ?? [];
    final packingGrades = widget.item.processes['packing']?['grades'] ?? [];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: PaddingColumn.screen,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.item.wo_no,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    CustomBadge(
                      withStatus: true,
                      icon: Icons.check_circle_outline,
                      title: widget.item.status,
                      color: widget.item.status == 'Menunggu Diproses'
                          ? Color(0xffdbeaff)
                          : widget.item.status == 'Diproses'
                              ? Color(0xFFfff3c6)
                              : Color(0xffd1fae4),
                      withDifferentColor: true,
                    ),
                  ].separatedBy(SizedBox(
                    width: 8,
                  )),
                ),
                Row(
                  children: [
                    ViewText(
                      viewLabel: 'SPK',
                      viewValue: widget.item.spk_no,
                    ),
                    ViewText(
                      viewLabel: 'Tanggal',
                      viewValue: DateFormat("dd MMMM yyyy")
                          .format(DateTime.parse(widget.item.wo_date)),
                    ),
                    ViewText(
                      viewLabel: 'Qty Material',
                      viewValue: (widget.item.wo_qty).toString(),
                    ),
                    ViewText(
                      viewLabel: 'Qty Greige',
                      viewValue: (widget.item.greige_qty).toString(),
                    ),
                  ].separatedBy(SizedBox(
                    width: 16,
                  )),
                ),
              ].separatedBy(SizedBox(
                height: 8,
              )),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: PaddingColumn.screen,
              child: Row(
                children: [
                  _buildCard('Dyeing', 'dyeing', Icons.color_lens_outlined,
                      true, false, false, false, null),
                  _buildCard(
                      'Press Tumbler',
                      'press-tumbler',
                      Icons.content_copy_rounded,
                      false,
                      true,
                      false,
                      false,
                      null),
                  _buildCard('Stenter', 'stenter', Icons.air, false, true,
                      false, false, null),
                  _buildCard(
                      'Long Sitting',
                      'long-sitting',
                      Icons.content_paste_outlined,
                      false,
                      true,
                      false,
                      false,
                      null),
                  _buildCard('Long Hemming', 'long-sitting', Icons.cut, false,
                      true, false, false, null),
                  _buildCard('Cross Cutting', 'cross-cutting', Icons.cut, false,
                      true, true, false, null),
                  _buildCard('Sewing', 'sewing', Icons.link_outlined, false,
                      true, true, false, null),
                  _buildCard('Embroidery', 'embroidery', Icons.link_outlined,
                      false, true, true, false, null),
                  _buildCard('Printing', 'printing', Icons.print, false, true,
                      true, false, null),
                  _buildCard('Sorting', 'sorting', Icons.sort, false, false,
                      false, true, sortingGrades),
                  _buildCard('Packing', 'packing', Icons.sort, false, false,
                      false, true, packingGrades),
                ].separatedBy(SizedBox(
                  width: 8,
                )),
              ),
            ),
          )
        ].separatedBy(SizedBox(
          height: 8,
        )),
      ),
    );
  }

  Widget _buildCard(
      title, item, icon, withQty, withWeight, withItemQty, withGrades, grades) {
    return Card(
      color: widget.item.processes[item]['status'] == 'Menunggu Diproses'
          ? Color(0xFFfafafa)
          : widget.item.processes[item]['status'] == 'Diproses'
              ? Color(0xFFfffbea)
              : widget.item.processes[item]['status'] == 'Selesai'
                  ? Color(0xfff0fdf4)
                  : Color(0xfff1f4fd),
      child: SizedBox(
        height: 150,
        width: 380,
        child: Padding(
          padding: PaddingColumn.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon),
                      Text(title),
                    ].separatedBy(SizedBox(
                      width: 8,
                    )),
                  ),
                  CustomBadge(
                    withStatus: true,
                    icon: Icons.check_circle_outline,
                    title: widget.item.processes[item]['status'],
                    withDifferentColor: true,
                    color: widget.item.processes[item]['status'] ==
                            'Menunggu Diproses'
                        ? Color(0xFFf1f5f9)
                        : widget.item.processes[item]['status'] == 'Diproses'
                            ? Color(0xFFfff3c6)
                            : Color(0xffd1fae4),
                  ),
                ],
              ),
              if (withQty)
                Row(
                  children: [
                    Icon(Icons.shopping_cart_outlined),
                    Text(widget.item.processes[item]['qty'] != null
                        ? '${widget.item.processes[item]['qty']} ${widget.item.processes[item]['unit']['code']}'
                        : '-'),
                  ].separatedBy(SizedBox(
                    width: 8,
                  )),
                ),
              if (withItemQty)
                Row(
                  children: [
                    Icon(Icons.shopping_cart_outlined),
                    Text(widget.item.processes[item]['item_qty'] != null
                        ? '${widget.item.processes[item]['item_qty']} ${widget.item.processes[item]['item_unit']['code']}'
                        : '-'),
                  ].separatedBy(SizedBox(
                    width: 8,
                  )),
                ),
              if (withWeight)
                Row(
                  children: [
                    Icon(Icons.line_weight_outlined),
                    Text(widget.item.processes[item]['weight'] != null
                        ? '${widget.item.processes[item]['weight']} ${widget.item.processes[item]['weight_unit']['code']}'
                        : '-'),
                  ].separatedBy(SizedBox(
                    width: 8,
                  )),
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
            ].separatedBy(SizedBox(
              height: 8,
            )),
          ),
        ),
      ),
    );
  }
}
