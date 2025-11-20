import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';

class ItemProcess extends StatefulWidget {
  final item;

  const ItemProcess({super.key, this.item});

  @override
  State<ItemProcess> createState() => _ItemProcessState();
}

class _ItemProcessState extends State<ItemProcess> {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [],
          ),
          Padding(
            padding: PaddingColumn.screen,
            child: Column(
              children: [
                Text(widget.item.spk_no),
                Text(widget.item.wo_no),
                Text(widget.item.status),
                Text(widget.item.wo_date),
                Text((widget.item.wo_qty).toString()),
                Text((widget.item.greige_qty).toString()),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: PaddingColumn.screen,
                  child: Column(
                    children: [
                      Text('Dyeing'),
                      Text(widget.item.processes['dyeing']['status']),
                      Text(widget.item.processes['dyeing']['qty'] != null
                          ? '${widget.item.processes['dyeing']['qty']} ${widget.item.processes['dyeing']['unit']['code']}'
                          : '-')
                    ],
                  ),
                ),
                Padding(
                  padding: PaddingColumn.screen,
                  child: Column(
                    children: [
                      Text('Press Tumbler'),
                      Text(widget.item.processes['press-tumbler']['status']),
                      Text(widget.item.processes['press-tumbler']['qty'] != null
                          ? '${widget.item.processes['press-tumbler']['qty']} ${widget.item.processes['press-tumbler']['unit']['code']}'
                          : '-')
                    ],
                  ),
                ),
                Padding(
                  padding: PaddingColumn.screen,
                  child: Column(
                    children: [
                      Text('Stenter'),
                      Text(widget.item.processes['stenter']['status']),
                      Text(widget.item.processes['stenter']['qty'] != null
                          ? '${widget.item.processes['stenter']['qty']} ${widget.item.processes['stenter']['unit']['code']}'
                          : '-')
                    ],
                  ),
                ),
                Padding(
                  padding: PaddingColumn.screen,
                  child: Column(
                    children: [
                      Text('Long Sitting'),
                      Text(widget.item.processes['long-sitting']['status']),
                      Text(widget.item.processes['long-sitting']['qty'] != null
                          ? '${widget.item.processes['long-sitting']['qty']} ${widget.item.processes['long-sitting']['unit']['code']}'
                          : '-')
                    ],
                  ),
                ),
                Padding(
                  padding: PaddingColumn.screen,
                  child: Column(
                    children: [
                      Text('Long Hemming'),
                      Text(widget.item.processes['long-hemming']['status']),
                      Text(widget.item.processes['long-hemming']['qty'] != null
                          ? '${widget.item.processes['long-hemming']['qty']} ${widget.item.processes['long-hemming']['unit']['code']}'
                          : '-')
                    ],
                  ),
                ),
                Padding(
                  padding: PaddingColumn.screen,
                  child: Column(
                    children: [
                      Text('Cross Cutting'),
                      Text(widget.item.processes['cross-cutting']['status']),
                      Text(widget.item.processes['cross-cutting']['qty'] != null
                          ? '${widget.item.processes['cross-cutting']['qty']} ${widget.item.processes['cross-cutting']['unit']['code']}'
                          : '-')
                    ],
                  ),
                ),
                Padding(
                  padding: PaddingColumn.screen,
                  child: Column(
                    children: [
                      Text('Sewing'),
                      Text(widget.item.processes['sewing']['status']),
                      Text(widget.item.processes['sewing']['qty'] != null
                          ? '${widget.item.processes['sewing']['qty']} ${widget.item.processes['sewing']['unit']['code']}'
                          : '-')
                    ],
                  ),
                ),
                Padding(
                  padding: PaddingColumn.screen,
                  child: Column(
                    children: [
                      Text('Embroidery'),
                      Text(widget.item.processes['embroidery']['status']),
                      Text(widget.item.processes['embroidery']['qty'] != null
                          ? '${widget.item.processes['embroidery']['qty']} ${widget.item.processes['embroidery']['unit']['code']}'
                          : '-')
                    ],
                  ),
                ),
                Padding(
                  padding: PaddingColumn.screen,
                  child: Column(
                    children: [
                      Text('Printing'),
                      Text(widget.item.processes['printing']['status']),
                      Text(widget.item.processes['printing']['qty'] != null
                          ? '${widget.item.processes['printing']['qty']} ${widget.item.processes['printing']['unit']['code']}'
                          : '-')
                    ],
                  ),
                ),
                Padding(
                  padding: PaddingColumn.screen,
                  child: Column(
                    children: [
                      Text('Sorting'),
                      Text(widget.item.processes['sorting']['status']),
                      Text(widget.item.processes['sorting']['qty'] != null
                          ? '${widget.item.processes['sorting']['qty']} ${widget.item.processes['sorting']['unit']['code']}'
                          : '-')
                    ],
                  ),
                ),
                Padding(
                  padding: PaddingColumn.screen,
                  child: Column(
                    children: [
                      Text('Packing'),
                      Text(widget.item.processes['packing']['status']),
                      Text(widget.item.processes['packing']['qty'] != null
                          ? '${widget.item.processes['packing']['qty']} ${widget.item.processes['packing']['unit']['code']}'
                          : '-')
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
