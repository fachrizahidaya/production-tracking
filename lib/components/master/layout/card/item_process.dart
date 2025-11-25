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
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: Colors.grey.shade400, width: 1.0)),
                    child: Padding(
                      padding: PaddingColumn.screen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomBadge(
                                withStatus: true,
                                icon: Icons.check_circle_outline,
                                title: widget.item.processes['dyeing']
                                    ['status'],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.invert_colors_on_outlined),
                              Text('Dyeing'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          ),
                          Row(
                            children: [
                              Icon(Icons.shopping_cart_outlined),
                              Text(widget.item.processes['dyeing']['qty'] !=
                                      null
                                  ? '${widget.item.processes['dyeing']['qty']} ${widget.item.processes['dyeing']['unit']['code']}'
                                  : '-'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          )
                        ].separatedBy(SizedBox(
                          height: 8,
                        )),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: Colors.grey.shade400, width: 1.0)),
                    child: Padding(
                      padding: PaddingColumn.screen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomBadge(
                                withStatus: true,
                                icon: Icons.check_circle_outline,
                                title: widget.item.processes['press-tumbler']
                                    ['status'],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.content_copy_rounded),
                              Text('Press Tumbler'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          ),
                          Row(
                            children: [
                              Icon(Icons.shopping_cart_outlined),
                              Text(widget.item.processes['press-tumbler']
                                          ['weight'] !=
                                      null
                                  ? '${widget.item.processes['press-tumbler']['weight']} ${widget.item.processes['press-tumbler']['weight_unit']['code']}'
                                  : '-'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          )
                        ].separatedBy(SizedBox(
                          height: 8,
                        )),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: Colors.grey.shade400, width: 1.0)),
                    child: Padding(
                      padding: PaddingColumn.screen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomBadge(
                                withStatus: true,
                                icon: Icons.check_circle_outline,
                                title: widget.item.processes['stenter']
                                    ['status'],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.air),
                              Text('Stenter'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          ),
                          Row(
                            children: [
                              Icon(Icons.shopping_cart_outlined),
                              Text(widget.item.processes['stenter']['weight'] !=
                                      null
                                  ? '${widget.item.processes['stenter']['weight']} ${widget.item.processes['stenter']['weight_unit']['code']}'
                                  : '-'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          )
                        ].separatedBy(SizedBox(
                          height: 8,
                        )),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: Colors.grey.shade400, width: 1.0)),
                    child: Padding(
                      padding: PaddingColumn.screen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomBadge(
                                withStatus: true,
                                icon: Icons.check_circle_outline,
                                title: widget.item.processes['long-sitting']
                                    ['status'],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.content_paste_outlined),
                              Text('Long Sitting'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          ),
                          Row(
                            children: [
                              Icon(Icons.shopping_cart_outlined),
                              Text(widget.item.processes['long-sitting']
                                          ['weight'] !=
                                      null
                                  ? '${widget.item.processes['long-sitting']['weight']} ${widget.item.processes['long-sitting']['weight_unit']['code']}'
                                  : '-'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          )
                        ].separatedBy(SizedBox(
                          height: 8,
                        )),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: Colors.grey.shade400, width: 1.0)),
                    child: Padding(
                      padding: PaddingColumn.screen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomBadge(
                                withStatus: true,
                                icon: Icons.check_circle_outline,
                                title: widget.item.processes['long-hemming']
                                    ['status'],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.cut),
                              Text('Long Hemming'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          ),
                          Row(
                            children: [
                              Icon(Icons.shopping_cart_outlined),
                              Text(widget.item.processes['long-hemming']
                                          ['weight'] !=
                                      null
                                  ? '${widget.item.processes['long-hemming']['weight']} ${widget.item.processes['long-hemming']['weight_unit']['code']}'
                                  : '-'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          )
                        ].separatedBy(SizedBox(
                          height: 8,
                        )),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: Colors.grey.shade400, width: 1.0)),
                    child: Padding(
                      padding: PaddingColumn.screen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomBadge(
                                withStatus: true,
                                icon: Icons.check_circle_outline,
                                title: widget.item.processes['cross-cutting']
                                    ['status'],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.cut),
                              Text('Cross Cutting'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          ),
                          Row(
                            children: [
                              Icon(Icons.shopping_cart_outlined),
                              Text(widget.item.processes['cross-cutting']
                                          ['item_qty'] !=
                                      null
                                  ? '${widget.item.processes['cross-cutting']['item_qty']} ${widget.item.processes['cross-cutting']['item_unit']['code']}'
                                  : '-'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          ),
                          Row(
                            children: [
                              Icon(Icons.shopping_cart_outlined),
                              Text(widget.item.processes['cross-cutting']
                                          ['weight'] !=
                                      null
                                  ? '${widget.item.processes['cross-cutting']['weight']} ${widget.item.processes['cross-cutting']['weight_unit']['code']}'
                                  : '-'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          )
                        ].separatedBy(SizedBox(
                          height: 8,
                        )),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: Colors.grey.shade400, width: 1.0)),
                    child: Padding(
                      padding: PaddingColumn.screen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomBadge(
                                withStatus: true,
                                icon: Icons.check_circle_outline,
                                title: widget.item.processes['sewing']
                                    ['status'],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.link_outlined),
                              Text('Sewing'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          ),
                          Row(
                            children: [
                              Icon(Icons.shopping_cart_outlined),
                              Text(widget.item.processes['sewing']
                                          ['item_qty'] !=
                                      null
                                  ? '${widget.item.processes['sewing']['item_qty']} ${widget.item.processes['sewing']['item_unit']['code']}'
                                  : '-'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          ),
                          Row(
                            children: [
                              Icon(Icons.shopping_cart_outlined),
                              Text(widget.item.processes['sewing']['weight'] !=
                                      null
                                  ? '${widget.item.processes['sewing']['weight']} ${widget.item.processes['sewing']['weight_unit']['code']}'
                                  : '-'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          )
                        ].separatedBy(SizedBox(
                          height: 8,
                        )),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: Colors.grey.shade400, width: 1.0)),
                    child: Padding(
                      padding: PaddingColumn.screen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomBadge(
                                withStatus: true,
                                icon: Icons.check_circle_outline,
                                title: widget.item.processes['embroidery']
                                    ['status'],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.color_lens_outlined),
                              Text('Embroidery'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          ),
                          Row(
                            children: [
                              Icon(Icons.shopping_cart_outlined),
                              Text(widget.item.processes['embroidery']
                                          ['item_qty'] !=
                                      null
                                  ? '${widget.item.processes['embroidery']['item_qty']} ${widget.item.processes['embroidery']['item_unit']['code']}'
                                  : '-'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          ),
                          Row(
                            children: [
                              Icon(Icons.shopping_cart_outlined),
                              Text(widget.item.processes['embroidery']
                                          ['weight'] !=
                                      null
                                  ? '${widget.item.processes['embroidery']['weight']} ${widget.item.processes['embroidery']['weight_unit']['code']}'
                                  : '-'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          )
                        ].separatedBy(SizedBox(
                          height: 8,
                        )),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: Colors.grey.shade400, width: 1.0)),
                    child: Padding(
                      padding: PaddingColumn.screen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomBadge(
                                withStatus: true,
                                icon: Icons.check_circle_outline,
                                title: widget.item.processes['printing']
                                    ['status'],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.print_outlined),
                              Text('Printing'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          ),
                          Row(
                            children: [
                              Icon(Icons.shopping_cart_outlined),
                              Text(widget.item.processes['printing']
                                          ['item_qty'] !=
                                      null
                                  ? '${widget.item.processes['printing']['item_qty']} ${widget.item.processes['printing']['item_unit']['code']}'
                                  : '-'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          ),
                          Row(
                            children: [
                              Icon(Icons.shopping_cart_outlined),
                              Text(widget.item.processes['printing']
                                          ['weight'] !=
                                      null
                                  ? '${widget.item.processes['printing']['weight']} ${widget.item.processes['printing']['weight_unit']['code']}'
                                  : '-'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          )
                        ].separatedBy(SizedBox(
                          height: 8,
                        )),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: Colors.grey.shade400, width: 1.0)),
                    child: Padding(
                      padding: PaddingColumn.screen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomBadge(
                                withStatus: true,
                                icon: Icons.check_circle_outline,
                                title: widget.item.processes['sorting']
                                    ['status'],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.sort),
                              Text('Sorting'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: sortingGrades.isNotEmpty
                                ? sortingGrades.map<Widget>((grade) {
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
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: Colors.grey.shade400, width: 1.0)),
                    child: Padding(
                      padding: PaddingColumn.screen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomBadge(
                                withStatus: true,
                                icon: Icons.check_circle_outline,
                                title: widget.item.processes['packing']
                                    ['status'],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.stacked_bar_chart),
                              Text('Packing'),
                            ].separatedBy(SizedBox(
                              width: 8,
                            )),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: packingGrades.isNotEmpty
                                ? packingGrades.map<Widget>((grade) {
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
}
